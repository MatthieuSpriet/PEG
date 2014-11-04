//
//  SQLIApplication.m
//  SQLIStore
//
//  Created by Antoine Marcadet on 21/02/11.
//  Copyright 2011 SQLI. All rights reserved.
//

#import "SPIRApplication.h"
#import "ASIDownloadCache.h"
#import "NSDictionary+ConvenientAccess.h"

const SPIRApplicationVersion SPIRApplicationVersionZero = { 0, 0, 0, 0 };

@implementation SPIRApplication


- (id)initWithDictionary:(NSDictionary *)dict
{
	if ((self = [super init]))
	{
		self.status				= SPIRApplicationStatusNone;
		
        self.name				= [dict trimmedStringForKey:@"name"];
        self.bundleIdentifier	= [dict trimmedStringForKey:@"identifier"];
	
		self.bundleShortVersion	= [dict trimmedStringForKey:@"version"];
		self.bundleBuildNumber	= [dict trimmedStringForKey:@"build"];
        self.bundleVersion		= [NSString stringWithFormat:@"%@ (%@)", self.bundleShortVersion, self.bundleBuildNumber];
		
		self.date				= [dict dateForKey:@"datetime" usingFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.manifest			= [dict trimmedURLForKey:@"manifest"];
        self.logoURL			= [dict trimmedURLForKey:@"logo"];
        self.company			= [dict trimmedStringForKey:@"company_name"];
        self.changelog			= [dict trimmedStringForKey:@"changelog"];
        self.filesize			= [dict integerForKey:@"filesize"];
        self.descriptionText	= [dict trimmedStringForKey:@"description"];
		self.storeId            = [dict trimmedStringForKey:@"version_id"];
	
		NSString *scheme		= [dict trimmedStringForKey:@"url_scheme"];
		if ([scheme characterAtIndex:[scheme length] - 1] != ':')
		{
			scheme = [scheme stringByAppendingString:@":"];
		}
		if ([scheme characterAtIndex:[scheme length] - 1] != '/')
		{
			scheme = [scheme stringByAppendingString:@"//"];
		}
		scheme = [scheme stringByAppendingString:@"?carousel=0"]; // pour skip le carousel quand on clique sur un logo d'app
		DLog(@"scheme = %@", scheme);
		
        self.urlScheme			= [NSURL URLWithString:scheme];
		self.updateType			= ([[dict trimmedStringForKey:@"version_type"] isEqualToString:@"majeur"] ? SPIRApplicationUpdateTypeMajor : SPIRApplicationUpdateTypeMinor);
	}
	return self;
}

- (void)setBundleVersion:(NSString *)_version
{
	if ([bundleVersion isEqualToString:_version])
	{
		return;
	}
	
	if (bundleVersion != nil)
	{
		bundleVersion = nil;
	}
	
	if (_version != nil)
	{
		bundleVersion = [_version copy];
		version = SPIRApplicationVersionFromString(bundleVersion);
		DLog(@"Version : string = %@, struct = %@", bundleVersion, NSStringFromSPIRApplicationVersion(version));
	}
}

- (NSString *)description
{
	NSString *strStatus = @"";
	switch (self.status) 
	{
		case SPIRApplicationStatusNone:
			strStatus = @"None";
			break;
		case SPIRApplicationStatusUpdate:
			strStatus = @"Update";
			break;
		case SPIRApplicationStatusInstall:
			strStatus = @"Install";
			break;
		case SPIRApplicationStatusInstalled:
			strStatus = @"Installed";
			break;
	}
	
	return [NSString stringWithFormat:@"<%@ %p> { name: %@, id: %@, version: %@, versionStruct: %@, status: %@, date: %@, manifest: %@, scheme: %@ }", 
			NSStringFromClass([self class]), 
			self, 
			self.name, 
			self.bundleIdentifier, 
			self.bundleVersion,
			NSStringFromSPIRApplicationVersion(self.version),
			strStatus,
			self.date,
			self.manifest,
			self.urlScheme];
}


#pragma mark - lazy image loading

#if 0	// pm140218 not used. le status de la variable imageRequest n'est pas clair (une property strong ?)
- (void)startDownloadWithDelegate:(id <SPIRApplicationDelegate>)aDelegate
{
	delegate = aDelegate;	
	if (logo != nil)
	{
		if (delegate != nil && [(NSObject *)delegate respondsToSelector:@selector(applicationLogoDidLoad:)])
		{
			[delegate applicationLogoDidLoad:self];
		}
	}
	else 
	{
		imageRequest = [ASIHTTPRequest requestWithURL:logoURL];
		[imageRequest setValidatesSecureCertificate:NO];
		[imageRequest setShouldAttemptPersistentConnection:NO];
//		[imageRequest setDownloadCache:[SPIRCarouselViewController carrouselCache]];
		[imageRequest setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
		[imageRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
		
		[imageRequest setCompletionBlock:^{
			UIImage *image = [[UIImage alloc] initWithData:[imageRequest responseData]];		
			logo = [image retain];
			[image release];
			
			if (delegate != nil && [(NSObject *)delegate respondsToSelector:@selector(applicationLogoDidLoad:)])
			{
				[delegate applicationLogoDidLoad:self];
			}
		}];
		
		[imageRequest setFailedBlock:^{
			NSError *requestError = [imageRequest error];
			DLog(@"requestError : %@", [requestError localizedDescription]);
		}];
		
		[imageRequest startAsynchronous];
	}
}

- (void)cancelDownload
{
	[imageRequest clearDelegatesAndCancel];	
    [imageRequest release];
	imageRequest = nil;
}
#endif


#pragma mark - Properties

@synthesize name;
@synthesize bundleIdentifier;
@synthesize bundleVersion;
@synthesize bundleShortVersion;
@synthesize bundleBuildNumber;
@synthesize version;
@synthesize date;
@synthesize manifest;
@synthesize logoURL;
@synthesize logo;
@synthesize company;
@synthesize changelog;
@synthesize status;
@synthesize filesize;
@synthesize descriptionText;
@synthesize storeId;
@synthesize indexOfLayerInCarousel;
@synthesize urlScheme;
@synthesize updateType;

@end


#pragma mark - C functions

SPIRApplicationVersion SPIRApplicationVersionFromString(NSString *string)
{
	SPIRApplicationVersion version = SPIRApplicationVersionZero;
	
	NSArray *fullComponents = [string componentsSeparatedByString:@" "];
	DLog(@"fullComponents : %@", fullComponents);
	
	NSInteger fullCount = [fullComponents count];
	switch (fullCount)
	{
		case 2:
		{
			NSString *buildString = [[fullComponents objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"()"]];
			DLog(@"buildString : %@", buildString);
			
			version.build = [buildString integerValue];
		}	
		case 1:
		{
			NSArray *versionComponents = [[fullComponents objectAtIndex:0] componentsSeparatedByString:@"."];
			DLog(@"versionComponents : %@", versionComponents);
			
			NSInteger versionCount = [versionComponents count];
			switch (versionCount)
			{
				case 3:
					version.fixes = [[versionComponents objectAtIndex:2] intValue];
				case 2:
					version.minor = [[versionComponents objectAtIndex:1] intValue];
				case 1:
					version.major = [[versionComponents objectAtIndex:0] intValue];
			}
		}
	}
	
	DLog(@"versionStruct : %@", NSStringFromSPIRApplicationVersion(version));
	return version;
}

NSString *NSStringFromSPIRApplicationVersion(SPIRApplicationVersion version)
{
	if (version.build == 0)
	{
		return [NSString stringWithFormat:@"%d.%d.%d", version.major, version.minor, version.fixes];
	}
	return [NSString stringWithFormat:@"%d.%d.%d (%d)", version.major, version.minor, version.fixes, version.build];
}

NSComparisonResult SPIRApplicationVersionCompare(SPIRApplicationVersion version1, SPIRApplicationVersion version2)
{	
	if (version1.major == version2.major)
	{
		if (version1.minor == version2.minor)
		{
			if (version1.fixes == version2.fixes)
			{
				if (version1.build == version2.build)
				{
					// 1.1.1 (116) == 1.1.1 (116)
					return NSOrderedSame;	
				}
				else if (version1.build > version2.build)
				{
					// 1.1.1 (117) > 1.1.1 (116)
					return NSOrderedDescending;
				}
				else
				{
					// 1.1.1 (115) < 1.1.2 (116)
					return NSOrderedAscending;
				}
			}
			else if (version1.fixes > version2.fixes)
			{
				// 1.1.2 > 1.1.1
				return NSOrderedDescending;
			}
			else
			{
				// 1.1.1 < 1.1.2
				return NSOrderedAscending;
			}
		}
		else if (version1.minor > version2.minor)
		{
			// 1.2.1 > 1.1.1
			return NSOrderedDescending;
		}
		else
		{
			// 1.1.1 < 1.2.1
			return NSOrderedAscending;
		}
	}
	else if (version1.major > version2.major)
	{
		// 2.1.1 > 1.1.1
		return NSOrderedDescending;
	}
	else 
	{
		// 1.1.1 < 2.1.1
		return NSOrderedAscending;
	}
}

#if 0
// transforme un numéro de version de la forme 1.0.1 en un nombre 10001
NSNumber *normalizeVersionNumber(NSString *inVersion)
{
	NSMutableArray *versionComponents = [NSMutableArray arrayWithArray:[inVersion componentsSeparatedByString:@"."]];
	NSMutableString *fullVersionString = [NSMutableString string];
	
	for (NSInteger i = 0; i < 3; i++)
	{
		if ([versionComponents count] > i)
		{
			NSString *component = [versionComponents objectAtIndex:i];
			if ([component length] < 2)
			{
				component = [NSString stringWithFormat:@"0%@", component];
			}
			[fullVersionString appendString:component];
		}
		else
		{
			[fullVersionString appendString:@"00"];
		}
	}
	
	return [NSNumber numberWithInt:[fullVersionString integerValue]];
}
#endif
