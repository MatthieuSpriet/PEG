//
//  SPIRStoreApplicationListRequest.m
//  SPIR
//
//  Created by Frédéric JOUANNAUD on 15/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "SPIRStoreApplicationListRequest.h"
#import "JSONKit.h"
#import "UIDevice-Hardware.h"
#import "SPIRApplication.h"
#import "SPIRMobileInstallationProxy.h"
#import "NSString+MD5.h"
#import "SPIRFunction.h"
#import "SPIROrderedDictionary.h"

static ASIDownloadCache *carrouselCache = nil;

// ajout pour que LLVM ne gueule pas...
@interface ASIHTTPRequest ()

- (void)reportFinished;
- (void)reportFailure;
- (void)setResponseStatusCode:(NSInteger)status;
- (void)setDidUseCachedResponse:(BOOL)yesOrNo;

@end


@interface SPIRStoreApplicationListRequest ()

+ (NSString *)requestName;
+ (NSString *)requestCacheName;
+ (NSString *)requestCachePath;

+ (NSString *)responseHeadersCachePath;
+ (NSString *)responseStringCachePath;

+ (void)saveResponseData:(NSData *)data;
+ (void)saveResponseHeaders:(NSDictionary *)headers;
+ (NSData *)savedResponseData;
+ (NSDictionary *)savedResponseHeaders;

- (void)restoreRequestFromCache;

@end


@implementation SPIRStoreApplicationListRequest

#pragma mark - Override ASI for custom caching

- (void)reportFailure
{
	DLog(@"Failure");
	
	// vérification des données dans le cache
	if ([[self class] hasCache])
	{
		if ([self error].code == ASIRequestTimedOutErrorType || [self error].code == ASIConnectionFailureErrorType)
		{
			// on ne récupère le cache que si la requête échoue par time out ou problème de connection réseau --> des erreurs purement techniques réseau
			DLog(@"Récupération du cache !!!!!");
			[self restoreRequestFromCache];
			[super reportFinished];
			return;
		}
		else 
		{
			// si la requête échoue pour une autre raison que technique, on vide le cache.
			// cela évite des effets de bords si l'authentification échoue et que l'on présente les données du cache...
			[[self class] clearCache];
		}
	}
	
	// si pas de données dans le cache custom on appelle la méthode parente
	[super reportFailure];
}


#pragma mark -

+ (SPIRStoreApplicationListRequest *)request
{
	NSString *storeURL = [SPIRFunction endpointForFunction:PEG_ENDPOINT_STORE_FUNCTION];
	
#ifdef DEBUG
	storeURL = [storeURL stringByAppendingString:@"rest_dev.php/application"];
#else
	storeURL = [storeURL stringByAppendingString:@"rest.php/application"];
#endif
	
	DLog(@"storeURL : %@", storeURL);
	SPIRStoreApplicationListRequest *request = [SPIRStoreApplicationListRequest requestWithURL:[NSURL URLWithString:storeURL]];
	
	[request setDownloadCache:[[self class] carrouselCache]];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	
	return request;
}

- (NSArray *)processResponse
{
	[self saveRequestToCache];
	
	NSDictionary *jsonData = [super processResponseWithString:[self responseString]];
	
	DLog(@"jsonData : %@", jsonData);
	
	NSArray *jsonApplications = [jsonData objectForKey:@"apps"];
	SPIROrderedDictionary *applications = [[SPIROrderedDictionary alloc] initWithCapacity:[jsonApplications count]];
	
	for (NSDictionary *jsonApplication in jsonApplications) 
	{
		DLog(@"\n\n");
		SPIRApplication *application = [[SPIRApplication alloc] initWithDictionary:jsonApplication];
		if (application != nil)
		{	
			NSDictionary *app = [SPIRMobileInstallationProxy findAppForIdentifier:application.bundleIdentifier];
			
			if (app == nil)
			{
				// l'application n'a pas encore été installé, on propose de l'installer
				application.status = SPIRApplicationStatusInstall;
			}
			else
			{
				DLog(@"restNumber : %@", NSStringFromSPIRApplicationVersion(application.version));
				
				DLog(@"SPIRBundleFullVersionString : %@", [app objectForKey:@"SPIRBundleFullVersionString"]);
				SPIRApplicationVersion mipVersion = SPIRApplicationVersionFromString([app objectForKey:@"SPIRBundleFullVersionString"]);
				DLog(@"mipVersion : %@", NSStringFromSPIRApplicationVersion(mipVersion));
				
				if (SPIRApplicationVersionCompare(mipVersion, application.version) == NSOrderedAscending)
				{
					// le numéro de version est supérieur, il s'agit d'une mise à jour
					application.status = SPIRApplicationStatusUpdate;
				}
				else
				{
					application.status = SPIRApplicationStatusInstalled;
				}
			}
			
			SPIRApplication *existingApplication = [applications objectForKey:application.bundleIdentifier];
			if (existingApplication != nil)
			{
				if (SPIRApplicationVersionCompare(existingApplication.version, application.version) == NSOrderedAscending)
				{
					DLog(@"Remplacement de version");
					[applications setObject:application forKey:application.bundleIdentifier];
					//DLog(@"existingApplication %@, %@, %@, %@", application.name, application.version, application.bundleIdentifier, application.updateType == SPIRApplicationUpdateTypeMajor ? @"Major" : @"Minor");
				}
				else
				{
					DLog(@"Pas remplacement version");
				}
			}
			else
			{
				[applications setObject:application forKey:application.bundleIdentifier];
				//DLog(@"applications %@, %@, %@, %@", application.name, application.version, application.bundleIdentifier, application.updateType == SPIRApplicationUpdateTypeMajor ? @"Major" : @"Minor");
			}
		}
		DLog(@"\n\n");
	}	

	NSArray *result = [applications allValues];
					
	DLog(@"result : %@", result);
	return result;
}

