//
//  SPIREndpoint.m
//  SPIR
//
//  Created by Antoine Marcadet on 28/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "SPIRFunction.h"

@interface SPIRFunction ()

//@property (nonatomic, retain) NSString *endpoint;
//@property (nonatomic, retain) NSString *username;
//@property (nonatomic, retain) NSString *password;

@end

@implementation SPIRFunction

static NSMutableDictionary *_functions = nil;

@synthesize endpoint;
@synthesize username;
@synthesize password;


- (id)initWithEndpoint:(NSString *)_endpoint username:(NSString *)_username andPassword:(NSString *)_password
{
	if ((self = [super init]))
	{
		self.endpoint = _endpoint;
		self.username = _username;
		self.password = _password;
	}
	return self;
}

- (id)initWithEndpoint:(NSString *)_endpoint
{
	return [self initWithEndpoint:_endpoint username:nil andPassword:nil];
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[SPIRFunction alloc] initWithEndpoint:self.endpoint username:self.username andPassword:self.password];
}


#pragma mark - Static methods

+ (void)addFunction:(SPIRFunction *)function withName:(NSString *)functionName
{
	if (_functions == nil)
	{
		_functions = [[NSMutableDictionary alloc] init];
	}
	
	[_functions setObject:function forKey:functionName];
}

+ (NSString *)endpointForFunction:(NSString *)functionName
{
	SPIRFunction *function = (SPIRFunction *)[_functions objectForKey:functionName];
//	if (function == nil) 
//	{
//		[[NSNotificationCenter defaultCenter] postNotificationName:ADXLogoutNotification object:nil];
//		return nil;
//	}
	return [function.endpoint copy];
}

+ (NSString *)usernameForFunction:(NSString *)functionName
{
	SPIRFunction *function = (SPIRFunction *)[_functions objectForKey:functionName];
	return [function.username copy];
}

+ (NSString *)passwordForFunction:(NSString *)functionName
{
	SPIRFunction *function = (SPIRFunction *)[_functions objectForKey:functionName];
	return [function.password copy];
}

+ (SPIRFunction *)functionWithName:(NSString *)functionName
{
	return [(SPIRFunction *)[_functions objectForKey:functionName] copy];
}

@end