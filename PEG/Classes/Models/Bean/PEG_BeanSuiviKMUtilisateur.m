//
//  PEG_BeanSuiviKMUtilisateur.m
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGAppDelegate.h"
#import "PEG_BeanSuiviKMUtilisateur.h"
#import "PEG_FTechnical.h"
#import "PEG_ServicesMerchandisingRequests.h"
#import "PEG_FMobilitePegase.h"

@implementation PEG_BeanSuiviKMUtilisateur

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {Matricule :%@, Nom :%@, Prenom :%@, CodeAgence :%@, CodeSociete :%@, CodePays :%@, CodeLangAppli :%@, Date: %@, Kilometrage :%@, FlagMAJ : %@}",
			NSStringFromClass([self class]),
			self,
            self.Matricule,
            self.Nom,
            self.Prenom,
            self.CodeAgence,
            self.CodeSociete,
            self.CodePays,
            self.CodeLangAppli,
			self.Date,
            self.Kilometrage,
            self.FlagMAJ];
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    self = [self init];
    if (self)
    {
        self.Matricule = [p_json stringForKeyPath:@"matricule"];
        self.Nom = [p_json stringForKeyPath:@"nom"];
        self.Prenom = [p_json stringForKeyPath:@"prenom"];
        self.CodeAgence = [p_json stringForKeyPath:@"codeAgence"];
        self.CodeSociete = [p_json stringForKeyPath:@"codeSociete"];
        self.CodePays = [p_json stringForKeyPath:@"codePays"];
        self.CodeLangAppli = [p_json stringForKeyPath:@"codeLangAppli"];
        self.Date = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"cate"]];
        self.Kilometrage = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"kilometrage"]];
        self.FlagMAJ = [p_json stringForKeyPath:@"flagMAJ"];
    }
    
    //[[PEG_FMobilitePegase CreateCoreData] coreDataEntityToJson:@"BeanSuiviKMUtilisateur"];
    
    return self;
}

-(id) initCDWithJson :(NSDictionary*)p_json
{
    self = [self init];
//    if (self)
//    {
//        self.Matricule = [p_json stringForKeyPath:@"Matricule"];
//        self.Nom = [p_json stringForKeyPath:@"Nom"];
//        self.Prenom = [p_json stringForKeyPath:@"Prenom"];
//        self.CodeAgence = [p_json stringForKeyPath:@"CodeAgence"];
//        self.CodeSociete = [p_json stringForKeyPath:@"CodeSociete"];
//        self.CodePays = [p_json stringForKeyPath:@"CodePays"];
//        self.CodeLangAppli = [p_json stringForKeyPath:@"CodeLangAppli"];
//        self.Date = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"Date"]];
//        self.Kilometrage = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"Kilometrage"]];
//        self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
//        
//        //CoreData
//        //On n'insert que si la ligne n'existe pas
//        PEGAppDelegate *app = [UIApplication sharedApplication].delegate;
//        
//        //On vérifie si la ligne existe déjà
//        NSFetchRequest *req = [[NSFetchRequest alloc]init];
//        [req setEntity:[NSEntityDescription entityForName:@"BeanSuiviKMUtilisateur" inManagedObjectContext:app.managedObjectContext]];
//        NSString* v_Mat = [p_json stringForKeyPath:@"Matricule"];
//        NSDate* v_Date = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"Date"]];
//        [req setPredicate:[NSPredicate predicateWithFormat:@"matricule == %@ AND date == %@",v_Mat,v_Date]];
//        
//        BeanSuiviKMUtilisateur *std = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
//        if(std != nil)
//        {
//            //La ligne existe déjà on ne fait rien
//        }
//        else
//        {
//            BeanSuiviKMUtilisateur *v_Bean = (BeanSuiviKMUtilisateur *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanSuiviKMUtilisateur" inManagedObjectContext:app.managedObjectContext];
//            [v_Bean setMatricule:[p_json stringForKeyPath:@"Matricule"]];
//            [v_Bean setNom:[p_json stringForKeyPath:@"Nom"]];
//            [v_Bean setPrenom:[p_json stringForKeyPath:@"Prenom"]];
//            [v_Bean setCodeAgence:[p_json stringForKeyPath:@"CodeAgence"]];
//            [v_Bean setCodeSociete:[p_json stringForKeyPath:@"CodeSociete"]];
//            [v_Bean setCodePays:[p_json stringForKeyPath:@"CodePays"]];
//            [v_Bean setCodeLangAppli:[p_json stringForKeyPath:@"CodeLangAppli"]];
//            [v_Bean setDate:[PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"Date"]]];
//            [v_Bean setKilometrage:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"Kilometrage"]]];
//            [v_Bean setFlagMAJ:[p_json stringForKeyPath:@"FlagMAJ"]];
//            [app.managedObjectContext save:nil];
//        }
//        //CoreData
//    }
//    
//    [[PEG_FMobilitePegase CreateCoreData] coreDataEntityToJson:@"BeanSuiviKMUtilisateur"];
//    
    return self;
}

