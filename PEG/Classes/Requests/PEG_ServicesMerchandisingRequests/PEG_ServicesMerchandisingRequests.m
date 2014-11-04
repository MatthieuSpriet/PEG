//
//  PEG_ServicesMerchandisingRequests.m
//  PEG
//
//  Created by 10_200_11_120 on 24/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ServicesMerchandisingRequests.h"
#import "PEGParametres.h"
#import "PEGException.h"
#import "SPIRTechnicalException.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEGAppDelegate.h"
#import "PEG_FMobilitePegase.h"

@implementation PEG_ServicesMerchandisingRequests

- (void)MessageErrorUser:(NSString *)p_titre
{
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:p_titre
                          message:@"Une erreur s'est produite, merci d'appeler l'assistance pour débloquer l'application"
                          delegate:self
                          cancelButtonTitle:@"Quitter"
                          otherButtonTitles:@"Tél 65 45",nil];
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Quitter"])
    {
        NSLog(@"Button Quitter.");
        exit(0);
    }
    else if([title isEqualToString:@"Tél 65 45"])
    {
        NSLog(@"Button Tél 65 45");
        [[PEG_FMobilitePegase CreateMobilitePegaseService] AppelAssistance];
    }
}

+ (PEG_ServicesMerchandisingRequests *)requestGetLastSuiviKilometreByMatricule:(NSString*)p_Matricule
{
    PEG_ServicesMerchandisingRequests *request;
    @try{
        
        //exemple exception
        //        NSException* v_exception = [NSException exceptionWithName:@"TEST" reason:@"REASON" userInfo:nil];
        //        [v_exception raise];
                
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
        
        //http://adxnet.int.adrexo.fr/WS_MerchandisingV2/ServicesMerchandising.svc/REST/GetLastSuiviKilometreByMatricule?p_Matricule=00000619
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/GetLastSuiviKilometreByMatricule?p_Matricule=%@",UrlWebservice,p_Matricule];
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        DLog(@"=>request: %@ ",renderUrl);
        
        request = [PEG_ServicesMerchandisingRequests requestWithURL:url];
        [request setSpecificTimeOutSeconds:240];
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestGetLastSuiviKilometreByMatricule: Erreur de requête GetLastSuiviKilometreByMatricule" andExparams:[NSString stringWithFormat:@"p_Matricule=%@",p_Matricule]];
    }
	return request;
    
}

- (BOOL)processResponseGetLastSuiviKilometre
{
    
    @try{
                
        NSDictionary* responseDictionary = [super processResponseWithJsonKeyPath];
        //      NSError *jSonError = nil;
        //    NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:[v_bouchon objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
        
        
        if ([responseDictionary count]!=0)
        {
                //p_ObjectToFill = [p_ObjectToFill initBeanWithJson:responseDictionary];
            
            //////CoreData
            NSString* responseString = [super responseString];
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            //NSArray* v_managedObjects =
            [[PEG_FMobilitePegase CreateCoreData] managedObjectsFromJSONStructure:responseString withObjectName:@"BeanSuiviKMUtilisateur" withManagedObjectContext:app.managedObjectContext];
            
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            NSString* v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
            DLog("%@",v_st);
            //////

        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyResponseException" format:@"La réponse du serveur est vide."];
        }
        
    }@catch(NSException* p_exception){
        //[self MessageErrorUser:@"Kilometrage"];
        //[[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"processResponse: Erreur de requête GetInfoGeneraleVente" andExparams:@""];
        return false;
    }
    return true;
}

+ (PEG_ServicesMerchandisingRequests *)requestSetBeanSuiviKilometreByMatriculeDate:(NSString*)p_Matricule andDate:(NSDate*)p_Date andKm:(NSNumber*)p_Km
{
    PEG_ServicesMerchandisingRequests *request;
    @try{
        
        //exemple exception
        //        NSException* v_exception = [NSException exceptionWithName:@"TEST" reason:@"REASON" userInfo:nil];
        //        [v_exception raise];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString* date = [format stringFromDate:p_Date];
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
        
        //http://adxnet.int.adrexo.fr/WS_MerchandisingV2/ServicesMerchandising.svc/REST/SetSuiviKilometreByMatriculeDate?p_Matricule=00000619&p_Date=2013-04-29T00:00-00:00&p_Km=10
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/SetSuiviKilometreByMatriculeDate?p_Matricule=%@&p_Date=%@&p_Km=%@",UrlWebservice,p_Matricule,date,p_Km];
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        DLog(@"=>request: %@ ",renderUrl);
        
        request = [PEG_ServicesMerchandisingRequests requestWithURL:url];
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestSetSuiviKilometreByMatriculeDate: Erreur de requête SetSuiviKilometreByMatriculeDate" andExparams:[NSString stringWithFormat:@"p_Matricule=%@",p_Matricule]];
    }
	return request;
    
}

