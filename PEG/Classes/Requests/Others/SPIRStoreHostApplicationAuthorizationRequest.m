//
//  SPIRStoreHostApplicationAuthorizationRequest.m
//  SPIR
//
//  Created by Frédéric JOUANNAUD on 23/04/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "SPIRStoreHostApplicationAuthorizationRequest.h"

#import "SPIRApplication.h"
#import "SPIRMobileInstallationProxy.h"
#import "SPIRFunction.h"
#import "PEGParametres.h"

@implementation SPIRStoreHostApplicationAuthorizationRequest

+ (SPIRStoreHostApplicationAuthorizationRequest *)request
{
	//NSString *storeURL = [SPIRFunction endpointForFunction:PEG_ENDPOINT_STORE_FUNCTION];
    PEGParametres* sharedCEXParametres = [PEGParametres sharedInstance];
    NSString* storeURL =[sharedCEXParametres.URL stringForKey:@"storeURL"];
#ifdef DEBUG
	storeURL = [storeURL stringByAppendingString:@"rest_dev.php/check_application"];
#else
	storeURL = [storeURL stringByAppendingString:@"rest.php/check_application"];
#endif
	
	DLog(@"storeURL : %@", storeURL);
	SPIRStoreHostApplicationAuthorizationRequest *request = [SPIRStoreHostApplicationAuthorizationRequest requestWithURL:[NSURL URLWithString:storeURL]];
	
//	[request setDownloadCache:[[self class] carrouselCache]];
	[request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
	[request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	
	return request;
}

- (SPIRApplication *)processResponse
{
	[self saveRequestToCache];
	DLog(@"[self responseString] : %@", [self responseString]);
	
	NSDictionary *jsonData = [super processResponseWithString:[self responseString]];
	
	if ([jsonData objectForKey:@"error"]) 
	{
		return nil;
	}

	SPIRApplication *application = [[SPIRApplication alloc] initWithDictionary:jsonData];
	DLog(@"application %@", application);
	
	if (application != nil)
	{
		SPIRApplicationVersion mipVersion = SPIRApplicationVersionFromString([[[NSBundle mainBundle] infoDictionary] objectForKey:@"SPIRBundleFullVersionString"]);
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
		
		return application;
	}
	return nil;
}

@end
