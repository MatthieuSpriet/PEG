//
//  PEGBaseRequestAFN.m
//  PEG
//
//  Created by Pierre Marty on 19/02/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

// A re-implementation of PEGBaseRequest using AFNetworking
// Some code is borrowed from https://github.com/AFNetworking/AFNetworking-ASIHTTPRequest
//
// Atention à setCompletionBlock (ou le propriété completionBlock), c'est une méthode de superclasse, on ne peut pas faire
// un override ici pour lui donner une autre signification. Il est aussi appellé en interne à AFNetworking !
//
// Le mécanisme de cache est une copie de celui existant à l'origine dans PEGBaseRequest.m
//

#if USE_AFNetworking

#import "PEGBaseRequestAFN.h"
//#import "JSONKit.h"
#import "PEGException.h"
// #import "AFHTTPRequestOperationManager.h"


@interface PEGBaseRequest()
@property (copy) void (^successBlock)(void);
@property (copy) void (^failedBlock)(void);
@end


@implementation PEGBaseRequest


+ (PEGBaseRequest *)requestWithURL:(NSURL *)URL
{
    return [[self alloc] initWithURL:URL];
}


- (id)initWithURL:(NSURL *)URL
{
    self = [self initWithRequest:[NSURLRequest requestWithURL:URL]];
    if (self) {
		NSLog (@"AFN initWithURL: %@", URL);

		__weak __typeof(self)weakSelf = self;
		[self
		 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			 if (weakSelf.successBlock) {
				 NSLog (@"AFN calling successBlock");
				 __strong __typeof(weakSelf)strongSelf = weakSelf;
				 strongSelf.successBlock();
			 }
		 }
		 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			 if (weakSelf.failedBlock) {
				 NSLog (@"AFN calling failedBlock");
				 __strong __typeof(weakSelf)strongSelf = weakSelf;
				 strongSelf.failedBlock();
			 }
		 }];
	}
	
    return self;
}



-(void)setSpecificTimeOutSeconds:(double)timeOut
{
	NSLog (@"AFN setSpecificTimeOutSeconds: %f", timeOut);
	// bouchon , TODO: implementation
//    [self setTimeOutSeconds:p_TimeOut];
}


#pragma mark - request configuration

#if 0
- (AFHTTPRequestOperationManager*)requestManager
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	[manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
	[manager.requestSerializer setAuthorizationHeaderFieldWithUsername:LOGIN password:PASSWORD];	// basic authorization
	
	// force it to accept text/html content
	AFJSONResponseSerializer * responsSerializer = [AFJSONResponseSerializer serializer];
	responsSerializer.acceptableContentTypes = [[NSSet alloc] initWithArray:@[@"text/html"]];
	[manager setResponseSerializer:responsSerializer];
	
	return manager;
}

#endif


- (void)addBasicAuthenticationHeaderWithUsername:(NSString *)theUsername andPassword:(NSString *)thePassword
{
	NSLog (@"AFN addBasicAuthenticationHeaderWithUsername: %@ andPassword:%@", theUsername, thePassword);
// bouchon , TODO: implementation


//	[self addRequestHeader:@"Authorization" value:[NSString stringWithFormat:@"Basic %@",[ASIHTTPRequest base64forData:[[NSString stringWithFormat:@"%@:%@",theUsername,thePassword] dataUsingEncoding:NSUTF8StringEncoding]]]];
//	[self setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
	
}

- (void)configureRequestInJsonCompressedFormat
{
	NSLog (@"AFN configureRequestInJsonCompressedFormat");
    [self addBasicAuthenticationHeaderWithUsername:[SPIRSession username] andPassword:[SPIRSession password]];
    
//	[self addRequestHeader:@"Content-Type" value:@"application/json;charset=UTF-8"];
//    [self setAllowCompressedResponse:YES];
//    [self addRequestHeader:@"Accept-Encoding" value:@"gzip,deflate"];
    
}


#pragma mark - processing response

- (NSString *)responseString
{
	NSData *data = [self responseData];
	if (!data) {
		return nil;
	}
	
	return [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
}


- (id)processResponse
{
	// à surcharger dans les classes filles
	return nil;
}


- (NSDictionary*)processResponseWithJsonKeyPath
{
	NSLog (@"AFN processResponseWithJsonKeyPath");

    NSDictionary *result = nil;
    @try{
        NSString* responseString = [self responseString];
        
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

// d'après mesure sur simulateur, l'opération de loin la plus longue est le parsing JSON (JSONObjectWithData)
// utilisant NSJSONSerialization d'Apple !

- (UIImage*)processResponseImage
{
	NSLog (@"AFN processResponseImage");
    UIImage* v_retour = nil;
    
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSArray *strings = [NSJSONSerialization JSONObjectWithData:[self responseData] options:kNilOptions error:NULL];
	DLog (@"creating JSON string:%.2f msecs", (CFAbsoluteTimeGetCurrent() - startTime)  * 1000);
    // creating JSON string:54.50 msecs

    unsigned c = strings.count;
    uint8_t *bytes = malloc(sizeof(*bytes) * c);
    
    unsigned i;
    for (i = 0; i < c; i++)
    {
        NSString *str = [strings objectAtIndex:i];
        int byte = [str intValue];
        bytes[i] = byte;
    }
 	DLog (@"bytes array done:%.2f msecs", (CFAbsoluteTimeGetCurrent() - startTime)  * 1000);
	// bytes array done:67.25 msecs
   
    NSData *imageData = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
    v_retour = [UIImage imageWithData:imageData];
	
	DLog (@"image created:%.2f msecs", (CFAbsoluteTimeGetCurrent() - startTime)  * 1000);
	// image created:67.96 msecs

    return v_retour;
}


#pragma mark - start request

- (void)startAsynchronous
{
	NSLog (@"AFN startAsynchronous");
	[self start];
}


// appelé par SaveBeanImageWithObserver
- (void)startSynchronous
{
	NSLog (@"AFN startSynchronous");
    NSLog(@"[Warning]: %@ %@ makes a synchronous network request. It is strongly recommended that all networking is done asynchronously, by setting a callback and either calling -start or adding the operation to an NSOperationQueue.", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [self start];
    [self waitUntilFinished];
}


// **** Cache **** Cache **** Cache **** Cache

#pragma mark - Cache / Sauvegarde

- (void)saveRequestToCache
{
	[[self class] saveResponseData:self.responseData];						// rawResponseData - attention, peut être un pb si compressée
	[[self class] saveResponseHeaders:self.response.allHeaderFields];		// responseHeaders
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

// pm140220 restoreRequestFromCache pas utilisé.
// SPIRStoreApplicationListRequest.m en a une autre implémentation indépendante !

//- (void)restoreRequestFromCache
//{
//	[super setResponseStatusCode:[[self.responseHeaders objectForKey:@"X-ASIHTTPRequest-Response-Status-Code"] intValue]];
//	[super setDidUseCachedResponse:YES];
//	[super setResponseHeaders:[[self class] savedResponseHeaders]];
//	
//	[super setContentLength:[[[self responseHeaders] objectForKey:@"Content-Length"] longLongValue]];
//	[super setTotalBytesRead:[self contentLength]];
//	[super setRawResponseData:[NSMutableData dataWithData:[[self class] savedResponseData]]];
//	
//	[super parseStringEncodingFromHeaders];
//	
//	//[super setResponseCookies:[NSHTTPCookie cookiesWithResponseHeaderFields:self.responseHeaders forURL:[self url]]];
//}

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






@end


#endif

