//
//  PEGAuthentificationWSRequest.h
//  CEX
//
//  Created by 10_200_11_120 on 27/03/13.
//  Copyright (c) 2013 SQLI Agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEGBaseRequest.h"

@interface PEGAuthentificationWSRequest : PEGBaseRequest

+ (PEGAuthentificationWSRequest*)requestLogin:(NSString*)p_Login andPassword:(NSString*)p_Password;

- (BOOL) processResponse;

@end
