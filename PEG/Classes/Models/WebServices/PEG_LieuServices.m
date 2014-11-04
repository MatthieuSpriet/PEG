//
//  PEG_LieuServices.m
//  PEG
//
//  Created by 10_200_11_120 on 01/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_LieuServices.h"
#import "PEGException.h"
#import "BeanMobilitePegase.h"
#import "PEGSession.h"
#import "BeanHistoriqueParutionPresentoir.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_EnuActionMobilite.h"
#import "BeanTache.h"
#import "Math.h"
#import "MapKit/MapKit.h"
#import "PEG_FTechnical.h"
#import "BeanConcurentLieu.h"
#import "BeanLieuPassage.h"
#import "PEGAppDelegate.h"
#import "BeanPresentoir.h"
#import "PEG_EnumFlagMAJ.h"
#import "BeanHoraire.h"
#import "PEG_EnuActionMobilite.h"
#import "PEG_FTechnical.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"
#import "PEG_EnumActionTache.h"
#import "PEG_BeanPresentoirParution.h"
#import "PEG_EnumActionTache.h"
#import "PEG_FTechnical.h"
#import "PEG_BeanHistoParution.h"
#import "BeanPresentoirParution.h"
#import "BeanAction.h"

@implementation PEG_LieuServices

-(NSArray*) GetAllBeanLieuActif
{
    NSArray* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"codeEtatLieu == %@",@"ACT"]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuById" andExparams:@""];
    }
    return v_retour;
}
-(NSArray*) GetAllBeanLieuActifAvecCoordGPS
{
    NSArray* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"codeEtatLieu == %@ && coordXpda != 0 && coordYpda != 0",@"ACT"]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuById" andExparams:@""];
    }
    return v_retour;
}
-(NSArray*) GetAllBeanLieuEnAlerte
{
    NSMutableArray* v_retour = [NSMutableArray array];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"codeEtatLieu == %@",@"ACT"]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanLieu* v_Lieu in v_array) {
            // Lieu non visités depuis 60 jours
            //date1 is earlier than date2
            //if([v_Lieu.dateDerniereVisite compare:[[NSDate date]dateByAddingTimeInterval:-((3600*24)*60)]] == NSOrderedAscending)
            /*if(([PEG_FTechnical GetNbJourEntreDeuxDatesWithDate1:v_Lieu.dateDerniereVisite AndDate2:[NSDate date]] > 60))
            {
                [v_retour addObject:v_Lieu];
            }
            else{
                BOOL v_IsPhotoAlerte = NO;
                for (BeanPresentoir* v_BeanPres in v_Lieu.listPresentoir) {
                    if([[PEG_FMobilitePegase CreatePresentoir] IsAlertePhotoOnPresentoir:v_BeanPres])
                    {
                        v_IsPhotoAlerte = YES;
                    }
                }
                [v_retour addObject:v_Lieu];
            }*/
            if([self IsLieuEnAlerte:v_Lieu])
            {
                [v_retour addObject:v_Lieu];
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetAllBeanLieuEnAlerte" andExparams:@""];
    }
    return v_retour;
}

-(NSArray*) GetAllBeanLieuInactif
{
    NSMutableArray* v_retour = [NSMutableArray array];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"codeEtatLieu != %@",@"ACT"]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanLieu* v_Lieu in v_array) {
            //if(![v_Lieu.codeEtatLieu isEqualToString:@"ACT"])
            //{
                [v_retour addObject:v_Lieu];
            //}
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetAllBeanLieuInactif" andExparams:@""];
    }
    return v_retour;
}

-(BeanLieu*) GetBeanLieuById:(NSNumber *)p_idLieu
{
    BeanLieu* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idLieu == %@",p_idLieu]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuById" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    return v_retour;
}

-(BOOL) isLieuActif:(NSNumber *)p_idLieu{
    BOOL v_retour = NO;
    @try
    {
        BeanLieu* v_BeanLieu=[[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_idLieu];
        if([v_BeanLieu.codeEtatLieu isEqualToString:@"ACT"]){
            if(v_BeanLieu.codeProchainEtatLieu == nil || [v_BeanLieu.codeProchainEtatLieu isEqualToString:@"ACT"]){
                v_retour = YES;
            }
            else{
                v_retour = NO;
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuById" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    return v_retour;
}

/*-(PEG_BeanLieuPassage*) GetBeanLieuPassageById:(NSNumber *)p_idLieuPassage AndBeanMobilitePegase:(PEG_BeanMobilitePegase*)p_BeanMobilitePegase
 {
 PEG_BeanLieuPassage* v_retour = nil;
 @try
 {
 for (PEG_BeanTournee* v_RowTournee in p_BeanMobilitePegase.ListTournee)
 {
 for (PEG_BeanLieuPassage* v_RowLieuPassage in v_RowTournee.ListLieuPassage)
 {
 
 if([v_RowLieuPassage.IdLieuPassage isEqualToNumber:p_idLieuPassage])
 {
 v_retour=v_RowLieuPassage;
 break;
 }
 }
 }
 }
 @catch(NSException* p_exception){
 [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuPassageById" andExparams:[NSString stringWithFormat:@"p_idLieuPassage:%@",p_idLieuPassage]];
 }
 return v_retour;
 }*/

-(BeanLieuPassage*) GetBeanLieuPassageById:(NSNumber *)p_idLieuPassage
{
    BeanLieuPassage* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idLieuPassage == %@",p_idLieuPassage]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuPassageById" andExparams:[NSString stringWithFormat:@"p_idLieuPassage:%@",p_idLieuPassage]];
    }
    return v_retour;
}

-(BeanLieuPassage*) GetBeanLieuPassageOnTourneeMerchByIdLieu:(NSNumber *)p_idLieu
{
    BeanLieuPassage* v_retour = nil;
    @try
    {
        BeanTournee* v_BeanTournee = [[PEG_FMobilitePegase CreateTournee] GetTourneeMerchDuJour];
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idLieu == %@ AND idTournee == %@",p_idLieu,v_BeanTournee.idTournee]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        if(v_array != nil && v_array.count > 0)
        {
            v_retour = [v_array lastObject];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuPassageOnTourneeMerchByIdLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    return v_retour;
}
-(BeanLieuPassage*) GetBeanLieuPassageByIdLieu:(NSNumber *)p_idLieu andIdTournee:(NSNumber*)p_idTournee
{
    BeanLieuPassage* v_retour = nil;
    @try
    {
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idLieu == %@ AND idTournee == %@",p_idLieu,p_idTournee]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        if(v_array != nil && v_array.count > 0)
        {
            v_retour = [v_array lastObject];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuPassageByIdLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@ p_idTournee:%@",p_idLieu,p_idTournee]];
    }
    return v_retour;
}

-(BeanLieuPassage*) GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:(NSNumber *)p_idLieu
{
    BeanLieuPassage* v_retour = nil;
    @try
    {
        v_retour = [self GetBeanLieuPassageOnTourneeMerchByIdLieu:p_idLieu];
        if(v_retour == nil ){
            BeanTournee* v_BeanTournee = [[PEG_FMobilitePegase CreateTournee] GetTourneeMerchDuJour];
            
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            
            // On determine le prochain numéro d'ordre de passage
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext]];
            [req setPredicate:[NSPredicate predicateWithFormat:@"idTournee == %@",v_BeanTournee.idTournee]];
            NSArray* v_arrayLieuPassageTournee = [app.managedObjectContext executeFetchRequest:req error:nil];
            
            v_retour = (BeanLieuPassage *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext];
            [v_retour setNbOrdrePassage:[[NSNumber alloc]initWithInt:v_arrayLieuPassageTournee.count + 1]];
            [v_retour setNbNewOrdrePassage:[[NSNumber alloc]initWithInt:v_arrayLieuPassageTournee.count + 1]];
            [v_retour setIdLieu:p_idLieu];
            [v_retour setIdTournee:v_BeanTournee.idTournee];
            [v_retour setDateValeur:[NSDate date]];
            [v_retour setDatePassageReel:[NSDate date]];
            [v_retour setFlagCreerMerch:[[NSNumber alloc]initWithBool:true]];
            [v_retour setFlagMAJ:PEG_EnumFlagMAJ_Added];
            
            [v_BeanTournee addListLieuPassageObject:v_retour];
            [v_BeanTournee setFlagMAJ:PEG_EnumFlagMAJ_Modified];
            
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    return v_retour;
}
-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution
{
    int v_retour = 0;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_IdPresentoir,p_IdParution,PEG_EnuActionMobilite_Previ]];
        
        BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        if(v_Bean != nil)
        {
            v_retour += [v_Bean.quantitePrevue intValue];
        }
        
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetQteDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_IdPresentoir,p_IdParution]];
    }
    return [[NSNumber alloc] initWithInt:v_retour];
}

