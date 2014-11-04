//
//  SPIREndpoint.h
//  SPIR
//
//  Created by Antoine Marcadet on 28/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPIRFunction : NSObject <NSCopying>
{
	NSString *endpoint;
	NSString *username;
	NSString *password;
}

@property (nonatomic, strong) NSString *endpoint;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

+ (NSString *)endpointForFunction:(NSString *)functionName;
+ (NSString *)usernameForFunction:(NSString *)functionName;
+ (NSString *)passwordForFunction:(NSString *)functionName;

+ (SPIRFunction *)functionWithName:(NSString *)functionName;

- (id)initWithEndpoint:(NSString *)endpoint username:(NSString *)username andPassword:(NSString *)password;
- (id)initWithEndpoint:(NSString *)endpoint;

+ (void)addFunction:(SPIRFunction *)function withName:(NSString *)functionName;

@end
