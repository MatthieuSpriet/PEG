//
//  PEGBaseRequest.m
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 28/06/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "PEGBaseRequest.h"
#import "XMLReader.h"
#import "NSDictionary+ConvenientAccess.h"
#import "SPIRMessage.h"
#import "Reachability.h"
#import "JSONKit.h"

#import "SPIRFunction.h"
#import "SPIRException.h"
#import "PEGRequestFormatter.h"
#import "PEGException.h"


#define REQUEST_TIMEOUT		300 //60



NSString* const ADXNetworkRequestErrorDomain = @"ADXRequestErrorDomain";

static NSError *ADXNotReachableError;
static NSError *ADXInvalidXMLError;
static NSError *ADXSoapFaultError;
static NSError *ADXEmptyResponseError;


// ajout pour que LLVM ne gueule pas...
@interface ASIHTTPRequest ()

- (void)reportFinished;
- (void)reportFailure;
- (void)setResponseStatusCode:(NSInteger)status;
- (void)setDidUseCachedResponse:(BOOL)yesOrNo;

@end


@interface PEGBaseRequest ()
{
}

+ (NSString *)requestName;
+ (NSString *)requestCacheName;
+ (NSString *)requestCachePath;

+ (NSString *)responseHeadersCachePath;
+ (NSString *)responseStringCachePath;

+ (void)saveResponseData:(NSData *)data;
+ (void)saveResponseHeaders:(NSDictionary *)headers;
+ (NSData *)savedResponseData;
+ (NSDictionary *)savedResponseHeaders;

@end

@implementation PEGBaseRequest

@synthesize sapMessages = _sapMessages;
@synthesize requestFormatter = _requestFormatter;

@dynamic mainMessage;
@dynamic hasMessages;
@dynamic errorTitle;
@dynamic errorMessage;