-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (BeanAction* v_Item in p_LieuPassage.listAction)
        {
            if([v_Item.idParution isEqualToNumber:p_IdParution])
            {
                if([v_Item.idPresentoir isEqualToNumber:p_IdPresentoir]
                   && [v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Previ])
                {
                    v_Qte += [v_Item.quantitePrevue intValue];
                }
            }
        }
        v_retour = [[NSNumber alloc]initWithInt:v_Qte];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"GetQtePrevueByPresentoir LieuPassage:%@",self.description] andExparams:nil];
    }
    return v_retour;
}

-(NSNumber*) GetQteDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    int v_retour = 0;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_idPresentoir,p_idParution,PEG_EnuActionMobilite_Distri]];
        
        //BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanAction* v_Bean in v_array) {
            v_retour += [v_Bean.quantiteDistribuee intValue];
        }
        
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetQteDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return [[NSNumber alloc] initWithInt:v_retour];
}
-(NSNumber*) GetQteDistriByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (BeanAction* v_Item in p_LieuPassage.listAction)
        {
            if([v_Item.idPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_Item.idParution isEqualToNumber:p_IdParution]
               && [v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Distri])
            {
                if(v_Item.quantiteDistribuee != nil)
                {
                    v_Qte += [v_Item.quantiteDistribuee intValue];
                }
            }
        }
        v_retour = [NSNumber numberWithInt:v_Qte];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"GetQteDistriByPresentoir LieuPassage:%@",p_LieuPassage] andExparams:nil];
    }
    return v_retour;
}



-(NSNumber*) GetHistoQteDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    int v_retour = 0;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //Qte Historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanHistoriqueParutionPresentoir" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idParution == %@ AND idPresentoir == %@",p_idParution,p_idPresentoir]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanHistoriqueParutionPresentoir* v_RowHistoParutionPresentoir in v_array)
        {
            v_retour += [v_RowHistoParutionPresentoir.qteDistri integerValue];
        }
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        /*req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_idPresentoir,p_idParution,PEG_EnuActionMobilite_Distri]];
        BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        if(v_Bean != nil)
        {
            v_retour += [v_Bean.quantiteDistribuee intValue];
        }*/
        
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetQteDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return [[NSNumber alloc] initWithInt:v_retour];
}
-(NSArray*) GetHistoListQteDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    NSMutableArray* v_retour=[NSMutableArray array];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //Qte Historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanHistoriqueParutionPresentoir" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idParution == %@ AND idPresentoir == %@",p_idParution,p_idPresentoir]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanHistoriqueParutionPresentoir* v_RowHistoParutionPresentoir in v_array)
        {
            [v_retour addObject: v_RowHistoParutionPresentoir.qteDistri ];
        }
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_idPresentoir,p_idParution,PEG_EnuActionMobilite_Distri]];
        
        NSArray* v_array2 = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanAction* v_RowAction in v_array2)
        {
            [v_retour addObject: v_RowAction.quantiteDistribuee ];
        }
        
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetHistoListQteDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return v_retour;
}

-(NSArray*) GetHistoListDateDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    NSMutableArray* v_retour=[NSMutableArray array];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //Qte Historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanHistoriqueParutionPresentoir" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idParution == %@ AND idPresentoir == %@",p_idParution,p_idPresentoir]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanHistoriqueParutionPresentoir* v_RowHistoParutionPresentoir in v_array)
        {
            [v_retour addObject: v_RowHistoParutionPresentoir.date ];
        }
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_idPresentoir,p_idParution,PEG_EnuActionMobilite_Distri]];
        
        NSArray* v_array2 = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanAction* v_RowAction in v_array2)
        {
            [v_retour addObject: v_RowAction.dateAction ];
        }
        
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetHistoListDateDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return v_retour;
}

-(NSArray*) GetListHistoDistriByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    NSMutableArray* v_retour=[NSMutableArray array];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //Qte Historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanHistoriqueParutionPresentoir" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idParution == %@ AND idPresentoir == %@",p_idParution,p_idPresentoir]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanHistoriqueParutionPresentoir* v_RowHistoParutionPresentoir in v_array)
        {
            PEG_BeanHistoParution* v_newRow = [[PEG_BeanHistoParution alloc] init];
            BeanParution* v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:p_idParution];
            v_newRow.NumParution = v_BeanParution.nomParution;
            v_newRow.QteDistri = [v_RowHistoParutionPresentoir.qteDistri intValue];
            v_newRow.QteRetour = -1 * [v_RowHistoParutionPresentoir.qteRetour intValue];
            v_newRow.dateDistri = v_RowHistoParutionPresentoir.date;
            [v_retour addObject: v_newRow ];
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetHistoListDateDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return v_retour;
}

-(NSArray*) GetListHistoDistriByIdPresentoir:(NSNumber*)p_idPresentoir andIdEdition:(NSNumber*)p_idEdition
{
    NSMutableArray* v_retour=[NSMutableArray array];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //Qte Historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BeanParution" inManagedObjectContext:app.managedObjectContext];
        [req setEntity:entity];
        req.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"id"]];
        req.returnsDistinctResults = YES;
        req.resultType = NSManagedObjectResultType;
        [req setPredicate:[NSPredicate predicateWithFormat:@"idEdition == %@",p_idEdition]];
        NSSortDescriptor *sortDescription = [[NSSortDescriptor alloc] initWithKey:@"dateDebut" ascending:NO];
        //NSArray * sortDescriptionArray = [[NSArray alloc] initWithObjects: sortDescription, nil];
        [req setSortDescriptors: [NSArray arrayWithObject:sortDescription ]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanParution* v_Parution in v_array)
        {
            NSFetchRequest *req2 = [[NSFetchRequest alloc]init];
            [req2 setEntity:[NSEntityDescription entityForName:@"BeanHistoriqueParutionPresentoir" inManagedObjectContext:app.managedObjectContext]];
            [req2 setPredicate:[NSPredicate predicateWithFormat:@"idParution == %@ AND idPresentoir == %@",v_Parution.id,p_idPresentoir]];
            
            NSArray* v_array2 = [app.managedObjectContext executeFetchRequest:req2 error:nil];
            for (BeanHistoriqueParutionPresentoir* v_RowBeanHistoriqueParutionPresentoir in v_array2)
            {
                PEG_BeanHistoParution* v_newRow = [[PEG_BeanHistoParution alloc] init];
                BeanParution* v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_Parution.id];
                v_newRow.NumParution = v_BeanParution.nomParution;
                v_newRow.QteDistri = [v_RowBeanHistoriqueParutionPresentoir.qteDistri intValue];
                v_newRow.QteRetour = -1 * [v_RowBeanHistoriqueParutionPresentoir.qteRetour intValue];
                v_newRow.dateDistri = v_RowBeanHistoriqueParutionPresentoir.date;
                [v_retour addObject: v_newRow ];
            }
        }

    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetHistoListDateDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idEdition:%@",p_idPresentoir,p_idEdition]];
    }
    return v_retour;
}