-(NSMutableDictionary* ) objectToJson
{
    
    /*NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.Matricule,@"Matricule",
                                     self.Nom,@"Nom",
                                     self.Prenom,@"Prenom",
                                     self.CodeAgence,@"CodeAgence",
                                     self.CodeSociete,@"CodeSociete",
                                     self.CodePays,@"CodePays",
                                     self.CodeLangAppli,@"CodeLangAppli",
                                     [PEG_FTechnical getJsonFromDate:self.Date],@"Date",
                                     self.Kilometrage,@"Kilometrage",
                                     self.FlagMAJ,@"FlagMAJ",
                                     nil];*/
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.Matricule != nil)[v_Return2 setObject:self.Matricule forKey:@"matricule"];
    if (self.Nom != nil)[v_Return2 setObject:self.Nom forKey:@"nom"];
    if (self.Prenom != nil)[v_Return2 setObject:self.Prenom forKey:@"prenom"];
    if (self.CodeAgence != nil)[v_Return2 setObject:self.CodeAgence forKey:@"codeAgence"];
    if (self.CodeSociete != nil)[v_Return2 setObject:self.CodeSociete forKey:@"codeSociete"];
    if (self.CodePays != nil)[v_Return2 setObject:self.CodePays forKey:@"codePays"];
    if (self.CodeLangAppli != nil)[v_Return2 setObject:self.CodeLangAppli forKey:@"codeLangAppli"];
    if ([PEG_FTechnical getJsonFromDate:self.Date] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.Date] forKey:@"date"];
    if (self.Kilometrage != nil)[v_Return2 setObject:self.Kilometrage forKey:@"kilometrage"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"flagMAJ"];
    
    return v_Return2;
}

#pragma mark Data-Access methods model
- (void) GetLastSuiviKMUtilisateurWithObserver:(id<PEG_BeanSuiviKMUtilisateurDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule
{
    self.observer = p_ObserverOwner;
    
    
    PEG_ServicesMerchandisingRequests* request = [PEG_ServicesMerchandisingRequests requestGetLastSuiviKilometreByMatricule:p_Matricule];
    //[self clear];
    
    
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
                 if (self.observer && [self.observer respondsToSelector:@selector(fillFinishedErrorGetLastSuiviKMUtilisateur)])
                 {
                     [self.observer fillFinishedErrorGetLastSuiviKMUtilisateur];
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
         if (self.observer)
         {
             if([self.observer respondsToSelector:@selector(fillFinishedGetLastSuiviKMUtilisateur)])
             {
                 [self.observer fillFinishedGetLastSuiviKMUtilisateur];
             }
         }
         
     }];
    
    // traitement des erreurs réseau
    [request setFailedBlock:^
     {
         
         //self.infoGeneraleVenteFailed = YES;
         if (self.observer && [self.observer respondsToSelector:@selector(fillFinishedErrorGetLastSuiviKMUtilisateur)])
         {
             [self.observer fillFinishedErrorGetLastSuiviKMUtilisateur];
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

- (void) SetSuiviKMUtilisateurSynchronousWithObserver:(id<PEG_BeanSuiviKMUtilisateurDataSource>)p_ObserverOwner
{
    self.observer = p_ObserverOwner;
    
    
    PEG_ServicesMerchandisingRequests* request = [PEG_ServicesMerchandisingRequests requestSetBeanSuiviKilometreByMatriculeDate:self.Matricule andDate:self.Date andKm:self.Kilometrage];
    //[self clear];
    
    [request setStartedBlock:^
     {
     }];
    
    [request setCompletionBlock:^
     {
         @try
         {
             [request processResponseSetBeanSuiviKilometre:self];
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
         if (self.observer && [self.observer respondsToSelector:@selector(fillFinishedSetSuiviKMUtilisateur)])
         {
             [self.observer fillFinishedSetSuiviKMUtilisateur];
         }
         
     }];
    
    // traitement des erreurs réseau
    [request setFailedBlock:^
     {
         
         //self.infoGeneraleVenteFailed = YES;
         if (self.observer && [self.observer respondsToSelector:@selector(fillFinishedSetSuiviKMUtilisateur)])
         {
             [self.observer fillFinishedSetSuiviKMUtilisateur];
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
    [request startSynchronous];
    
}

@end
