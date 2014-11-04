//
//  PEG_GetBeanMobilitePegaseRequest.m
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_GetBeanMobilitePegaseRequest.h"
#import "PEGParametres.h"
#import "PEGException.h"
#import "SPIRTechnicalException.h"
#import "BeanMobilitePegase.h"
#import "PEG_FMobilitePegase.h"
#import "PEGAppDelegate.h"
#import "BeanLieu.h"
#import "BeanLieuPassage.h"

@implementation PEG_GetBeanMobilitePegaseRequest
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

+ (PEG_GetBeanMobilitePegaseRequest *)requestGetBeanMobilitePegaseByMatricule:(NSString*)p_Matricule andDate:(NSDate*)p_Date;
{
    PEG_GetBeanMobilitePegaseRequest *request;
    @try{
        
        //exemple exception
        //        NSException* v_exception = [NSException exceptionWithName:@"TEST" reason:@"REASON" userInfo:nil];
        //        [v_exception raise];
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        //[format setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZZ"];
        [format setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
        NSString* date = [format stringFromDate:p_Date];
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
        
        //http://adxnet.int.adrexo.fr/WS_MerchandisingV2/ServicesMerchandising.svc/REST/GetBeanMobilitePegaseByMatriculeDate?p_NoMatricule=00000619&p_DateReference=2013-04-29T08:15:30-05:00
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/GetBeanMobilitePegaseByMatriculeDate?p_NoMatricule=%@&p_DateReference=%@",UrlWebservice,p_Matricule,date];
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        DLog(@"=>request: %@ ",renderUrl);
        
        request = [PEG_GetBeanMobilitePegaseRequest requestWithURL:url];
        
        [request setSpecificTimeOutSeconds:600];
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestGetBeanMobilitePegaseByMatricule: Erreur de requête GetBeanMobilitePegaseByMatriculeDate" andExparams:[NSString stringWithFormat:@"p_Matricule=%@ Date=%@",p_Matricule,p_Date]];
    }
	return request;
    
}

- (BOOL)processResponse
{
    
    @try{
        
        NSDictionary* responseDictionary = [super processResponseWithJsonKeyPath];
        //      NSError *jSonError = nil;
        //    NSDictionary *responseDictionary = [NSDictionary dictionaryWithDictionary:[v_bouchon objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
        
        
        if ([responseDictionary count]!=0)
        {
            NSString* v_type = [responseDictionary stringForKeyPath:@"Type"];
            NSString* v_msg = [responseDictionary stringForKeyPath:@"Msg"];
            if([v_type isEqualToString:@"E"])
            {
                if (v_msg == nil) v_msg = @"Erreur inconnue";
                [[PEGException sharedInstance] ManageExceptionWithThrow:[[NSException alloc]init] andMessage:[NSString stringWithFormat:@"processResponse: Erreur de réponse du GetBeanMobilitePegase : %@",v_msg ] andExparams:nil];
            }
            NSString* responseString = [super responseString];
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            NSArray* v_array = [[PEG_FMobilitePegase CreateCoreData] managedObjectsFromJSONStructure:responseString withObjectName:@"BeanMobilitePegase" withManagedObjectContext:app.managedObjectContext andDedoublonnage:false];
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            for (BeanMobilitePegase* v_BMP in v_array) {
                [v_BMP setDateSynchro:[NSDate date]];
            }
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            NSString* v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
            DLog("%@",v_st);
        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyResponseException" format:@"La réponse du serveur est vide."];
        }
        
    }@catch(NSException* p_exception){
        
        //[self MessageErrorUser:@"GetReferentiel"];
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"processResponse: Erreur de requête processResponse" andExparams:nil];
        return false;
    }
    return true;
}

+ (PEG_GetBeanMobilitePegaseRequest *)requestGetBeanTourneeByMatricule:(NSString*)p_Matricule andDateDebut:(NSDate*)p_DateDebut andDateFin:(NSDate*)p_DateFin;
{
    PEG_GetBeanMobilitePegaseRequest *request;
    @try{
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString* dateDebut = [format stringFromDate:p_DateDebut];
        NSString* dateFin = [format stringFromDate:p_DateFin];
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
        
        //http://adxnet.int.adrexo.fr/WS_MerchandisingV2/ServicesMerchandising.svc/REST/GetBeanTourneeByMatriculeDate?p_NoMatricule=00000619&p_DateDebut=2013-04-29T08:15:30-05:00&p_DateFin=2013-04-29T08:15:30-05:00
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/GetBeanTourneeByMatriculeDate?p_NoMatricule=%@&p_DateDebut=%@&p_DateFin=%@",UrlWebservice,p_Matricule,dateDebut,dateFin];
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        DLog(@"=>request: %@ ",renderUrl);
        
        request = [PEG_GetBeanMobilitePegaseRequest requestWithURL:url];
        
        [request setSpecificTimeOutSeconds:600];
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestGetBeanTourneeByMatricule: Erreur de requête GetBeanTourneeByMatricule" andExparams:[NSString stringWithFormat:@"p_Matricule=%@ DateDebut=%@ DateFin=%@",p_Matricule,p_DateDebut,p_DateFin]];
    }
	return request;
    
}