-(NSNumber*) GetQteRetourBonEtatByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    int v_retour = 0;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_idPresentoir,p_idParution,PEG_EnuActionMobilite_RetourBonEtat]];
        
        //BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanAction* v_Bean in v_array) {
            v_retour += [v_Bean.quantiteRecuperee intValue];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetQteRetourBonEtatByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return [[NSNumber alloc] initWithInt:v_retour];
}

-(NSNumber*) GetQteRetourByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    int v_retour = 0;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_idPresentoir,p_idParution,PEG_EnuActionMobilite_Retour]];
        
        //BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanAction* v_Bean in v_array) {
            v_retour += [v_Bean.quantiteRecuperee intValue];
        } 
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetQteRetourByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return [[NSNumber alloc] initWithInt:v_retour];
}


-(NSNumber*) GetQteRetourByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (BeanAction* v_Item in p_LieuPassage.listAction)
        {
            if([v_Item.idPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_Item.idParution isEqualToNumber:p_IdParution]
               && [v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Retour])
            {
                v_Qte += [v_Item.quantiteRecuperee intValue];
            }
        }
        v_retour = [NSNumber numberWithInt:v_Qte];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"GetQteRetourByPresentoir LieuPassage:%@",self.description] andExparams:nil];
    }
    return v_retour;
}
-(NSNumber*) GetHistoQteRetourByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution
{
    int v_retour = 0;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //Qte Historique
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanHistoriqueParutionPresentoir" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idParution == %@ AND idPresentoir == %@",p_idParution,p_idPresentoir]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        for (BeanHistoriqueParutionPresentoir* v_RowHistoParutionPresentoir in v_array)
        {
            v_retour += [v_RowHistoParutionPresentoir.qteRetour integerValue];
        }
        
        //On ajoute les qté Compte Rendu pas encore dans l'historique
        req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and idParution == %@ and codeAction == %@",p_idPresentoir,p_idParution,PEG_EnuActionMobilite_Retour]];
        
        BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        if(v_Bean != nil)
        {
            v_retour += [v_Bean.quantiteDistribuee intValue];
        }
        
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetQteDistribueeByIdPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@",p_idPresentoir,p_idParution]];
    }
    return [[NSNumber alloc] initWithInt:v_retour];
}

-(void) AddOrUpdateQteDistribueByIdLieu:(NSNumber*)p_IdLieu andIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution andQte:(NSNumber*)p_Qte
{
    @try
    {
        BeanAction* v_CR = nil;
        
        //BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageById:p_IdLieuPassage];
        BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        for (BeanAction* v_RowAct in v_LieuPassage.listAction){
            if([v_RowAct.idPresentoir isEqualToNumber:p_idPresentoir]
               && [v_RowAct.idParution isEqualToNumber:p_idParution]
               && [v_RowAct.codeAction isEqualToString:PEG_EnuActionMobilite_Distri])
            {
                v_CR = v_RowAct;
                break;
            }
        }
        if(v_CR == nil)
        {
            BeanAction* v_CR = [[PEG_FMobilitePegase CreateActionPresentoir] CreateBeanActionForNewQteDistribuee:[[NSNumber alloc] initWithInt:[p_Qte intValue]] andIdPresentoir:p_idPresentoir andIdParution:p_idParution];
            v_CR.idLieu = v_LieuPassage.idLieu;
            [v_LieuPassage addListActionObject:v_CR];
        }
        else
        {
            v_CR.quantiteDistribuee = [[NSNumber alloc] initWithInt:[p_Qte intValue]];
            PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
            v_CR.coordX = v_Pt.Long;
            v_CR.coordY = v_Pt.Lat;
            v_CR.coordGPSFiable= v_Pt.CoordFiable;
            [v_CR setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddOrUpdateQteDistribueByIdLieuPassage" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@,p_Qte:%@",p_idPresentoir,p_idParution,p_Qte]];
    }
}

-(void) AddOrUpdateQteRetourBonEtatByIdLieu:(NSNumber*)p_IdLieu andIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution andQte:(NSNumber*)p_Qte
{
    @try
    {
        BeanAction* v_CR = nil;
        
        //BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageById:p_IdLieuPassage];
        BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        for (BeanAction* v_RowAct in v_LieuPassage.listAction){
            if([v_RowAct.idPresentoir isEqualToNumber:p_idPresentoir]
               && [v_RowAct.idParution isEqualToNumber:p_idParution]
               && [v_RowAct.codeAction isEqualToString:PEG_EnuActionMobilite_RetourBonEtat])
            {
                v_CR = v_RowAct;
                break;
            }
        }
        if(v_CR == nil)
        {
            BeanAction* v_CR = [[PEG_FMobilitePegase CreateActionPresentoir] CreateBeanActionForNewQteRetourBonEtat:[[NSNumber alloc] initWithInt:[p_Qte intValue]] andIdPresentoir:p_idPresentoir andIdParution:p_idParution];
            v_CR.idLieu = v_LieuPassage.idLieu;
            [v_LieuPassage addListActionObject:v_CR];
        }
        else
        {
            v_CR.quantiteRecuperee = [[NSNumber alloc] initWithInt:[p_Qte intValue]];
            PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
            v_CR.coordX = v_Pt.Long;
            v_CR.coordY = v_Pt.Lat;
            v_CR.coordGPSFiable= v_Pt.CoordFiable;
            [v_CR setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddOrUpdateQteRetourBonEtatByIdLieu" andExparams:[NSString stringWithFormat:@"p_IdLieu:%@, p_idPresentoir:%@, p_idParution:%@,p_Qte:%@",p_IdLieu,p_idPresentoir,p_idParution,p_Qte]];
    }
}


-(void) AddOrUpdateQteRetourParutionPrecByIdLieu:(NSNumber*)p_IdLieu andIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution andQte:(NSNumber*)p_Qte
{
    @try
    {
        BeanAction* v_CR = nil;
        
        BeanParution* v_BeanParutionOLD = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:p_idParution];
        BeanParution* v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionCouranteByIdEdition:v_BeanParutionOLD.idEdition];
        
        //BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageById:p_IdLieuPassage];
        BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
        for (BeanAction* v_RowAct in v_LieuPassage.listAction){
            if([v_RowAct.idPresentoir isEqualToNumber:p_idPresentoir]
               && [v_RowAct.idParution isEqualToNumber:v_BeanParution.idParutionPrec]
               && [v_RowAct.codeAction isEqualToString:PEG_EnuActionMobilite_Retour])
            {
                v_CR = v_RowAct;
                break;
            }
        }
        if(v_CR == nil)
        {
            BeanAction* v_CR = [[PEG_FMobilitePegase CreateActionPresentoir] CreateBeanActionForNewQteRetour:[[NSNumber alloc] initWithInt:[p_Qte intValue]] andIdPresentoir:p_idPresentoir andIdParution:v_BeanParution.idParutionPrec];
            v_CR.idLieu = v_LieuPassage.idLieu;
            [v_LieuPassage addListActionObject:v_CR];
        }
        else
        {
            v_CR.quantiteRecuperee = [[NSNumber alloc] initWithInt:[p_Qte intValue]];
            PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
            v_CR.coordX = v_Pt.Long;
            v_CR.coordY = v_Pt.Lat;
            v_CR.coordGPSFiable= v_Pt.CoordFiable;
            [v_CR setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddOrUpdateQteRetourParutionPrecByIdLieuPassage" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_idParution:%@,p_Qte:%@",p_idPresentoir,p_idParution,p_Qte]];
    }
}

