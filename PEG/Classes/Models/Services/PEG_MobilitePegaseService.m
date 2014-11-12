//
//  PEG_MobilitePegaseService.m
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_MobilitePegaseService.h"
#import "PEGException.h"
#import "SPIRTechnicalException.h"
#import "NSDictionary+ConvenientAccess.h"
#import "PEG_FTechnical.h"
#import "BeanTournee.h"
#import "PEGAppDelegate.h"
#import "PEG_GetBeanMobilitePegaseRequest.h"
#import "PEG_ServicesMerchandisingRequests.h"
#import "PEG_FMobilitePegase.h"
#import "PEGException.h"
#import "PEGSession.h"


@implementation PEG_MobilitePegaseService

-(void) AppelAssistance
{
    @try
    {
        //Florent
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0442337344"]];
        //Interway
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0442336545"]];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AppelAssistance" andExparams:@""];
    }
}

-(BOOL) IsChangementJourDepuisDerniereSynchro
{
    BOOL v_retour = NO;
    @try
    {
        BeanMobilitePegase* v_BeanMP = [self GetBeanMobilitePegaseByMatricule:[[PEGSession sharedPEGSession] matResp]];
        //Si les dates (sans heure) ne sont pas les mêmes, il y a ey changement de jour
        if(v_BeanMP.dateSynchro != nil)
        {
            if( [[PEG_FTechnical GetDateYYYYMMDDFromDate:v_BeanMP.dateSynchro ] compare:[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]] != NSOrderedSame)
            {
                v_retour = YES;
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsChangementJourDepuisDerniereSynchro" andExparams:@""];
    }
    return v_retour;
}

-(NSArray*) GetAllBeanMobilitePegase
{
    NSArray* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanMobilitePegase" inManagedObjectContext:app.managedObjectContext]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetAllBeanMobilitePegase" andExparams:@""];
    }
    return v_retour;
}

-(BeanMobilitePegase*) GetBeanMobilitePegaseByMatricule:(NSString*)p_Matricule
{
    BeanMobilitePegase* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanMobilitePegase" inManagedObjectContext:app.managedObjectContext]];
        
        [req setPredicate:[NSPredicate predicateWithFormat:@"matricule == %@",p_Matricule]];
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetAllBeanMobilitePegase" andExparams:@""];
    }
    return v_retour;
}

-(BeanMobilitePegase*) GetOrCreateBeanMobilitePegaseByMatricule:(NSString*)p_Matricule
{
    BeanMobilitePegase* v_retour = nil;
    @try
    {
        v_retour = [self GetBeanMobilitePegaseByMatricule:p_Matricule];
        
        if(v_retour == nil)
        {
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            v_retour = (BeanMobilitePegase *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanMobilitePegase" inManagedObjectContext:app.managedObjectContext];
            [v_retour setVersion:[[NSNumber alloc]initWithInt:0]];
            [v_retour setMatricule:p_Matricule];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetOrCreateBeanMobilitePegaseByMatricule" andExparams:@""];
    }
    return v_retour;
}



#pragma mark Data-Access methods model
- (void) GetLastSuiviKMUtilisateurWithObserver:(id<PEG_BeanSuiviKMUtilisateurDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule
{
    self.observerKM = p_ObserverOwner;
    
    PEG_ServicesMerchandisingRequests* request = [PEG_ServicesMerchandisingRequests requestGetLastSuiviKilometreByMatricule:p_Matricule];
    
    [request setStartedBlock:^
     {
     }];

    [request setCompletionBlock:^
     {
         @try
         {
             BOOL v_OK = [request processResponseGetLastSuiviKilometre];
             if(!v_OK)
             {
                 if (self.observerKM && [self.observerKM respondsToSelector:@selector(fillFinishedErrorGetLastSuiviKMUtilisateur)])
                 {
                     [self.observerKM fillFinishedErrorGetLastSuiviKMUtilisateur];
                 }
             }
             
         }
         @catch (SPIRException *exception)
         {
             //self.infoGeneraleVenteFailed = YES;
             
             // traitement de l'exception si on n'a pas de messages SAP
             if (![request hasMessages])
             {
                 //                 __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Echec de récuperation de données"
                 //                                                                             message:[NSString stringWithFormat:@"%@\nSouhaitez-vous réessayer ?", exception.reason]
                 //                                                                   cancelButtonTitle:@"Fermer"
                 //                                                                   otherButtonTitles:@"Réessayer", nil];
                 //                 [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
                 //                  {
                 //                      if (buttonIndex == 1)
                 //                      {
                 //                          [self loadTarifs];
                 //                      }
                 //                      else
                 //                      {
                 //                          [self dismissModalViewControllerAnimated:YES];
                 //                      }
                 //                  }];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         @finally
         {
             // traitement messages SAP
             if ([request hasMessages])
             {
                 //                 SPIRMessage *message = requestTarif.mainMessage;
                 //                 EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:message.title message:message.text cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         if (self.observerKM)
         {
             if([self.observerKM respondsToSelector:@selector(fillFinishedGetLastSuiviKMUtilisateur)])
             {
                 [self.observerKM fillFinishedGetLastSuiviKMUtilisateur];
             }
         }
         
     }];
    
    // traitement des erreurs réseau
    [request setFailedBlock:^
     {
         if ([request.error.domain isEqualToString:@"ASIHTTPRequestErrorDomain"] && request.error.code == 2)
         {
             [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"GetLastSuiviKMUtilisateurWithObserver: TimeOut" andExparams:nil];
         }
         //self.infoGeneraleVenteFailed = YES;
         if (self.observerKM && [self.observerKM respondsToSelector:@selector(fillFinishedErrorGetLastSuiviKMUtilisateur)])
         {
             [self.observerKM fillFinishedErrorGetLastSuiviKMUtilisateur];
         }
         
         //         __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:requestTarif.errorTitle
         //                                                                     message:[NSString stringWithFormat:@"%@\nSouhaitez-vous essayer ?", requestTarif.errorMessage]
         //                                                           cancelButtonTitle:@"Fermer"
         //                                                           otherButtonTitles:@"Réessayer", nil];
         //         [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
         //          {
         //              if (buttonIndex == 1)
         //              {
         //                  [self loadTarifs];
         //              }
         //              else
         //              {
         //                  [self dismissModalViewControllerAnimated:YES];
         //              }
         //          }];
         //         [alertView show];
         //         [alertView release];
     }];
    
    //    // lancement de la requête
    [request startAsynchronous];
    
}

@end
