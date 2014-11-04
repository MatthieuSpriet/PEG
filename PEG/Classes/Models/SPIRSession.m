//
//  ADXSession.m
//  ADX
//
//  Created by Antoine Marcadet on 07/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPIRSession.h"
#import "SFHFKeychainUtils.h"

NSString *const PEGLoginSucceedNotification		= @"PEGLoginSucceedNotification";
NSString *const PEGLoginFailedNotification		= @"PEGLoginFailedNotification";
NSString *const PEGLogoutNotification			= @"PEGLogoutNotification";
NSString *const PEGLogoutForcedNotification		= @"PEGLogoutForcedNotification";

@implementation SPIRSession

static BOOL _isLogged = NO;

+ (BOOL)isLogged
{
	return _isLogged;
}

+ (BOOL)hasSessionInKeychain
{
	return ([[[self class] username] length] > 0 && [[[self class] password] length] > 0);
}

+ (NSString *)username
{
	NSString *_username = [SFHFKeychainUtils getPasswordForUsername:PEG_KEYCHAIN_USERNAME_ACCESS andServiceName:PEG_KEYCHAIN_SERVICE_NAME error:NULL];
	if (_username != nil)
	{
		return [_username copy];
	}
	else
	{
		DLog(@"Empty username");
	}
	return nil;
}

+ (NSString *)password
{
	NSString *_password = [SFHFKeychainUtils getPasswordForUsername:PEG_KEYCHAIN_PASSWORD_ACCESS andServiceName:PEG_KEYCHAIN_SERVICE_NAME error:NULL];
	if (_password != nil)
	{
		return [_password copy];
	}
	return nil;
}

+ (void)logout
{
	[SPIRSession setLogged:NO];
	[SFHFKeychainUtils deleteItemForUsername:PEG_KEYCHAIN_USERNAME_ACCESS andServiceName:PEG_KEYCHAIN_SERVICE_NAME error:nil];
	[SFHFKeychainUtils deleteItemForUsername:PEG_KEYCHAIN_PASSWORD_ACCESS andServiceName:PEG_KEYCHAIN_SERVICE_NAME error:nil];
}

+ (BOOL)saveUsername:(NSString *)_username andPassword:(NSString *)_password
{
	NSError *error = nil;
	
	[SFHFKeychainUtils storeUsername:PEG_KEYCHAIN_USERNAME_ACCESS andPassword:_username forServiceName:PEG_KEYCHAIN_SERVICE_NAME updateExisting:YES error:&error];
	[SFHFKeychainUtils storeUsername:PEG_KEYCHAIN_PASSWORD_ACCESS andPassword:_password forServiceName:PEG_KEYCHAIN_SERVICE_NAME updateExisting:YES error:&error];
	
	[SPIRSession setLogged:(error == nil)];
	
	if (error != nil)
	{
		[SFHFKeychainUtils deleteItemForUsername:PEG_KEYCHAIN_USERNAME_ACCESS andServiceName:PEG_KEYCHAIN_SERVICE_NAME error:nil];
		[SFHFKeychainUtils deleteItemForUsername:PEG_KEYCHAIN_PASSWORD_ACCESS andServiceName:PEG_KEYCHAIN_SERVICE_NAME error:nil];
	}
	
	return (error == nil);
}

+ (void)setLogged:(BOOL)yesOrNo
{
	_isLogged = yesOrNo;
}

@end