-(NSArray*) GetListeBeanLieuByDistance:(NSNumber *)p_DistanceMetre AndPoint:(PEG_BeanPoint*)p_Point
{
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        PEG_BeanPoint* v_PointDep = [[PEG_BeanPoint alloc] init];
        
        NSArray* v_ArrayBean = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuActifAvecCoordGPS];
        
        if(v_ArrayBean != nil)
        {
            for (BeanLieu* v_Item in v_ArrayBean)
            {
                [v_PointDep initWithLong:v_Item.coordXpda AndLat:v_Item.coordYpda];
                if([[self GetDistanceMetreEntreDeuxPoint1:p_Point AndPoint2:v_PointDep] doubleValue] <= [p_DistanceMetre doubleValue] )
                {
                    [v_retour addObject:v_Item];
                }
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListeBeanLieuByDistance" andExparams:[NSString stringWithFormat:@"p_DistanceMetre:%@ p_Point:%@",p_DistanceMetre,p_Point]];
    }
    return v_retour;
}

-(NSMutableArray*) GetListeBeanLieuWithTache
{
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        /*PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        //[req setPredicate:[NSPredicate predicateWithFormat:@"idLieu == %@",p_idLieu]];
        
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:nil];*/
        
        NSArray* v_ArrayBean = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuActif];
        
        if(v_ArrayBean != nil)
        {
            for (BeanLieu* v_Lieu in v_ArrayBean)
            {
                if([[PEG_FMobilitePegase CreateLieu]GetNbAllTacheForLieu:v_Lieu] > 0)
                {
                    [v_retour addObject:v_Lieu];
                }
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListeBeanLieuWithTache" andExparams:nil];
    }
    return v_retour;
}