- (BOOL)processResponseGetBeanTourneeByMatricule
{
    
    @try{
        
        NSDictionary* responseDictionary = [super processResponseWithJsonKeyPath];        
        
        if ([responseDictionary count]!=0)
        {
            NSString* v_type = [responseDictionary stringForKeyPath:@"Type"];
            NSString* v_msg = [responseDictionary stringForKeyPath:@"Msg"];
            if([v_type isEqualToString:@"E"])
            {
                if (v_msg == nil) v_msg = @"Erreur inconnue";
                [[PEGException sharedInstance] ManageExceptionWithThrow:[[NSException alloc]init] andMessage:[NSString stringWithFormat:@"processResponseGetBeanTourneeByMatricule: Erreur de réponse du Get Tournee BeanMobilitePegase : %@",v_msg ] andExparams:nil];
            }

            /////
            NSString* responseString = [super responseString];
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            NSArray* v_managedObjects =
            [[PEG_FMobilitePegase CreateCoreData] managedObjectsFromJSONStructure:responseString withObjectName:@"BeanMobilitePegase" withManagedObjectContext:app.managedObjectContext];
            
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            NSString* v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
            DLog("Insertion des tournees %@",v_st);
            
            //Si on a bien un BeanMobilitePegase, on supprime les lieux de passage dont le lieu n'existe plus
            if(v_managedObjects.count == 1)
            {
                BeanMobilitePegase* p_BeanMP = [v_managedObjects lastObject];
                
                bool v_IsExistLieu = false;
                for (BeanTournee* v_NouvelleTournee in p_BeanMP.listTournee)
                {
                    //On enleve les lieux de passage dont les lieux n'existent plus
                    for (BeanLieuPassage* v_NouveauLieuPassage in v_NouvelleTournee.listLieuPassage)
                    {
                        v_IsExistLieu = false;
                        for (BeanLieu* v_LieuExistant in p_BeanMP.listLieu)
                        {
                            if([v_NouveauLieuPassage.idLieu isEqualToNumber:v_LieuExistant.idLieu])
                            {
                                v_IsExistLieu = true;
                                break;
                            }
                        }
                        if(!v_IsExistLieu)
                        {
                            [app.managedObjectContext deleteObject:v_NouveauLieuPassage];
                        }
                    }
                }
            }
            
            [[PEG_FMobilitePegase CreateCoreData] Save];
            v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
            DLog("Suppression des Lieux passage sans lieu %@",v_st);
        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyResponseException" format:@"La réponse du serveur est vide."];
        }
        
    }@catch(NSException* p_exception){
        
        //[self MessageErrorUser:@"GetTournee"];
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"processResponse: Erreur de requête processResponseGetBeanTourneeByMatricule" andExparams:nil];
        return false;
    }
}

+ (PEG_GetBeanMobilitePegaseRequest *)requestSaveBeanMobilitePegase
{
    
    PEG_GetBeanMobilitePegaseRequest *request;
    @try{
        
        //exemple exception
        //        NSException* v_exception = [NSException exceptionWithName:@"test" reason:@"reason" userInfo:nil];
        //        [v_exception raise];
        
        PEGParametres* sharedCEXParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedCEXParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
        
        NSString* UrlService=@"/REST/SaveBeanMobilitePegase_POST";
        
        NSString* renderUrl=[NSString stringWithFormat:@"%@%@", UrlWebservice, UrlService];
        
        DLog(@"=>request: %@ ",renderUrl);
        
        request= [PEG_GetBeanMobilitePegaseRequest requestWithURL:[NSURL URLWithString:renderUrl]];
        [request setSpecificTimeOutSeconds:300];
        [request configureRequestInJsonCompressedFormat];
        
        //TODO à supprimer pour le passage en prod
        if([PEG_WS_ENVIRONNEMENT isEqualToString:@"INT"]
           || [PEG_WS_ENVIRONNEMENT isEqualToString:@"REC"])
        {
            NSArray* v_Array = [[PEG_FMobilitePegase CreateMobilitePegaseService] GetAllBeanMobilitePegase];
            NSData* v_DataSend = [[PEG_FMobilitePegase CreateCoreData] jsonStructureFromManagedObjectsModified:v_Array];
            //NSData* v_DataSend = [[PEG_FMobilitePegase CreateCoreData] jsonStructureFromManagedObjects:v_Array];
            NSLog(@"=>requestPostBody: %@ ",[[NSString alloc] initWithData:v_DataSend encoding:NSUTF8StringEncoding]);
            [request setPostBody:[NSMutableData dataWithData:v_DataSend ]];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"requestSaveBeanMobilitePegase: Erreur de requête sauvegarde BeanMobilitePegase" andExparams:nil];
    }
	return request;
    
}

-(BOOL) processResponseSave
{
    
    @try{
        NSDictionary* responseDictionary = [super processResponseWithJsonKeyPath];
        if ([responseDictionary count] != 0)
        {
            NSString* v_type = [responseDictionary stringForKeyPath:@"Type"];
            NSString* v_msg = [responseDictionary stringForKeyPath:@"Msg"];
            if([v_type isEqualToString:@"E"])
            {
                if (v_msg == nil) v_msg = @"Erreur inconnue";
                //[SPIRTechnicalException raise:@"WSException" format:v_msg];
                [[PEGException sharedInstance] ManageExceptionWithThrow:[[NSException alloc]init] andMessage:[NSString stringWithFormat:@"processResponseSave: Erreur de réponse de la sauvegarde de Mobilite pegase : %@",v_msg ] andExparams:nil];
            }
        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyResponseException" format:@"La réponse du serveur est vide."];
        }
        
    }@catch(NSException* p_exception){
        //[self MessageErrorUser:@"Save"];
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"processResponse: Erreur de réponse de la sauvegarde de Mobilite pegase" andExparams:nil];
        return false;
    }
    return true;
    
}


@end