#pragma mark - Cache / Configuration

+ (NSString *)requestName
{
	return NSStringFromClass([self class]);
}

+ (NSString *)requestCacheName
{
	return @"fr.spir.carrousel";
}

+ (NSString *)requestCachePath
{
	NSString *cachePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[[self class] requestCacheName]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath])
	{
		// création du répertoire cache s'il n'existe pas
		[[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	return cachePath;
}

+ (NSString *)responseStringCachePath
{
	return [[[self class] requestCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.response", [[self class] requestName]]];
}

+ (NSString *)responseHeadersCachePath
{
	return [[[self class] requestCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cachedheaders", [[self class] requestName]]];
}


#pragma mark - Cache / Sauvegarde

- (void)saveRequestToCache
{
	[[self class] saveResponseData:self.rawResponseData];
	[[self class] saveResponseHeaders:self.responseHeaders];
}

+ (void)saveResponseData:(NSData *)data
{
	NSString *responsePath = [[self class] responseStringCachePath];
	[data writeToFile:responsePath atomically:YES];
}

+ (void)saveResponseHeaders:(NSDictionary *)headers
{
	NSString *headersPath = [[self class] responseHeadersCachePath];
	[headers writeToFile:headersPath atomically:YES];
}


#pragma mark - Cache / Récupération

- (void)restoreRequestFromCache
{
	[super setResponseStatusCode:[[self.responseHeaders objectForKey:@"X-ASIHTTPRequest-Response-Status-Code"] intValue]];
	[super setDidUseCachedResponse:YES];
	[super setResponseHeaders:[[self class] savedResponseHeaders]];
	
	[super setContentLength:[[[self responseHeaders] objectForKey:@"Content-Length"] longLongValue]];
	[super setTotalBytesRead:[self contentLength]];
	[super setRawResponseData:[NSMutableData dataWithData:[[self class] savedResponseData]]];
	
	[super parseStringEncodingFromHeaders];
	
	//[super setResponseCookies:[NSHTTPCookie cookiesWithResponseHeaderFields:self.responseHeaders forURL:[self url]]];
}

+ (NSData *)savedResponseData
{
	NSString *responsePath = [[[self class] requestCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.response", [[self class] requestName]]];
	NSData *data = [[NSData alloc] initWithContentsOfFile:responsePath];
	DLog(@"%@", data);
	return data;
}

+ (NSDictionary *)savedResponseHeaders
{
	NSString *headersPath = [[[self class] requestCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.cachedheaders", [[self class] requestName]]];
	return [NSDictionary dictionaryWithContentsOfFile:headersPath];
}


#pragma mark - Cache / Vérification

+ (BOOL)hasCache
{
	return ([[NSFileManager defaultManager] fileExistsAtPath:[[self class] responseStringCachePath]] && [[NSFileManager defaultManager] fileExistsAtPath:[[self class] responseHeadersCachePath]]);
}


#pragma mark - Cache / Nettoyage

+ (void)clearCache
{
	[[NSFileManager defaultManager] removeItemAtPath:[[self class] responseStringCachePath] error:NULL];
	[[NSFileManager defaultManager] removeItemAtPath:[[self class] responseHeadersCachePath] error:NULL];
}


#pragma mark - Cache

+ (ASIDownloadCache *)carrouselCache
{
	if (!carrouselCache) 
	{
		@synchronized(self) 
		{
			if (!carrouselCache) 
			{
				carrouselCache = [[ASIDownloadCache alloc] init];
				[carrouselCache setStoragePath:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[[self class] requestCacheName]]];
				[carrouselCache setDefaultCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
			}
		}
	}
	return carrouselCache;
}

@end