-(BOOL) IsTacheAFaireIsOnLieu:(NSString*)p_CodeMateriel andIdLieu:(NSNumber*)p_idLieu{
    
    BOOL v_retour=false;
    
    @try
    {
        BeanLieu* v_beanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_idLieu];
        for (BeanTache* v_ItemTache in v_beanLieu.listTache)
        {
            if([v_ItemTache.code isEqualToString:p_CodeMateriel]
               && ![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                v_retour = true;
                break;
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsTacheAFaireIsOnLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    
    return v_retour;
}

-(BOOL) IsTacheAFaireMaterielOnLieu:(NSNumber*)p_idLieu{
    
    BOOL v_retour=false;
    
    @try
    {
        BeanLieu* v_beanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_idLieu];
        for(BeanPresentoir* v_BeanPres in v_beanLieu.listPresentoir)
        {
            for (BeanTache* v_ItemTache in v_BeanPres.listTache)
            {
                if(![v_ItemTache.code isEqualToString:PEG_EnumActionTache_PHOTO]
                   && ![v_ItemTache.code isEqualToString:PEG_EnumActionTache_AppporterPresentoir]
                   && ![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                {
                    v_retour = true;
                    break;
                }
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsTacheAFaireMaterielOnLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    
    return v_retour;
}
-(BOOL) IsTacheAFairePhotoOnLieu:(NSNumber*)p_idLieu{
    
    BOOL v_retour=false;
    
    @try
    {
        BeanLieu* v_beanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_idLieu];
        for (BeanTache* v_ItemTache in v_beanLieu.listTache)
        {
            if([v_ItemTache.code isEqualToString:PEG_EnumActionTache_PHOTO]
               && ![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                v_retour = true;
                break;
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsTacheAFairePhotoOnLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    
    return v_retour;
}
-(BOOL) IsTacheAFaireApporterPresentoirOnLieu:(NSNumber*)p_idLieu{
    
    BOOL v_retour=false;
    
    @try
    {
        BeanLieu* v_beanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_idLieu];
        for (BeanTache* v_ItemTache in v_beanLieu.listTache)
        {
            if([v_ItemTache.code isEqualToString:PEG_EnumActionTache_AppporterPresentoir]
               && ![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                v_retour = true;
                break;
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsTacheAFaireApporterPresentoirOnLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@",p_idLieu]];
    }
    
    return v_retour;
}

-(int) GetNbAllTacheForLieu:(BeanLieu*)p_Lieu
{
    int v_retour = 0;
    @try
    {
        for (BeanPresentoir* v_ItemPresentoir in p_Lieu.listPresentoir)
        {
            if(v_ItemPresentoir.listTache!=nil && v_ItemPresentoir.listTache.count>0){
                for (BeanTache* v_ItemTache in v_ItemPresentoir.listTache)
                {
                    if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                    {
                        v_retour++;
                    }
                }
            }
        }
        for (BeanTache* v_ItemTache in p_Lieu.listTache)
        {
            if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                v_retour++;
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetNbAllTacheForLieu" andExparams:nil];
    }
    return v_retour;
}


-(int) GetNbTacheForAllLieu
{
    int v_retour = 0;
    @try
    {
        /*//On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        //[req setPredicate:[NSPredicate predicateWithFormat:@"idLieu == %@",p_idLieu]];
        
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:nil];*/
        
         NSArray* v_ArrayBean = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuActif];
        
        if(v_ArrayBean != nil)
        {
            for (BeanLieu* v_Lieu in v_ArrayBean)
            {
                for (BeanPresentoir* v_ItemPresentoir in v_Lieu.listPresentoir)
                {
                    if(v_ItemPresentoir.listTache!=nil && v_ItemPresentoir.listTache.count>0){
                        for (BeanTache* v_ItemTache in v_ItemPresentoir.listTache)
                        {
                            if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                            {
                            v_retour++;
                            }
                        }
                    }
                }
                for (BeanTache* v_ItemTache in v_Lieu.listTache)
                {
                    if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                    {
                    v_retour++;
                    }
                }
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetNbPhotoForAllLieu" andExparams:nil];
    }
    return v_retour;
}
-(int) GetNbTachePhotoForAllLieu
{
    int v_retour = 0;
    @try
    {
        /*//On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        //[req setPredicate:[NSPredicate predicateWithFormat:@"idLieu == %@",p_idLieu]];
        
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:nil];*/
        
        NSArray* v_ArrayBean = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuActif];
        
        if(v_ArrayBean != nil)
        {
            for (BeanLieu* v_Lieu in v_ArrayBean)
            {
                for (BeanPresentoir* v_ItemPresentoir in v_Lieu.listPresentoir)
                {
                    if(v_ItemPresentoir.listTache!=nil && v_ItemPresentoir.listTache.count>0){
                        for (BeanTache* v_ItemTache in v_ItemPresentoir.listTache)
                        {
                            if([v_ItemTache.code isEqualToString:PEG_EnumActionTache_PHOTO])
                            {
                                if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                                {
                                v_retour++;
                                }
                            }
                        }
                    }
                }
                if(v_Lieu.listTache!=nil && v_Lieu.listTache.count>0){
                    for (BeanTache* v_ItemTache in v_Lieu.listTache)
                    {
                        if([v_ItemTache.code isEqualToString:PEG_EnumActionTache_PHOTO])
                        {
                            if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                            {
                            v_retour++;
                            }
                        }
                    }
                }
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetNbTachePhotoForAllLieu" andExparams:nil];
    }
    return v_retour;
}
-(int) GetNbTacheMaterielForAllLieu
{
    int v_retour = 0;
    @try
    {
        
        /*//On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext]];
        //[req setPredicate:[NSPredicate predicateWithFormat:@"idLieu == %@",p_idLieu]];
        
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:nil];*/
        
        NSArray* v_ArrayBean = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuActif];
        
        if(v_ArrayBean != nil)
        {
            for (BeanLieu* v_Lieu in v_ArrayBean)
            {
                for (BeanPresentoir* v_ItemPresentoir in v_Lieu.listPresentoir)
                {
                    if(v_ItemPresentoir.listTache!=nil && v_ItemPresentoir.listTache.count>0){
                        for (BeanTache* v_ItemTache in v_ItemPresentoir.listTache)
                        {
                            if(![v_ItemTache.code isEqualToString:PEG_EnumActionTache_PHOTO])
                            {
                                if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                                {
                                v_retour++;
                                }
                            }
                        }
                    }
                }
                if(v_Lieu.listTache!=nil && v_Lieu.listTache.count>0){
                    for (BeanTache* v_ItemTache in v_Lieu.listTache)
                    {
                        if(![v_ItemTache.code isEqualToString:PEG_EnumActionTache_PHOTO])
                        {
                            if(![v_ItemTache.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
                            {
                            v_retour++;
                            }
                        }
                    }
                }
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetNbTachePhotoForAllLieu" andExparams:nil];
    }
    return v_retour;
}



-(NSNumber*) GetDistanceMetreEntreDeuxPoint1:(PEG_BeanPoint*)p_Point1 AndPoint2:(PEG_BeanPoint*)p_Point2
{
    NSNumber* v_retour = nil;
    @try
    {
        CLLocationCoordinate2D v_Point1;
        v_Point1.latitude = [p_Point1.Lat doubleValue];
        v_Point1.longitude = [p_Point1.Long doubleValue];
        
        
        CLLocationCoordinate2D v_Point2;
        v_Point2.latitude = [p_Point2.Lat doubleValue];
        v_Point2.longitude = [p_Point2.Long doubleValue];
        
        double v_distance = round([self metresBetweenPlace1:v_Point1 andPlace2:v_Point2]);
        v_retour = [[NSNumber alloc] initWithDouble:v_distance];
        
        /*double v_distance = sqrt(pow(([p_Point2.CoordX doubleValue] - [p_Point1.CoordX doubleValue]),2) + pow(([p_Point2.CoordY doubleValue] - [p_Point1.CoordY doubleValue]),2));
         v_retour = [[NSNumber alloc] initWithDouble:v_distance];*/
        //DLog(@"p_Point1:%@ p_Point2:%@ Distance:%f",p_Point1,p_Point2,v_distance);
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetDistanceMetreEntreDeuxPoint1" andExparams:[NSString stringWithFormat:@"p_Point1:%@ p_Point2:%@",p_Point1,p_Point2]];
    }
    return v_retour;
}

-(double)metresBetweenPlace1:(CLLocationCoordinate2D) place1 andPlace2:(CLLocationCoordinate2D) place2 {
    
    MKMapPoint  start, finish;
    
    start = MKMapPointForCoordinate(place1);
    finish = MKMapPointForCoordinate(place2);
    
    return MKMetersBetweenMapPoints(start, finish);
}

-(NSString*) GetAdresseComplete:(BeanLieu*)p_Lieu
{
    NSString* v_Adresse = @"";
    if(p_Lieu.noVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.noVoie];
    if(p_Lieu.noVoieComplement != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.noVoieComplement];
    if(p_Lieu.prefixDirectionVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.prefixDirectionVoie];
    if(p_Lieu.typeVoie != nil && ![p_Lieu.typeVoie isEqualToString:@""])
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,[[PEG_FMobilitePegase CreateListeChoix] GetLibelleTypeVoieByCode:p_Lieu.typeVoie]];
    if(p_Lieu.liaisonVoie != nil && ![p_Lieu.liaisonVoie isEqualToString:@""])
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,[[PEG_FMobilitePegase CreateListeChoix] GetLibelleLiaisonByCode:p_Lieu.liaisonVoie]];
    if(p_Lieu.nomVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.nomVoie];
    if(p_Lieu.suffixDirectionVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.suffixDirectionVoie];
    if(p_Lieu.codePostal != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.codePostal];
    if(p_Lieu.codePostalComplement != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.codePostalComplement];
    if(p_Lieu.ville != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,p_Lieu.ville];
    return v_Adresse;
}

-(NSString*) GetLibelleJour:(int)p_NumJour
{
    NSString* v_Jour = @"";
    
    switch (p_NumJour) {
        case 1:
            v_Jour =@"Lundi";
            break;
        case 2:
            v_Jour =@"Mardi";
            break;
        case 3:
            v_Jour =@"Mercredi";
            break;
        case 4:
            v_Jour =@"Jeudi";
            break;
        case 5:
            v_Jour =@"Vendredi";
            break;
        case 6:
            v_Jour =@"Samedi";
            break;
        case 7:
            v_Jour =@"Dimanche";
            break;
        default:
            v_Jour =@"Inconnu";
            break;
    }
    return v_Jour;
}

-(NSMutableArray*) GetHorairesComplet:(BeanLieu*)p_BeanLieu
{
    NSMutableArray* v_ListHoraire= [[NSMutableArray alloc] init];
    //    NSString* v_Horaire = @"";
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H:mm"];
    NSString* v_AM = @"";
    NSString* v_PM = @"";
    
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"jour" ascending:YES]];
    NSArray *array = [p_BeanLieu.listHoraire sortedArrayUsingDescriptors:sortDescriptors];
    for (int v_indexJour = 1; v_indexJour <= 7; v_indexJour++) {
        NSString* v_Horaire = @"";
        for (BeanHoraire* v_ItemHoraire in array)
        {
            if(![v_ItemHoraire.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                if([v_ItemHoraire.jour intValue] == v_indexJour)
                {
                    v_Horaire = [NSString stringWithFormat:@"%@%@ : ",
                                 v_Horaire,
                                 [self GetLibelleJour:[v_ItemHoraire.jour intValue]]];
                    
                    v_AM = @"";
                    if(v_ItemHoraire.aMDebut != nil && v_ItemHoraire.aMFin != nil)
                    {
                        v_AM = [NSString stringWithFormat:@"%@-%@",
                                [formatter stringFromDate:v_ItemHoraire.aMDebut], [formatter stringFromDate:v_ItemHoraire.aMFin]];
                    }
                    v_PM = @"";
                    if(v_ItemHoraire.pMDebut != nil && v_ItemHoraire.pMFin != nil)
                    {
                        v_PM = [NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:v_ItemHoraire.pMDebut], [formatter stringFromDate:v_ItemHoraire.pMFin]];
                    }
                    
                    if(v_AM.length > 1 && v_PM.length > 1)
                    {
                        v_Horaire = [NSString stringWithFormat:@"%@%@ / %@\n",
                                     v_Horaire,
                                     v_AM,v_PM];
                    }
                    else if (v_AM.length > 1)
                    {
                        v_Horaire = [NSString stringWithFormat:@"%@%@\n",
                                     v_Horaire,
                                     v_AM];
                    }
                    else if(v_PM.length > 1)
                    {
                        v_Horaire = [NSString stringWithFormat:@"%@%@\n",
                                     v_Horaire,
                                     v_PM];
                    }
                    else{
                        v_Horaire = [NSString stringWithFormat:@"%@Fermé\n",
                                     v_Horaire];
                    }
                }
            }
        }
        if([v_Horaire isEqualToString:@""])
        {
            v_Horaire = [NSString stringWithFormat:@"%@%@ : Fermé",
                         v_Horaire,
                         [self GetLibelleJour:v_indexJour]];
        }
        [v_ListHoraire addObject:v_Horaire];
    }
    
    return v_ListHoraire;
}


-(BeanHoraire*) GetBeanHoraireByIndex:(NSUInteger) v_Index andLieu:(BeanLieu*)p_BeanLieu
{
    BeanHoraire* v_beanHoraire=nil;
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"jour" ascending:YES]];
    NSMutableArray *arrayTmp = [[NSMutableArray alloc] init];
    
    for (BeanHoraire* v_BH in p_BeanLieu.listHoraire) {
        if(! [v_BH.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
        {
            [arrayTmp addObject:v_BH];
        }
    }
    
    NSArray *array = [arrayTmp sortedArrayUsingDescriptors:sortDescriptors];
    if (v_Index< [array count]){
        v_beanHoraire=[array objectAtIndex:v_Index];
    }else{
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        v_beanHoraire = [NSEntityDescription insertNewObjectForEntityForName:@"BeanHoraire" inManagedObjectContext:app.managedObjectContext];
        [v_beanHoraire setIdLieu:p_BeanLieu.idLieu];
        [v_beanHoraire setJour:[NSNumber numberWithInt:v_Index+1 ]];
        [p_BeanLieu addListHoraireObject:v_beanHoraire];
    }
    
    return v_beanHoraire;
}

-(void) AddOrReplaceHoraireFormSemaineCompleteForAMDebut:(NSDate*)p_AMDebut andAMFin:(NSDate*)p_AMFin andPMDebut:(NSDate*)p_PMDebut andPMFin:(NSDate*)p_PMFin andLieu:(BeanLieu*)p_BeanLieu
{
    NSArray *array = [NSArray arrayWithArray:[p_BeanLieu.listHoraire allObjects]];
    BOOL v_trouve=NO;
    for (int v_IndiceJour = 1; v_IndiceJour <=7; v_IndiceJour++) {
        v_trouve=NO;
        for (BeanHoraire* v_ItemHoraire in array)
        {
            if([v_ItemHoraire.jour intValue] == v_IndiceJour){
                [v_ItemHoraire setAMDebut:p_AMDebut];
                [v_ItemHoraire setAMFin:p_AMFin];
                [v_ItemHoraire setPMDebut:p_PMDebut];
                [v_ItemHoraire setPMFin:p_PMFin];
                [v_ItemHoraire setLivre24:nil];
                [v_ItemHoraire setFlagMAJ:PEG_EnumFlagMAJ_Modified];
                v_trouve=YES;
                break;
            }
            else if([v_ItemHoraire.jour intValue] == 0)
            {
                //On supprime le livraison 247
                [v_ItemHoraire setFlagMAJ:PEG_EnumFlagMAJ_Deleted];
            }
        }
        if(!v_trouve){
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            BeanHoraire* v_BeanHoraire = [NSEntityDescription insertNewObjectForEntityForName:@"BeanHoraire" inManagedObjectContext:app.managedObjectContext];
            [v_BeanHoraire setIdLieu:p_BeanLieu.idLieu];
            [v_BeanHoraire setJour:[[NSNumber alloc] initWithInt:v_IndiceJour]];
            [v_BeanHoraire setAMDebut:p_AMDebut];
            [v_BeanHoraire setAMFin:p_AMFin];
            [v_BeanHoraire setPMDebut:p_PMDebut];
            [v_BeanHoraire setPMFin:p_PMFin];
            [v_BeanHoraire setLivre24:nil];
            [v_BeanHoraire setFlagMAJ:PEG_EnumFlagMAJ_Added];
            [p_BeanLieu addListHoraireObject:v_BeanHoraire];
        }
    }
    //La modif horaire est prise en compte dans la modif du lieu
    [p_BeanLieu setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    
    [[PEG_FMobilitePegase CreateCoreData] Save];
}
-(void) AddOrReplaceHoraireForJour:(NSNumber*)p_Jour andAMDebut:(NSDate*)p_AMDebut andAMFin:(NSDate*)p_AMFin andPMDebut:(NSDate*)p_PMDebut andPMFin:(NSDate*)p_PMFin  andLieu:(BeanLieu*)p_BeanLieu
{
    NSArray *array = [NSArray arrayWithArray:[p_BeanLieu.listHoraire allObjects]];
    BOOL v_trouve=NO;
    for (BeanHoraire* v_ItemHoraire in array)
    {
        if([v_ItemHoraire.jour isEqualToNumber:p_Jour]){
            [v_ItemHoraire setAMDebut:p_AMDebut];
            [v_ItemHoraire setAMFin:p_AMFin];
            [v_ItemHoraire setPMDebut:p_PMDebut];
            [v_ItemHoraire setPMFin:p_PMFin];
            [v_ItemHoraire setLivre24:nil];
            [v_ItemHoraire setFlagMAJ:PEG_EnumFlagMAJ_Modified];
            v_trouve=YES;
            break;
        }
    }
    if(!v_trouve){
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        BeanHoraire* v_BeanHoraire = [NSEntityDescription insertNewObjectForEntityForName:@"BeanHoraire" inManagedObjectContext:app.managedObjectContext];
        [v_BeanHoraire setIdLieu:p_BeanLieu.idLieu];
        [v_BeanHoraire setJour:p_Jour];
        [v_BeanHoraire setAMDebut:p_AMDebut];
        [v_BeanHoraire setAMFin:p_AMFin];
        [v_BeanHoraire setPMDebut:p_PMDebut];
        [v_BeanHoraire setPMFin:p_PMFin];
        [v_BeanHoraire setLivre24:nil];
        [v_BeanHoraire setFlagMAJ:PEG_EnumFlagMAJ_Added];
        [p_BeanLieu addListHoraireObject:v_BeanHoraire];
    }
    
    //La modif horaire est prise en compte dans la modif du lieu
    [p_BeanLieu setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    [[PEG_FMobilitePegase CreateCoreData] Save];
}
-(BOOL) IsLivrable247:(BeanLieu*)p_Lieu
{
    /*BOOL v_isLivrable = false;
    for (BeanHoraire* v_ItemHoraire in p_Lieu.listHoraire)
    {
        if(v_ItemHoraire.flagMAJ != PEG_EnumFlagMAJ_Deleted
           && [v_ItemHoraire.jour intValue] == 0
           && [v_ItemHoraire.livre24 boolValue])
        {
            v_isLivrable = true;
        }
    }
    return v_isLivrable;*/
    return [p_Lieu.ouvert247 boolValue];
}

-(void) UpdateLivrable247:(BeanLieu*)p_BeanLieu andLivrable247:(BOOL)p_VFLivrable247
{
    
    p_BeanLieu.ouvert247 = [[NSNumber alloc] initWithInt:p_VFLivrable247];
    [p_BeanLieu setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    for (BeanHoraire* v_ItemHoraire in p_BeanLieu.listHoraire)
    {
        if(p_VFLivrable247)
        {
            [v_ItemHoraire setFlagMAJ: PEG_EnumFlagMAJ_Deleted];
        }
        else
        {
            [v_ItemHoraire setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        }
    }
    [[PEG_FMobilitePegase CreateCoreData] Save];
    
    [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanLieu.idLieu];
}

-(void)UpdateLieuExclusifByLieu:(BeanLieu*)p_BeanLieu andExclusif:(BOOL)p_Exclusif
{
    @try{
        p_BeanLieu.vfExclusif = [[NSNumber alloc] initWithBool:p_Exclusif];
        p_BeanLieu.flagMAJ = [PEG_EnumFlagMAJ UpdateFlagMAJ:p_BeanLieu.flagMAJ];
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanLieu.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.UpdatePresentoirEmplacementByPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(void)UpdateLieuClientMagByLieu:(BeanLieu*)p_BeanLieu andClientMag:(BOOL)p_ClientMag
{
    @try{
        p_BeanLieu.vfClientMag = [[NSNumber alloc] initWithBool:p_ClientMag];
        p_BeanLieu.flagMAJ = [PEG_EnumFlagMAJ UpdateFlagMAJ:p_BeanLieu.flagMAJ];
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanLieu.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.UpdatePresentoirEmplacementByPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(BeanLieu*) CreateBeanLieu
{
    BeanLieu* v_retour = nil;
    @try
    {
        BeanMobilitePegase* v_BMP = [[PEG_FMobilitePegase CreateMobilitePegaseService] GetBeanMobilitePegaseByMatricule:[[PEGSession sharedPEGSession] matResp]] ;
        if(v_BMP != nil ){
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            v_retour = (BeanLieu *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanLieu" inManagedObjectContext:app.managedObjectContext];
            [v_retour setCodePays:@"FR"];
            [v_retour setCodeEtatLieu:@"ACT"]; //Actif
            [v_retour setDateCreation:[NSDate date]];
            [v_retour setGUIDLieu:[PEG_FTechnical genererGUID]];
            [v_retour setFlagMAJ:PEG_EnumFlagMAJ_Added];
            [v_BMP addListLieuObject:v_retour];
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            //On enregistre pour generé l'ID
            [v_retour setIdLieu:[[NSNumber alloc]initWithInteger:[v_retour autoId]]];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans CreateBeanLieu" andExparams:nil];
    }
    return v_retour;
}

-(void) AnnuleCreateBeanLieu:(NSNumber*)p_IdLieu
{
    @try
    {
        BeanLieu* v_BLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
        if([v_BLieu.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Added])
        {
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            
            BeanTournee* v_BTournee = [[PEG_FMobilitePegase CreateTournee]GetTourneeMerchDuJour];
            BeanLieuPassage* v_BeanLieuPassage = [[PEG_FMobilitePegase CreateLieu]GetBeanLieuPassageByIdLieu:p_IdLieu andIdTournee:v_BTournee.idTournee];
            
            if(v_BeanLieuPassage != nil)
            {
                //On supprime le lieu, lieu de passage et action associées
                for (BeanAction* v_BA in v_BeanLieuPassage.listAction)
                {
                    [app.managedObjectContext deleteObject:v_BA];
                }
                [app.managedObjectContext deleteObject:v_BeanLieuPassage];
            }
            
            [app.managedObjectContext deleteObject:v_BLieu];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AnnuleCreateBeanLieu" andExparams:nil];
    }
}

-(int) GetNbPresentoir:(BeanLieu*)p_BeanLieu{
    int v_nbPresentoir=0;
    @try
    {
        for (BeanPresentoir* v_ItemPresentoir in p_BeanLieu.listPresentoir)
        {
            if(![v_ItemPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted]){
                v_nbPresentoir++;
                
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetNbPresentoir" andExparams:nil];
    }
    return v_nbPresentoir;
}

-(NSMutableArray*) GetListPresentoirParutionTourneeMerchByLieu:(BeanLieu*)p_Lieu
{
    NSMutableArray* v_Retour = [[NSMutableArray alloc] init];
    @try
    {
        BOOL v_VFAjouterSansParution = true;
        for (BeanPresentoir* v_BP in p_Lieu.listPresentoir) {
            v_VFAjouterSansParution = true;
            //  BeanLieuPassage* v_BLP = [self GetBeanLieuPassageOnTourneeMerchByIdLieu:p_Lieu.idLieu];
            
            if(![v_BP.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                
                //On n'insert que si la ligne n'existe pas
                PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                //On met les parution préparé
                NSFetchRequest *req = [[NSFetchRequest alloc]init];
                
                
                //On ajoute les parutions selon la règle métier
                req = [[NSFetchRequest alloc]init];
                [req setEntity:[NSEntityDescription entityForName:@"BeanPresentoirParution" inManagedObjectContext:app.managedObjectContext]];
                [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@",v_BP.idPointDistribution]];
                
                //On trie par parution pour eviter, qu'en fonction des saisie l'ordre change
                NSSortDescriptor *sortDescription = [[NSSortDescriptor alloc] initWithKey:@"idParution" ascending:YES];
                [req setSortDescriptors: [NSArray arrayWithObject:sortDescription ]];
                
                //BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
                NSArray* v_arrayPresPar = [app.managedObjectContext executeFetchRequest:req error:nil];
                
                if(v_arrayPresPar.count > 0)
                {
                    for (BeanPresentoirParution* v_BPresPar in v_arrayPresPar) {
                        BeanParution* v_parution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_BPresPar.idParution];
                        BeanParution* v_ParutionCourante = [[PEG_FMobilitePegase CreateParution] GetBeanParutionCouranteByIdEdition:v_parution.idEdition];
                        if(v_ParutionCourante != nil)
                        {
                            PEG_BeanPresentoirParution* v_BPP = [[PEG_BeanPresentoirParution alloc] init];
                            v_BPP.IsFirstPres = true;
                            v_BPP.Presentoir = v_BP;
                            v_BPP.Parution = v_ParutionCourante; //[[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_BPresPar.idParution];
                            NSPredicate *valuePredicate=[NSPredicate predicateWithFormat:@"self.Parution.id == %d && self.Presentoir.idPointDistribution == %d",[v_BPresPar.idParution intValue],[v_BP.idPointDistribution intValue]];
                            
                            if ([[v_Retour filteredArrayUsingPredicate:valuePredicate] count]==0)
                            {
                                //Si c'est la premiere instance du presentoir on flag
                                if(v_VFAjouterSansParution) v_BPP.IsFirstPres = true;
                                else v_BPP.IsFirstPres = false;
                                [v_Retour addObject:v_BPP];
                                v_VFAjouterSansParution = false;
                            }
                        }
                    }
                }
                
                //On complete avec les actions saisie
                [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
                [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and (codeAction == %@ OR codeAction == %@)",v_BP.idPointDistribution,PEG_EnuActionMobilite_Previ,PEG_EnuActionMobilite_Distri]];
                
                //On trie par parution pour eviter, qu'en fonction des saisie l'ordre change
                sortDescription = [[NSSortDescriptor alloc] initWithKey:@"idParutionRef" ascending:YES];
                [req setSortDescriptors: [NSArray arrayWithObject:sortDescription ]];
                
                //BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
                NSArray* v_arrayAction = [app.managedObjectContext executeFetchRequest:req error:nil];
                
                if(v_arrayAction.count > 0)
                {
                    for (BeanAction* v_BAction in v_arrayAction) {
                        if([v_BP.idPointDistribution intValue] == [v_BAction.idPresentoir intValue])
                        {
                            if([v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Distri]
                               || [v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Previ])
                            {
                                PEG_BeanPresentoirParution* v_BPP = [[PEG_BeanPresentoirParution alloc] init];
                                v_BPP.IsFirstPres = true;
                                v_BPP.Presentoir = v_BP;
                                v_BPP.Parution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_BAction.idParution];
                                NSPredicate *valuePredicate=[NSPredicate predicateWithFormat:@"self.Parution.id == %d && self.Presentoir.idPointDistribution == %d",[v_BAction.idParution intValue],[v_BP.idPointDistribution intValue]];
                                
                                if ([[v_Retour filteredArrayUsingPredicate:valuePredicate] count]==0)
                                {
                                    //Si c'est la premiere instance du presentoir on flag
                                    if(v_VFAjouterSansParution) v_BPP.IsFirstPres = true;
                                    else v_BPP.IsFirstPres = false;
                                    [v_Retour addObject:v_BPP];
                                    v_VFAjouterSansParution = false;
                                }
                            }
                        }
                    }
                }
            
                
            }
            if(v_VFAjouterSansParution)
            {
                PEG_BeanPresentoirParution* v_BPP = [[PEG_BeanPresentoirParution alloc] init];
                v_BPP.IsFirstPres = true;
                v_BPP.Presentoir = v_BP;
                v_BPP.Parution = nil;
                [v_Retour addObject:v_BPP];
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListPresentoirParutionTourneeMerchByLieu" andExparams:nil];
    }
    return v_Retour;
}

-(NSMutableArray*) GetListPresentoirParutionByLieu:(BeanLieu*)p_Lieu andIdTournee:(NSNumber*)p_IdTournee
{
    NSMutableArray* v_Retour = [[NSMutableArray alloc] init];
    @try
    {
        BOOL v_VFAjouterSansParution = true;
        for (BeanPresentoir* v_BP in p_Lieu.listPresentoir) {
            v_VFAjouterSansParution = true;
            BeanLieuPassage* v_BLP = [self GetBeanLieuPassageByIdLieu:p_Lieu.idLieu andIdTournee:p_IdTournee];
            
            NSArray* v_Actions = [[PEG_FMobilitePegase CreateActionPresentoir] GetListBeanActionByIdLieuPassage:v_BLP.idLieuPassage];
            
            if(v_Actions.count > 0)
            {
                for (BeanAction* v_BAction in v_Actions) {
                    if([v_BP.idPointDistribution intValue] == [v_BAction.idPresentoir intValue])
                    {
                        if([v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Distri]
                           || [v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Retour]
                           || [v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Previ])
                        {
                            PEG_BeanPresentoirParution* v_BPP = [[PEG_BeanPresentoirParution alloc] init];
                            v_BPP.Presentoir = v_BP;
                            if([v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Retour])
                            {
                                //Dans le cas d'un retour on stock la parution suivante car dans les écran on cherchera pour la parution prec
                                //d'autre part cela permet de regrouper avec la distri sur le même couple presentoir/parution
                                v_BPP.Parution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionSuivanteById:v_BAction.idParution];
                            }
                            else
                            {
                                v_BPP.Parution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_BAction.idParution];
                            }
                            
                            NSPredicate *valuePredicate=nil;
                            valuePredicate=[NSPredicate predicateWithFormat:@"self.Parution.id == %d && self.Presentoir.idPointDistribution == %d",[v_BPP.Parution.id intValue],[v_BP.idPointDistribution intValue]];
                            
                            if ([[v_Retour filteredArrayUsingPredicate:valuePredicate] count]==0)
                            {
                                [v_Retour addObject:v_BPP];
                                v_VFAjouterSansParution = false;
                            }
                        }
                    }
                }
            }
            if(v_VFAjouterSansParution)
            {
                PEG_BeanPresentoirParution* v_BPP = [[PEG_BeanPresentoirParution alloc] init];
                v_BPP.Presentoir = v_BP;
                v_BPP.Parution = nil;
                [v_Retour addObject:v_BPP];
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListPresentoirParutionByLieu" andExparams:nil];
    }
    return v_Retour;
}

-(void) SetLieuInactif:(NSNumber*)p_idLieu
{
    @try
    {
        BeanLieu* v_BLieu = [self GetBeanLieuById:p_idLieu];
        [v_BLieu setCodeProchainEtatLieu:@"ANN" ];
        [v_BLieu setDateProchainEtatLieu:[NSDate date]];
        [v_BLieu setCodeEtatLieu:@"ANN" ];
        
        [v_BLieu setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans SetLieuInactif" andExparams:nil];
    }
}

-(BOOL)IsLieuEnAlerte:(BeanLieu*)p_BeanLieu
{
    BOOL v_retour = NO;
    @try
    {
        if(([PEG_FTechnical GetNbJourEntreDeuxDatesWithDate1:p_BeanLieu.dateDerniereVisite AndDate2:[NSDate date]] > 60))
        {
            v_retour = YES;
        }
        else{
            for (BeanPresentoir* v_BeanPres in p_BeanLieu.listPresentoir) {
                if([[PEG_FMobilitePegase CreatePresentoir] IsAlertePhotoOnPresentoir:v_BeanPres])
                {
                    v_retour = YES;
                }
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsLieuEnAlerte" andExparams:nil];
    }
    return v_retour;
}

-(void)SetDateDerniereVisiteByIdLieu:(NSNumber*)p_IdLieu
{
    @try
    {
        BeanLieu* v_Lieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
        [v_Lieu setDateDerniereVisite:[NSDate date]];
        [[PEG_FMobilitePegase CreateCoreData] Save];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans SetDateDerniereVisiteByIdLieu" andExparams:nil];
    }
}

-(void)AddOrUpdateApporterPresentoirByIdLieu:(NSNumber*)p_IdLieu andFait:(BOOL)p_Fait
{
    @try{
        BeanLieu* v_Lieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Lieu.idLieu];
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdLieu intValue]== [v_BAP.idLieu intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_ApporterPresentoir])
            {
                v_Bean = v_BAP;
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        if(p_Fait)
        {
            if(v_Bean == nil)
            {
                v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
                [v_LP addListActionObject:v_Bean];
            }
            [v_Bean setIdLieu:v_LP.idLieu];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_ApporterPresentoir];
            [v_Bean setDateAction:[NSDate date]];
            [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
            
            PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
            [v_Bean setCoordX:v_Pt.Long];
            [v_Bean setCoordY:v_Pt.Lat];
            [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
            
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
        }
        else{
            if(v_Bean != nil)
            {
                [app.managedObjectContext deleteObject:v_Bean];
                
                [[PEG_FMobilitePegase CreateCoreData] Save];
            }
        }
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Lieu.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateApporterPresentoirByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(BOOL)IsApporterPresentoirByIdLieu:(NSNumber*)p_IdLieu
{
    BOOL v_Retour = false;
    @try{
        BeanLieu* v_Lieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:v_Lieu.idLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdLieu intValue]== [v_BAP.idLieu intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_ApporterPresentoir])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.IsPresentoirApporterByIdPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)UpdateTachePresentoirByLieu:(BeanLieu*)p_BeanLieu andTache:(NSString*)p_Tache andFait:(BOOL)p_Fait andAFaire:(BOOL)p_AFaire
{
    @try{
        
        BeanTache* v_Bean = nil;
        for (BeanTache* v_BT in p_BeanLieu.listTache) {
            if([v_BT.code isEqualToString:p_Tache])
            {
                v_Bean = v_BT;
                [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Modified];
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        if(!p_AFaire)
        {
            if(v_Bean != nil)
            {
                [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Deleted];
            }
            if([p_Tache isEqualToString:PEG_EnumActionTache_AppporterPresentoir])
            {
                [self AddOrUpdateApporterPresentoirByIdLieu:p_BeanLieu.idLieu andFait:p_Fait];
            }
            else if([p_Tache isEqualToString:PEG_EnumActionTache_PHOTO])
            {
            }
        }
        else if(p_AFaire)
        {
            if(v_Bean == nil)
            {
                v_Bean = (BeanTache *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanTache" inManagedObjectContext:app.managedObjectContext];
                [p_BeanLieu addListTacheObject:v_Bean];
                [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
            }
            
            [v_Bean setDate:[NSDate date]];
            [v_Bean setIdLieu:p_BeanLieu.idLieu];
            [v_Bean setCode:p_Tache];
            
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        //On enregistre pour generé l'ID
        if([v_Bean.idTache intValue] == 0)
        {
            [v_Bean setIdTache:[[NSNumber alloc]initWithInteger:[v_Bean autoId]]];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanLieu.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.UpdatePresentoirTacheByPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}

@end
