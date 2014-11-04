







//
//  CEXParametres.m
//  CEX
//
//  Created by 10_200_11_120 on 22/03/13.
//  Copyright (c) 2013 SQLI Agency. All rights reserved.
//


#import "PEGParametres.h"

#import "XMLReader.h"

#import <Crashlytics/Crashlytics.h>


@implementation PEGParametres

-(void) dealloc
{
    [NSException raise:@"This method couldn't be call !!!!" format:@"Impossible to call a dealloc of singleton",nil];
}

+ (PEGParametres *)sharedInstance
{
    static dispatch_once_t predicate = 0;
    static PEGParametres* sharedParametresInstance = nil;

    
    dispatch_once(&predicate, ^{
		sharedParametresInstance = [[self alloc]  init] ;
        sharedParametresInstance.dta = [[NSMutableData alloc]init];
        sharedParametresInstance.URL = [NSMutableDictionary dictionary];
        
    });
    
	return sharedParametresInstance;

}


// cette requete est synchrone !
-(void)start_download:(NSString *)p_environement { // appelez cette méthode pour lancer le téléchargement
    
    NSLog(@"p_Environnement : %@",p_environement);
    
    NSString* real_url =[NSString stringWithFormat:@"%@",@"http://local.adrexo.fr/WS_MerchandisingV2/Config/ConfigClient.xml" ];
    
    
    if([p_environement isEqualToString:@"INT"]){
        real_url = @"http://adxnet.int.adrexo.fr/WS_MerchandisingV2/Config/ConfigClient.xml";
        //real_url = @"http://adxnet.rec.adrexo.fr/WS_MerchandisingV2/Config/ConfigClient.xml";
        
    }else if([p_environement isEqualToString:@"REC"]){
        real_url = @"http://adxnet.rec.adrexo.fr/WS_MerchandisingV2/Config/ConfigClient.xml";
    }
    else if([p_environement isEqualToString:@"PROD"]){
        real_url = @"http://local.adrexo.fr/WS_MerchandisingV2/Config/ConfigClient.xml";
    }
    
    
	// on construit ici l'url à appeler.
	
	NSURL* url = [NSURL URLWithString:real_url];
	NSURLRequest* req = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
	
    NSURLResponse* reponse;
	NSError* error;
    
    NSData* donnee=[NSURLConnection sendSynchronousRequest:req returningResponse:&reponse error:&error];
    [self.dta appendData:donnee];
	
    NSMutableString* result = [[NSMutableString alloc] initWithData:self.dta encoding:NSUTF8StringEncoding];
	NSError *xmlError = nil;	// ARC pm140218 new version of XMLReader requires an error param !
    NSDictionary* formsDictionary = [XMLReader dictionaryForXMLString:result error:&xmlError];
    
    NSArray* v_listItem=[[formsDictionary objectForKey:@"Configuration"] objectForKey:@"Item"];
    
    for (NSDictionary* v_item in v_listItem) {
        NSString* v_cle= [[v_item objectForKey:@"Key"]stringForKey:@"text"];
        NSString* v_value= [[v_item objectForKey:@"Value"]stringForKey:@"text"];
        
        
        if([v_cle isEqualToString:@"storeURL"])
        {
            [_URL setValue:v_value forKey:v_cle];
        }
		
        if([v_cle isEqualToString:@"WebServicesIndianaMerchandisingV2"])
        {
            [_URL setValue:v_value forKey:v_cle];
        }
        
        if([v_cle isEqualToString:@"WebServicesCommun_Security"])
        {
            [_URL setValue:v_value forKey:v_cle];
        }
        
        if([v_cle isEqualToString:@"WebServicesCommun_LogSpir"])
        {
            [_URL setValue:v_value forKey:v_cle];
        }
        if([v_cle isEqualToString:@"WebServicesModuleCom"])
        {
            [_URL setValue:v_value forKey:v_cle];
        }
        
        
        
        // traiter cette variable : votre fichier texte est dedans
        // on vide notre objet de son contenu (copié dans result, inutile de le garder deux fois en mémoire)
    }
    
    [Crashlytics setObjectValue:_URL forKey:@"URLs"];
    
	[self.dta setLength:0];
}



@end
