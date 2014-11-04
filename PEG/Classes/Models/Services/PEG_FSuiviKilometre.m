//
//  PEG_ServiceSuiviKilometre.m
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_FSuiviKilometre.h"
#import "PEGException.h"
#import "PEG_FTechnical.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEG_FMobilitePegase.h"
#import "PEGAppDelegate.h"
#import "BeanMobilitePegase.h"

@implementation PEG_FSuiviKilometre

#pragma mark Enregistrement vers le SI
/*-(void) SetSuiviKilometrageToSISynchronous
{
    @try
    {
        for (PEG_BeanSuiviKMUtilisateur* v_Item in [PEG_BeanMobilitePegase sharedInstance].ListSuiviKMUtilisateur)
        {
            if([v_Item.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Added])
            {
                [v_Item SetSuiviKMUtilisateurSynchronousWithObserver:self];
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans SetSuiviKilometrageToSI" andExparams:nil];
    }
}*/

#pragma mark Get
-(void) AddOrUpdateSuiviKilometragePourMatricule:(NSString *)p_Matricule andDate:(NSDate *)p_Date andKM:(NSNumber *)p_Km
{
    @try
    {
        [self AddOrUpdateSuiviKilometragePourMatricule:p_Matricule andDate:p_Date andKM:p_Km andFlagMAJ:PEG_EnumFlagMAJ_Added];
    }@catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddSuiviKilometragePourMatricule" andExparams:[NSString stringWithFormat:@"p_Matricule:%@, p_Date:%@, p_Km:%@",p_Matricule,p_Date,p_Km]];
    }
}

-(void) AddOrUpdateSuiviKilometragePourBeanSuiviKMUtilisateur:(BeanSuiviKMUtilisateur *)p_BeanSuiviKMUtilisateur
{
    @try
    {        
        [self AddOrUpdateSuiviKilometragePourMatricule:p_BeanSuiviKMUtilisateur.matricule andDate:p_BeanSuiviKMUtilisateur.date andKM:p_BeanSuiviKMUtilisateur.kilometrage andFlagMAJ:p_BeanSuiviKMUtilisateur.flagMAJ];
        
    }@catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddOrUpdateSuiviKilometragePourBeanSuiviKMUtilisateur" andExparams:@""];
    }
}

-(void) AddOrUpdateSuiviKilometragePourMatricule:(NSString *)p_Matricule andDate:(NSDate *)p_Date andKM:(NSNumber *)p_Km andFlagMAJ:(NSString*)p_FlagMAJ
{
    @try
    {
        bool v_IsUpdate = false;
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BeanSuiviKMUtilisateur" inManagedObjectContext:app.managedObjectContext];
        [request setEntity:entity];
        //[request setPredicate:[NSPredicate predicateWithFormat:@"matricule == %@ AND date >= %@ AND date <= %@",p_Matricule,[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]],[[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]dateByAddingTimeInterval:((3600*24)-1) ]]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"matricule == %@",p_Matricule]];
        
        NSArray *results = [app.managedObjectContext executeFetchRequest:request error:NULL];
                
        BeanSuiviKMUtilisateur* v_InfoMatricule;
        for (BeanSuiviKMUtilisateur* v_Item in results)
        {
            if([v_Item.matricule isEqualToString:p_Matricule])
            {
                v_InfoMatricule = v_Item;
                if([v_Item.date isEqualToDate:p_Date])
                {
                    if(![v_Item.kilometrage isEqualToNumber:p_Km])
                    {
                        v_Item.kilometrage = p_Km;
                        if(![v_Item.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Added])
                        {
                            v_Item.flagMAJ = PEG_EnumFlagMAJ_Modified;
                        }
                    }
                    v_IsUpdate = true;
                }
            }
        }
        if(!v_IsUpdate)
        {
            if(v_InfoMatricule == nil)
                [NSException raise:@"Utilisateur Inconnu" format:@"Impossible de trouver les infos associé au matricule connecté"];
            
            BeanSuiviKMUtilisateur * v_NewBeanSuiviKm = [NSEntityDescription insertNewObjectForEntityForName:@"BeanSuiviKMUtilisateur" inManagedObjectContext:app.managedObjectContext];
            [v_NewBeanSuiviKm setMatricule:p_Matricule];
            [v_NewBeanSuiviKm setNom:v_InfoMatricule.nom];
            [v_NewBeanSuiviKm setPrenom:v_InfoMatricule.prenom];
            [v_NewBeanSuiviKm setCodeAgence:v_InfoMatricule.codeAgence];
            [v_NewBeanSuiviKm setCodeSociete:v_InfoMatricule.codeSociete];
            [v_NewBeanSuiviKm setCodePays:v_InfoMatricule.codePays];
            [v_NewBeanSuiviKm setCodeLangAppli:v_InfoMatricule.codeLangAppli];
            [v_NewBeanSuiviKm setDate:p_Date];
            [v_NewBeanSuiviKm setKilometrage:p_Km];
            [v_NewBeanSuiviKm setFlagMAJ:p_FlagMAJ];
            //[v_NewBeanSuiviKm setParentMobilitePegase:v_InfoMatricule.parentMobilitePegase];
            
            BeanMobilitePegase* v_BMP =[[PEG_FMobilitePegase CreateMobilitePegaseService] GetOrCreateBeanMobilitePegaseByMatricule:p_Matricule];
            [v_BMP addListSuiviKMUtilisateurObject:v_NewBeanSuiviKm];
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
    }@catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddSuiviKilometragePourMatricule" andExparams:[NSString stringWithFormat:@"p_Matricule:%@, p_Date:%@, p_Km:%@",p_Matricule,p_Date,p_Km]];
    }
}


