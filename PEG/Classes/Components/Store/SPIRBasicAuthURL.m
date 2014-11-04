//
//  SPIRBasicAuthURL.m
//  SPIR
//
//  Created by Rémi Bouchez on 12/06/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "SPIRBasicAuthURL.h"

NSString* urlWithAuth(NSString* baseUrl)
{
    NSUInteger stringLocation = 0;
    if ([baseUrl rangeOfString:@"https%3A%2F%2F"].location != NSNotFound)
    {
        stringLocation = [baseUrl rangeOfString:@"https%3A%2F%2F"].location + [baseUrl rangeOfString:@"https%3A%2F%2F"].length;
    }
	else if ([baseUrl rangeOfString:@"https://"].location != NSNotFound)
	{
        stringLocation = [baseUrl rangeOfString:@"https://"].location + [baseUrl rangeOfString:@"https://"].length;
	}
	else if ([baseUrl rangeOfString:@"http://"].location != NSNotFound)
	{
        stringLocation = [baseUrl rangeOfString:@"http://"].location + [baseUrl rangeOfString:@"http://"].length;
    }
    else 
	{
        stringLocation = [baseUrl rangeOfString:@"http%3A%2F%2F"].location + [baseUrl rangeOfString:@"http%3A%2F%2F"].length;
    }
    
    NSString *itms_url = [baseUrl substringToIndex:stringLocation];
    DLog(@"%@", itms_url);
    NSString *auth_url = [NSString stringWithFormat:@"%@:store@%@", [SPIRSession username], [baseUrl substringFromIndex:stringLocation]];
    DLog(@"URL URL URL URL : : : :   %@", auth_url);
    NSString *urlWithAuth = [NSString stringWithFormat:@"%@%@", itms_url, auth_url];
    DLog(@"%@", urlWithAuth);
    return urlWithAuth;
}