//
//  PEGAuthentificationWSRequest.m
//  CEX
//
//  Created by 10_200_11_120 on 27/03/13.
//  Copyright (c) 2013 SQLI Agency. All rights reserved.
//

#import "PEGAuthentificationWSRequest.h"
#import "PEGParametres.h"
#import "NSDictionary+ConvenientAccess.h"
#import "PEGSession.h"


@interface PEGAuthentificationWSRequest()
+ (PEGAuthentificationWSRequest *)requestWithURL:(NSURL *)URL;		// pm140220 added
@end


@implementation PEGAuthentificationWSRequest

+ (PEGAuthentificationWSRequest *)requestWithURL:(NSURL *)URL
{
    return [[self alloc] initWithURL:URL];
}


+ (PEGAuthentificationWSRequest*)requestLogin:(NSString*)p_Login andPassword:(NSString*)p_Password{
    
    PEGAuthentificationWSRequest *request = nil;
    
    @try{
        //     NSString* renderUrl = @"http://adxnet.int.adrexo.fr/WS_Commun/ServiceWCFSecuFromSI.svc/REST/GetInfoSecuritySGBDandConnect_Rest?paramUser=SPIR_UserExterneIOS&paramPwd=SPIR";
        
        PEGParametres* sharedCEXParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedCEXParametres.URL stringForKey:@"WebServicesCommun_Security"];
        NSLog(@"UrlWebservice : %@",UrlWebservice);
        
        NSString* UrlService= [NSString stringWithFormat:@"/REST/GetInfoSecuritySGBDandConnect_Rest?paramUser=%@&paramPwd=%@",p_Login,p_Password];
        
        NSString* renderUrl=[NSString stringWithFormat:@"%@%@", UrlWebservice, UrlService];
        NSLog(@"renderUrl : %@",renderUrl);
		
        request = [PEGAuthentificationWSRequest requestWithURL:[NSURL URLWithString:renderUrl]];
        
        [request configureRequestInJsonCompressedFormat];
		
    }@catch(NSException* p_exception){
        
		//	[[CEXException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestLogin: Erreur de requête d'authentification" andExparams:[NSString stringWithFormat:@"Login:%@ Password:%@",p_Login,p_Password]];
    }
    return request;
}


// appellé explicitement (par PEGAuthenticationViewController) dans le completion block

- (BOOL) processResponse
{
    BOOL v_retour =NO;
    @try{
        NSDictionary* responseDictionary = [super processResponseWithJsonKeyPath];
        
        if ([responseDictionary count]!=0)
        {
            NSLog(@"DATA : %@",responseDictionary);
            v_retour = [responseDictionary boolForKeyPath:@"IsAuthentif"];
            [PEGSession sharedPEGSession].IsAdmin=[responseDictionary boolForKeyPath:@"IsAdminIndiana"];
        }
    }@catch(NSException* p_exception){
        
//        [[CEXException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"processResponse: Erreur de réponse d'authentification" andExparams:nil];
    }
    return v_retour;
}
@end
