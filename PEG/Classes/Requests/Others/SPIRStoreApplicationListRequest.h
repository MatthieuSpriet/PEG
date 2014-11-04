//
//  SPIRFormDataRequest.h
//  SPIR
//
//  Created by Frédéric JOUANNAUD on 15/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "SPIRStoreBaseFormDataRequest.h"
#import "ASIDownloadCache.h"

@interface SPIRStoreApplicationListRequest : SPIRStoreBaseFormDataRequest

+ (SPIRStoreApplicationListRequest *)request;

+ (BOOL)hasCache;
+ (void)clearCache;

- (void)saveRequestToCache;

@end
