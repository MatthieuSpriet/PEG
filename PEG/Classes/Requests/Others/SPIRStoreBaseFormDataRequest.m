//
//  SPIRStoreBaseFormDataRequest.m		pm140219 au lieu de SPIRBaseFormDataRequest !!!
//  SPIR
//
//  Created by Frédéric JOUANNAUD on 01/03/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "SPIRStoreBaseFormDataRequest.h"
#import "UIDevice-Hardware.h"
#import "SPIRSession.h"
#import "JSONKit.h"
#import "SPIRTechnicalException.h"

@implementation SPIRStoreBaseFormDataRequest


/**** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** 
	Attention j'ai cru que ce fichier n'était pas utilisé en cherchant SPIRBaseFormDataRequest !
	Il est bien utilisé comme super classe de SPIRStoreHostApplicationAuthorizationRequest
	SPIRStoreBaseFormDataRequest > SPIRStoreApplicationListRequest > SPIRStoreHostApplicationAuthorizationRequest
*/


// pm201402 uniqueIdentifier n'est plus accessible avec iOS7.
// on peut éventuellement remplacer par identifierForVendor, mais cette valeur désigne une instance d'un logiciel sur un device
// Plusieurs applis sur le mm device auront des identificateur différents !

- (NSString*)deviceIdentifier
{
	NSUUID * identifier = [UIDevice currentDevice].identifierForVendor;
	NSString * idString = [identifier UUIDString];
	return idString;
}



- (id)initWithURL:(NSURL *)newURL
{
    if ((self = [super initWithURL:newURL]))
    {
		DLog(@"username: %@, password: %@", [SPIRSession username], [SPIRSession password]);
//		[self addBasicAuthenticationHeaderWithUsername:[SPIRSession username] andPassword:[SPIRSession password]];
		[self addBasicAuthenticationHeaderWithUsername:[SPIRSession username] andPassword:@"store"];
		[self setValidatesSecureCertificate:NO];
		
		// ajout des entêtes spécifiques au store
		UIDevice *device = [UIDevice currentDevice];
		// [self addRequestHeader:@"X-Device-Id" value:[device uniqueIdentifier]];
		[self addRequestHeader:@"X-Device-Id" value:self.deviceIdentifier];	// ARC pm140218 voir notes en début de fichier !
		
		[self addRequestHeader:@"X-Device-Os-Name" value:[device systemName]];
		[self addRequestHeader:@"X-Device-Os-Version" value:[device systemVersion]];
		[self addRequestHeader:@"X-Device-Model" value:[device platform]];
		[self addRequestHeader:@"X-Device-Name" value:[device name]];
		[self addRequestHeader:@"X-Application-Identifier" value:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]];
		[self addRequestHeader:@"X-Application-Version" value:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
		[self addRequestHeader:@"X-Application-Build" value:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
		
		DLog(@"headers : %@", self.requestHeaders);
	}
	return self;
}

- (id)processResponseWithString:(NSString *)_response
{		
	NSDictionary *httpHeaders = [self responseHeaders];
	NSString *jsonStatus = [httpHeaders objectForKey:@"X-Store-Rest-Status"];
	
	if ([jsonStatus isEqualToString:@"AUTH_BAD"])
	{
		[SPIRTechnicalException raise:@"BadAuthenticationException" format:@"Echec de l'authentification, les identifiants saisis sont incorrects."];
	}
	else if ([jsonStatus isEqualToString:@"REQUEST_BAD"])
	{
		[SPIRTechnicalException raise:@"BadRequestException" format:@"Erreur de communication avec le Store."];
	}
	else if (![jsonStatus isEqualToString:@"OK"])
	{
		[SPIRTechnicalException raise:@"UnknownException" format:@"Le Store a rencontré une erreur inconnue."];
	}
	
	NSError *jsonError = nil;
	NSDictionary *result = [NSDictionary dictionaryWithDictionary:[_response objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jsonError]];
	
	if (jsonError != nil)
	{
		[SPIRTechnicalException raise:@"InvalidJSONException" format:@"Les données renvoyées par le Store ne sont pas dans un format correct."];
	}
	
	if (result == nil)
	{
		[SPIRTechnicalException raise:@"EmptyResponseException" format:@"La réponse du Store est vide."];
	}
	
	return result;
}

- (id)processResponse
{
	return nil;
}

@end
