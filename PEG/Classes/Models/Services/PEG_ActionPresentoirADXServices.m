//
//  PEG_ActionPresentoirADXServices.m
//  PEG
//
//  Created by Pierre Marty on 28/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_ActionPresentoirADXServices.h"
#import "PEG_FMobilitePegase.h"
#import "BeanActionADX.h"
#import "BeanLieuPassageADX.h"
#import "PEG_EnuActionMobilite.h"
#import "PEGAppDelegate.h"
#import "PEG_BeanPresentoirParutionADX.h"
#import "PEG_EnumFlagMAJ.h"
#import "BeanTache.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"

@implementation PEG_ActionPresentoirADXServices


-(void)UpdatePresentoirTacheByPresentoir:(NSNumber*)p_idPresentoir andTache:(NSString*)p_Tache andAFaire:(BOOL)p_AFaire
{
    @try
    {
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_idPresentoir];
        if(v_Presentoir !=nil)
        {
            //[[PEG_FMobilitePegase CreateActionPresentoir] UpdatePresentoirTacheByPresentoir:v_Presentoir andTache:p_Tache andFait:NO andAFaire:p_AFaire];
            
            BeanTache* v_Bean = nil;
            for (BeanTache* v_BT in v_Presentoir.listTache) {
                if([v_BT.code isEqualToString:p_Tache])
                {
                    v_Bean = v_BT;
                    [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Modified];
                }
            }
            
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            if(p_AFaire)
            {
                if(v_Bean == nil)
                {
                    v_Bean = (BeanTache *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanTache" inManagedObjectContext:app.managedObjectContext];
                    [v_Presentoir addListTacheObject:v_Bean];
                    [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
                }
                
                [v_Bean setDate:[NSDate date]];
                [v_Bean setIdLieu:v_Presentoir.idLieu];
                [v_Bean setIdPresentoir:v_Presentoir.id];
                [v_Bean setCode:p_Tache];
                
            }
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            //On enregistre pour generé l'ID
            if([v_Bean.idTache intValue] == 0)
            {
                [v_Bean setIdTache:[[NSNumber alloc]initWithInteger:[v_Bean autoId]]];
                [[PEG_FMobilitePegase CreateCoreData] Save];
            }
            

        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans UpdatePresentoirTacheByPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_Tache:%@,p_AFaire:%d",p_idPresentoir,p_Tache,p_AFaire]];
    }
}

-(void)UpdateLieuTacheByLieu:(NSNumber*)p_idLieu andTache:(NSString*)p_Tache andAFaire:(BOOL)p_AFaire
{
    @try
    {
        BeanLieu* v_Lieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_idLieu];
        if(v_Lieu !=nil)
        {
            //[[PEG_FMobilitePegase CreateActionPresentoir] UpdatePresentoirTacheByPresentoir:v_Presentoir andTache:p_Tache andFait:NO andAFaire:p_AFaire];
            
            BeanTache* v_Bean = nil;
            for (BeanTache* v_BT in v_Lieu.listTache) {
                if([v_BT.code isEqualToString:p_Tache])
                {
                    v_Bean = v_BT;
                    [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Modified];
                }
            }
            
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            if(p_AFaire)
            {
                if(v_Bean == nil)
                {
                    v_Bean = (BeanTache *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanTache" inManagedObjectContext:app.managedObjectContext];
                    [v_Lieu addListTacheObject:v_Bean];
                    [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
                }
                
                [v_Bean setDate:[NSDate date]];
                [v_Bean setIdLieu:p_idLieu];
                [v_Bean setCode:p_Tache];
                
            }
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            //On enregistre pour generé l'ID
            if([v_Bean.idTache intValue] == 0)
            {
                [v_Bean setIdTache:[[NSNumber alloc]initWithInteger:[v_Bean autoId]]];
                [[PEG_FMobilitePegase CreateCoreData] Save];
            }
            
            
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans UpdateLieuTacheByLieu" andExparams:[NSString stringWithFormat:@"p_idLieu:%@, p_Tache:%@,p_AFaire:%d",p_idLieu,p_Tache,p_AFaire]];
    }
}

-(void) AddOrUpdateQteDistribueByIdLieuPassageADX:(NSNumber*)p_IdLieuPassageADX andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionRef:(NSNumber*)p_IdParutionRef andIdEditionRef:(NSNumber*)p_IdEditionRef andQte:(NSNumber*)p_Qte
{
    @try
    {
        BeanActionADX* v_CR = nil;
        
        BeanLieuPassageADX* v_LieuPassage = [[PEG_FMobilitePegase CreateTourneeADX] GetBeanLieuPassageADXById:p_IdLieuPassageADX];
        //BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        for (BeanActionADX* v_RowAct in v_LieuPassage.listActionADX){
            if([v_RowAct.idPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_RowAct.idParutionRef isEqualToNumber:p_IdParutionRef]
               && [v_RowAct.codeAction isEqualToString:PEG_EnuActionMobilite_Distri])
            {
                v_CR = v_RowAct;
                break;
            }
        }
        if(v_CR == nil)
        {
            v_CR = [[PEG_FMobilitePegase CreateActionPresentoirADX] CreateBeanActionADXForNewQteDistribuee:[[NSNumber alloc] initWithInt:[p_Qte intValue]] andIdPresentoir:p_IdPresentoir andIdParutionRef:p_IdParutionRef andIdEditionRef:p_IdEditionRef];
            v_CR.idLieu = v_LieuPassage.idLieu;
            [v_LieuPassage addListActionADXObject:v_CR];
        }
        else
        {
            v_CR.quantiteDistribuee = [[NSNumber alloc] initWithInt:[p_Qte intValue]];
            [v_CR setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddOrUpdateQteDistribueByIdLieuPassageADX" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_IdParutionRef:%@,p_Qte:%@",p_IdPresentoir,p_IdParutionRef,p_Qte]];
    }
}

-(void) AddOrUpdateQteRetourByIdLieuPassageADX:(NSNumber*)p_IdLieuPassageADX andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionPrecRef:(NSNumber*)p_IdParutionPrecRef andIdEditionRef:(NSNumber*)p_IdEditionRef andQte:(NSNumber*)p_Qte
{
    @try
    {
        BeanActionADX* v_CR = nil;
        
        BeanLieuPassageADX* v_LieuPassage = [[PEG_FMobilitePegase CreateTourneeADX] GetBeanLieuPassageADXById:p_IdLieuPassageADX];
        //BeanLieuPassage* v_LieuPassage = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
        for (BeanActionADX* v_RowAct in v_LieuPassage.listActionADX){
            if([v_RowAct.idPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_RowAct.idParutionRef isEqualToNumber:p_IdParutionPrecRef]
               && [v_RowAct.codeAction isEqualToString:PEG_EnuActionMobilite_Retour])
            {
                v_CR = v_RowAct;
                break;
            }
        }
        if(v_CR == nil)
        {
            //BeanAction* v_CR = [[PEG_FMobilitePegase CreateActionPresentoir] CreateBeanActionForNewQteRetour:[[NSNumber alloc] initWithInt:[p_Qte intValue]] andIdPresentoir:p_idPresentoir andIdParution:v_BeanParution.idParutionPrec];
            v_CR = [[PEG_FMobilitePegase CreateActionPresentoirADX] CreateBeanActionADXForNewQteRetour:[[NSNumber alloc] initWithInt:[p_Qte intValue]] andIdPresentoir:p_IdPresentoir andIdParutionRef:p_IdParutionPrecRef andIdEditionRef:p_IdEditionRef];
            v_CR.idLieu = v_LieuPassage.idLieu;
            [v_LieuPassage addListActionADXObject:v_CR];
        }
        else
        {
            v_CR.quantiteRecuperee = [[NSNumber alloc] initWithInt:[p_Qte intValue]];
            [v_CR setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddOrUpdateQteRetourByIdLieuPassageADX" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@, p_IdParutionPrecRef:%@,p_Qte:%@",p_IdPresentoir,p_IdParutionPrecRef,p_Qte]];
    }
}

-(BeanActionADX*) CreateBeanActionADXForNewQteDistribuee:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionRef:(NSNumber*)p_IdParutionRef andIdEditionRef:(NSNumber*)p_IdEditionRef
{
    BeanActionADX* v_Bean = nil;
    @try{
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        v_Bean = (BeanActionADX *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanActionADX" inManagedObjectContext:app.managedObjectContext];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        //[v_Bean setIdParution:p_IdParution];
        [v_Bean setIdParutionRef:p_IdParutionRef];
        [v_Bean setIdEditionRef:p_IdEditionRef];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Distri];
        [v_Bean setQuantiteDistribuee:p_Qte];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.CreateBeanActionADXForNewQteDistribuee %@",NSStringFromClass([self class]),self] andExparams:nil];
    }
    return v_Bean;
}

-(BeanActionADX*) CreateBeanActionADXForNewQteRetour:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionRef:(NSNumber*)p_IdParutionRef andIdEditionRef:(NSNumber*)p_IdEditionRef
{
    BeanActionADX* v_Bean = nil;
    @try{
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        v_Bean = (BeanActionADX *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanActionADX" inManagedObjectContext:app.managedObjectContext];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        //[v_Bean setIdParution:p_IdParution];
        [v_Bean setIdParutionRef:p_IdParutionRef];
        [v_Bean setIdEditionRef:p_IdEditionRef];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Retour];
        [v_Bean setQuantiteRecuperee:p_Qte];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.CreateBeanActionADXForNewQteRetour",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Bean;
}



@end