+ (void)initialize
{
	if (self == [PEGBaseRequest class])
	{
		ADXNotReachableError = [[NSError alloc] initWithDomain:ADXNetworkRequestErrorDomain code:ADXNotReachableErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Network unreachable", NSLocalizedDescriptionKey, nil]];
		ADXInvalidXMLError = [[NSError alloc] initWithDomain:ADXNetworkRequestErrorDomain code:ADXInvalidXMLErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Invalid XML", NSLocalizedDescriptionKey, nil]];
		ADXSoapFaultError = [[NSError alloc] initWithDomain:ADXNetworkRequestErrorDomain code:ADXSoapFaultErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"SOAP Fault", NSLocalizedDescriptionKey, nil]];
		ADXEmptyResponseError = [[NSError alloc] initWithDomain:ADXNetworkRequestErrorDomain code:ADXEmptyResponseErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Empty response", NSLocalizedDescriptionKey, nil]];
	}
}


-(void)setSpecificTimeOutSeconds:(double)p_TimeOut
{
    [self setTimeOutSeconds:p_TimeOut];
}

- (id)initWithURL:(NSURL *)newURL
{
    if ((self = [super initWithURL:newURL]))
    {
//		if (![[self class] isEqual:[PEGAuthentificationRequest class]] && ([SPIRSession username] == nil || [SPIRSession password] == nil))
		if (([SPIRSession username] == nil || [SPIRSession password] == nil))
		{
			[[NSNotificationCenter defaultCenter] postNotificationName:PEGLogoutNotification object:nil];
		}
		
		[self addBasicAuthenticationHeaderWithUsername:[SPIRSession username] andPassword:[SPIRSession password]];
		[self setUsername:[SPIRSession username]];
		[self setPassword:[SPIRSession password]];
		
		[self addRequestHeader:@"SOAPAction" value:@"\"\""];
		[self addRequestHeader:@"Content-Type" value:@"text/xml;charset=UTF-8"];
		
		[self setValidatesSecureCertificate:NO];
		[self setUseSessionPersistence:NO];
		[self setShouldRedirect:NO];
		
		[self setDefaultResponseEncoding:NSUTF8StringEncoding];
		[self setTimeOutSeconds:REQUEST_TIMEOUT];
		
		_sapMessages = [[NSMutableArray alloc] init];
		_requestFormatter = [[PEGRequestFormatter alloc] init];
	}
	return self;
}

+ (id)defaultRequest
{
	NSString *pegEndpoint = [SPIRFunction endpointForFunction:PEG_ENDPOINT_FUNCTION];
	
	return [[self class] requestWithURL:[NSURL URLWithString:pegEndpoint]];
}


-(BOOL)showAuthenticationDialog
{
	// TODO: compléter avec l'affichage du SPIRAuthViewController
	[[NSNotificationCenter defaultCenter] postNotificationName:PEGLogoutForcedNotification object:nil];
	return NO;
}

- (id)processResponse
{
	// à surcharger dans les classes filles
	return nil;
}

- (void)configureRequestInJsonCompressedFormat
{
    [self addBasicAuthenticationHeaderWithUsername:[SPIRSession username] andPassword:[SPIRSession password]];
    
	[self addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
    
    [self setAllowCompressedResponse:YES];
    [self addRequestHeader:@"Accept-Encoding" value:@"gzip,deflate"];
    
}

- (id)processResponseWithKeyPath:(NSString *)soapResponseTagName
{
	//DLog(@"%@ response: %@", soapResponseTagName, self.responseString);
	
	NSData *data = [self responseData];
    //	DLog(@"Réponse du serveur : %@", [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
	
	NSString *soapResponseName = [[soapResponseTagName componentsSeparatedByString:@"."] lastObject];
	
	NSError *xmlError = nil;
	NSDictionary *allResponseDict = [XMLReader dictionaryForXMLData:data options:XMLReaderOptionsProcessNamespaces error:&xmlError];
	if (xmlError != nil || allResponseDict == nil)
	{
		// parsing du XML, on vérifie si le parsing se passe bien
		DLog(@"Erreur de parsing XML");
#ifdef DEBUG
		[SPIRException raise:@"InvalidXMLException" format:@"%@ : Les données renvoyées par le serveur ne sont pas dans un format correct.", soapResponseName];
#else
		[SPIRException raise:@"InvalidXMLException" format:@"Les données renvoyées par le serveur ne sont pas dans un format correct."];
#endif
	}
	
	// on vérifie s'il n'y a pas eu d'erreur côté SAP
	if ([allResponseDict containsSomethingForKeyPath:@"Envelope.Body.Fault"])
	{
		DLog(@"Erreur côté serveur : soap fault");
#ifdef DEBUG
		[SPIRException raise:@"SOAPFaultException" format:@"%@ : Le serveur a échoué dans le traitement de la demande.", soapResponseName];
#else
		[SPIRException raise:@"SOAPFaultException" format:@"Le serveur a échoué dans le traitement de la demande."];
#endif
	}
	
	// on vérifie qu'on a bien des données dans le keyPath attendu
	NSDictionary *response = [allResponseDict valueForKeyPath:soapResponseTagName];
	//DLog(@"Résultat du parsing : %@", response);
	if (response == nil || [[response allKeys] count] == 0)
	{
		DLog(@"Erreur : réponse du serveur vide");
#ifdef DEBUG
		[SPIRException raise:@"EmptyResponseException" format:@"%@ : La réponse du serveur est vide.", soapResponseName];
#else
		[SPIRException raise:@"EmptyResponseException" format:@"La réponse du serveur est vide."];
#endif
	}
	
	// gestion des messages SAP
	NSArray *Messages = [response arrayForKeyPath:@"TErreurs.item"];
	if (Messages != nil && [Messages count] > 0)
	{
		// boucle de création des messages SAP
		for (NSDictionary *soapMessage in Messages)
		{
			if ([[soapMessage stringForKeyPath:@"Type.text"] length] == 0 || [[soapMessage stringForKeyPath:@"Msg.text"] length] == 0)
			{
				continue;
			}
			
			SPIRMessage *message = [[SPIRMessage alloc] init];
			message.type = [soapMessage stringForKeyPath:@"Type.text"];
            //#ifdef DEBUG
            //			message.text = [NSString stringWithFormat:@"%@ : %@", soapResponseName, [soapMessage stringForKeyPath:@"Msg.text"]];
            //#else
            message.text = [soapMessage stringForKeyPath:@"Msg.text"];
            //#endif
			
			[self.sapMessages addObject:message];
		}
	}
	
	return [NSDictionary dictionaryWithDictionary:response];
}

- (id)processResponseWithJsonKeyPath
{
    NSDictionary *result = nil;
    @try{
        NSString* responseString = [super responseString];
        
        //DLog(@"processResponse :%@",responseString);
        
        if(![responseString isEqualToString:@""]){
            NSError *jSonError = nil;
            
            //Tentive du parse Json
            // JKParseOptionFlags options = JKParseOptionComments | JKParseOptionUnicodeNewlines;
            
            result = [NSDictionary dictionaryWithDictionary:[responseString objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
            
            if (jSonError != nil || result == nil)
            {
                // parsing du JSON, on vérifie si le parsing se passe bien
                ALog(@"Erreur de parsing JSON");
                [NSException raise:@"Erreur de parsing JSON" format:@"processResponseWithJsonKeyPath : Erreur de parsing JSON : %@",responseString];
            }
            
            NSString* v_type = [[NSDictionary dictionaryWithDictionary:result] stringForKeyPath:@"Type"];
            NSString* v_msg = [[NSDictionary dictionaryWithDictionary:result] stringForKeyPath:@"Msg"];
            
            if (v_type)
            {
                if ([v_type isEqualToString:@"E"])
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ResponseWithJsonKeyPath" object:v_msg];
                }
            }
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans processResponseWithJsonKeyPath" andExparams:nil];
    }
    
    return [NSDictionary dictionaryWithDictionary:result];
}


- (UIImage*)processResponseImage
{
    
    UIImage* v_retour;
    
    NSArray *strings = [NSJSONSerialization JSONObjectWithData:[self responseData] options:kNilOptions error:NULL];
    
    unsigned c = strings.count;
    uint8_t *bytes = malloc(sizeof(*bytes) * c);
    
    unsigned i;
    for (i = 0; i < c; i++)
    {
        NSString *str = [strings objectAtIndex:i];
        int byte = [str intValue];
        bytes[i] = byte;
    }
    
    NSData *imageData = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
    v_retour = [UIImage imageWithData:imageData];
    
    
    // DLog(@"processResponse :%@",);
    
    //  NSError *jSonError = nil;
    
    //Tentive du parse Json
    // JKParseOptionFlags options = JKParseOptionComments | JKParseOptionUnicodeNewlines;
    //imageData];
    //p_image = [UIImage imageWithData:
    
    //    v_retour = [UIImage imageWithData:responseData];
    
    
    //    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    //    CGContextRef bitmapContext=CGBitmapContextCreate(responseString, 50, 50, 8, 4*50, colorSpace,  kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    //    CFRelease(colorSpace);
    //    CGImageRef cgImage=CGBitmapContextCreateImage(bitmapContext);
    //    CGContextRelease(bitmapContext);
    //
    //    //UIImage *newimage = [UIImage imageWithCGImage:cgImage];
    //    v_retour = [UIImage imageWithCGImage:cgImage];
    
    //    NSDictionary *result = [NSDictionary dictionaryWithDictionary:[responseString objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
    //
    //    if (jSonError != nil || result == nil)
    //	{
    //		// parsing du JSON, on vérifie si le parsing se passe bien
    //		ALog(@"Erreur de parsing JSON");
    //    }
    //
    //    NSString* v_type = [[NSDictionary dictionaryWithDictionary:result] stringForKeyPath:@"Type"];
    //    NSString* v_msg = [[NSDictionary dictionaryWithDictionary:result] stringForKeyPath:@"Msg"];
    //
    //    if (v_type)
    //    {
    //        if ([v_type isEqualToString:@"E"])
    //        {
    //            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResponseWithJsonKeyPath" object:v_msg];
    //        }
    //    }
    //
    //    return [NSDictionary dictionaryWithDictionary:result];
    return v_retour;
}

- (void)startAsynchronous
{
	if (![[Reachability reachabilityForInternetConnection] isReachable])
	{
		[super failWithError:ADXNotReachableError];
	}
	else
	{
		[super startAsynchronous];
	}
}


#pragma mark - Getters & setters

- (SPIRMessage *)mainMessage
{
	if ([self.sapMessages count] > 0)
	{
		for (SPIRMessage *mess in self.sapMessages)
		{
			if ([mess.text length] > 0 && [mess.title length] > 0)
			{
				return mess;
			}
		}
	}
	return nil;
}

- (BOOL)hasMessages
{
	return ([self.sapMessages count] > 0);
}

- (BOOL)hasWarningMessages
{
    for (SPIRMessage *message in self.sapMessages)
    {
        if (message.level == SPIRMessageLevelWarning)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasErrorMessages
{
    for (SPIRMessage *message in self.sapMessages)
    {
        if (message.level == SPIRMessageLevelError)
        {
            return YES;
        }
    }
    return NO;
}

- (NSString *)errorMessage
{
    if ([self.error.domain isEqualToString:NetworkRequestErrorDomain])
    {
        switch ((ASINetworkErrorType)self.error.code)
        {
            case ASIConnectionFailureErrorType:
				return @"Une erreur est survenue lors de la connexion avec le serveur.";
            case ASIRequestTimedOutErrorType:
				return @"La requête avec le serveur a expirée.";
            case ASIAuthenticationErrorType:
				return @"Une authentification est requise par le serveur.";
            case ASIRequestCancelledErrorType:
				return @"La requête a été annulée.";
            case ASITooMuchRedirectionErrorType:
				return @"La requête a été redirigée un trop grand nombre de fois.";
            case ASIUnableToCreateRequestErrorType:
				return @"Impossible de créer de requête vers le serveur, vérifiez l'adresse de l'hôte.";
            case ASIInternalErrorWhileBuildingRequestType:
				return @"Impossible de créer un flux.";
            case ASIInternalErrorWhileApplyingCredentialsType:
            case ASIFileManagementError:
            case ASICompressionError:
            case ASIUnhandledExceptionError:
            default:
                return @"Impossible d'atteindre le serveur.";
        }
    }
    else if ([self.error.domain isEqualToString:ADXNetworkRequestErrorDomain])
    {
		switch ((ADXNetworkErrorType)self.error.code)
		{
			case ADXInvalidXMLErrorType:
				return @"Les données renvoyées par le serveur ne sont pas dans un format correct.";
			case ADXSoapFaultErrorType:
				return @"Le serveur a échoué dans le traitement de la demande.";
			case ADXEmptyResponseErrorType:
				return @"La réponse du serveur est vide.";
			case ADXNotReachableErrorType:
				return @"Vous devez être connecté à Internet pour pouvoir charger les données.";
		}
    }
    
    return @"Une erreur inconnue est survenue.";
}

- (NSString *)errorTitle
{
    if ([self.error.domain isEqualToString:NetworkRequestErrorDomain])
    {
        switch (self.error.code)
        {
            case ASIConnectionFailureErrorType:
            case ASIRequestTimedOutErrorType:
            case ASIAuthenticationErrorType:
            case ASIRequestCancelledErrorType:
            case ASIUnableToCreateRequestErrorType:
            case ASIInternalErrorWhileBuildingRequestType:
            case ASIInternalErrorWhileApplyingCredentialsType:
            case ASIFileManagementError:
            case ASITooMuchRedirectionErrorType:
            case ASICompressionError:
            case ASIUnhandledExceptionError:
            default:
                return @"Erreur réseau";
        }
    }
    else if ([self.error.domain isEqualToString:ADXNetworkRequestErrorDomain])
    {
		switch ((ADXNetworkErrorType)self.error.code)
		{
			case ADXInvalidXMLErrorType:
			case ADXSoapFaultErrorType:
			case ADXEmptyResponseErrorType:
				return @"Erreur";
			case ADXNotReachableErrorType:
				return @"Connexion réseau requise";
		}
    }
    
    return @"Erreur réseau inconnue";
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

#pragma mark - Cache / Configuration

+ (NSString *)requestName
{
	return NSStringFromClass([self class]);
}

+ (NSString *)requestCacheName
{
	return @"fr.spir.auth";
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


#pragma mark - Static methods

+ (NSDictionary *)standardParameters
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	
	[params setObject:PEG_WS_APPLICATION forKey:@"Application"];
	[params setObject:PEG_WS_DEVICE forKey:@"Device"];
	[params setObject:PEG_WS_ENVIRONNEMENT forKey:@"Environnement"];
	[params setObject:PEG_WS_VERSION forKey:@"Version"];
	
	
	
	return params;
}

+ (NSDictionary *)standardFormatters
{
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	
	NSNumberFormatter *integerNumberFormatter = [[NSNumberFormatter alloc] init];
	[integerNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[integerNumberFormatter setMaximumFractionDigits:0];	// suppression de la partie fractionnaire
	[integerNumberFormatter setGroupingSeparator:@""];		// suppression du séparateur de centaine
	[params setObject:integerNumberFormatter forKey:@"integer"];
    
	NSNumberFormatter *priceNumberFormatter = [[NSNumberFormatter alloc] init];
	[priceNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[priceNumberFormatter setMaximumFractionDigits:2];		// 2 chiffres après la virgule
	[priceNumberFormatter setDecimalSeparator:@"."];		// le "." comme séparateur de la partie décimale
	[priceNumberFormatter setGroupingSeparator:@""];		// pas de séparateur de centaine
	[params setObject:priceNumberFormatter forKey:@"price"];
    
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	[params setObject:dateFormatter forKey:@"date"];
    
	
	return params;
}


@end