/*- (void)processResponseSetBeanSuiviKilometre:(PEG_BeanSuiviKMUtilisateur*) p_ObjectToFill
{
    
    @try{
        if (p_ObjectToFill == nil)
            return;
        
        //Si on passe ici c'est que le set a bien fonctionné
        p_ObjectToFill.FlagMAJ = PEG_EnumFlagMAJ_Unchanged;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"processResponse: Erreur de requête GetInfoGeneraleVente" andExparams:p_ObjectToFill.description];
    }
}*/


+ (PEG_ServicesMerchandisingRequests *)requestGetImageByIdPointLivraison:(int)p_IdPointLivraison
{
    PEG_ServicesMerchandisingRequests *request;
	// pm140219 quelle exception peut on avoir ici ?
    @try{
		
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
        
        //http://adxnet.int.adrexo.fr/WS_MerchandisingV2/ServicesMerchandising.svc/REST/GetImageByteByIdPointLivraison?p_IdPointLivraison=64016
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/GetImageByteByIdPointLivraison?p_IdPointLivraison=%d",UrlWebservice,p_IdPointLivraison ];
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        DLog(@"=>request: %@ ",renderUrl);
        
        request = [PEG_ServicesMerchandisingRequests requestWithURL:url];
        [request configureRequestInJsonCompressedFormat];
        
    }
	@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestGetImageByIdPointLivraison: Erreur de requête requestGetImageByIdPointLivraison" andExparams:[NSString stringWithFormat:@"p_IdPointLivraison=%d",p_IdPointLivraison]];
    }
	return request;
    
}

- (UIImage*)processResponseGetImageByIdPointLivraison
{
    UIImage* v_image=nil;
    @try{
        v_image= [super processResponseImage];
        //      NSError *jSonError = nil;
        //    NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:[v_bouchon objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
        
        
//        if ([responseDictionary count]!=0)
//        {
//            NSData *imageData = [NSKeyedArchiver archivedDataWithRootObject:responseDictionary];
//            p_image = [UIImage imageWithData: imageData];
//        }
//        else
//        {
//            [SPIRTechnicalException raise:@"EmptyResponseException" format:@"La réponse du serveur est vide."];
//        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"processResponse: Erreur de requête GetImageByIdPointLivraison" andExparams:@""];
    }
    return v_image;
}

+ (PEG_ServicesMerchandisingRequests *)requestSaveImage:(PEG_BeanImage*)p_BeanImage
{
    PEG_ServicesMerchandisingRequests *request;
    @try{
        
        
        PEGParametres* sharedCEXParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedCEXParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
        
        NSString* UrlService=@"/REST/SaveImageBytePreImport_POST";
        
        NSString* renderUrl=[NSString stringWithFormat:@"%@%@", UrlWebservice, UrlService];
        
        DLog(@"=>request: %@ ",renderUrl);
        
        request= [PEG_ServicesMerchandisingRequests requestWithURL:[NSURL URLWithString:renderUrl]];
        [request configureRequestInJsonCompressedFormat];
        
        
         NSData* v_DataSend = [NSJSONSerialization dataWithJSONObject:[p_BeanImage objectToJson] options:NSJSONWritingPrettyPrinted error:nil];

            //NSData* v_DataSend = [[PEG_FMobilitePegase CreateCoreData] jsonStructureFromManagedObjects:v_Array];
           // NSLog(@"=>requestPostBody: %@ ",[[NSString alloc] initWithData:v_DataSend encoding:NSUTF8StringEncoding]);
            [request setPostBody:[NSMutableData dataWithData:v_DataSend ]];
        
        
    }@catch(NSException* p_exception){
        // pm140219 TODO: check message next line
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestSaveImage: Erreur de requête requestSaveImage" andExparams:nil];
    }
	return request;
    
}

- (BOOL)processResponseSaveImage
{
    BOOL v_BOOL=NO;
    @try{
        NSDictionary* responseDictionary = [super processResponseWithJsonKeyPath];
        if ([responseDictionary count]!=0)
        {
            NSLog(@"DATA : %@",responseDictionary);
			NSString* v_retour = [responseDictionary stringForKeyPath:@"Type"];
            if([v_retour isEqualToString:@"S"])v_BOOL=YES;
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"processResponse: Erreur de requête SaveImage" andExparams:@""];
    }
    return v_BOOL;
}

@end