#pragma mark Get
- (NSNumber*) GetDernierKilometrageByMatricule:(NSString*)p_Matricule
{
    NSNumber* v_retour = nil;
    @try{
        
        DLog("%@",[[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData]);
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BeanSuiviKMUtilisateur" inManagedObjectContext:app.managedObjectContext];
        [request setEntity:entity];
        [request setPredicate:[NSPredicate predicateWithFormat:@"matricule == %@",p_Matricule]];
        // Results should be in descending order of timeStamp.
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSArray *results = [app.managedObjectContext executeFetchRequest:request error:NULL];
        if (results == nil) {
            // Handle the error.
        }
        else {
            if ([results count] > 0) {
                BeanSuiviKMUtilisateur *latestEntity = [results objectAtIndex:0];
                v_retour = latestEntity.kilometrage;
            }
        }       
        
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"GetDernierKilometrageDesignByMatricule" andExparams:p_Matricule];
    }
    return v_retour;
}


- (NSString*) GetDernierKilometrageDesignByMatricule:(NSString*)p_Matricule
{
    NSString* v_retour = nil;
    @try{
        v_retour = [[NSString alloc] init];
        
        NSNumber* v_Km = [self GetDernierKilometrageByMatricule:p_Matricule];
        if(v_Km == nil)
        {
            v_retour = @"Patientez...";
        }
        else
        {
            v_retour = [v_Km stringValue];
        }
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"GetDernierKilometrageDesignByMatricule" andExparams:p_Matricule];
    }
    return v_retour;
}



- (bool) IsKilometrageDuJourDejaSaisie:(NSString*)p_Matricule
{
    bool v_retour = false;
    @try{
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BeanSuiviKMUtilisateur" inManagedObjectContext:app.managedObjectContext];
        [request setEntity:entity];
        [request setPredicate:[NSPredicate predicateWithFormat:@"matricule == %@ AND date >= %@ AND date <= %@",p_Matricule,[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]],[[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]dateByAddingTimeInterval:((3600*24)-1) ]]];
        
        NSArray *results = [app.managedObjectContext executeFetchRequest:request error:NULL];
        if(results != nil && results.count > 0)
        {
            v_retour = true;
        }
    
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"IsKilometrageDuJourDejaSaisie" andExparams:p_Matricule];
    }
    return v_retour;
}

@end
