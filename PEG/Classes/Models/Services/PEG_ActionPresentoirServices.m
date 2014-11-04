//
//  PEG_ActionPresentoirServices.m
//  PEG
//
//  Created by Horsmedia3 on 04/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ActionPresentoirServices.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEGAppDelegate.h"
#import "PEGException.h"
#import "PEG_BeanPoint.h"
#import "PEG_FTechnical.h"
#import "BeanConcurentLieu.h"
#import "PEG_FMobilitePegase.h"
#import "BeanLieuPassage.h"
#import "BeanTache.h"
#import "PEG_EnuActionMobilite.h"
#import "PEG_EnumActionTache.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"

@implementation PEG_ActionPresentoirServices

-(NSArray*) GetListBeanActionByIdLieuPassage:(NSNumber*)p_IdLieuPassage{
    NSArray* v_listeAction = [[NSArray alloc] init];
    @try{
        
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"parentLieuPassage.idLieuPassage == %@",p_IdLieuPassage]];
        
        //BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        v_listeAction = [app.managedObjectContext executeFetchRequest:req error:nil];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.GetBeanActionListCadeauByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_listeAction;
    
}

-(BeanAction*) CreateBeanActionForNewQteDistribuee:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution
{
    BeanAction* v_Bean = nil;
    @try{
        BeanParution* v_BParu = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:p_IdParution];
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        [v_Bean setIdParution:p_IdParution];
        if(v_BParu != nil)
        {
            [v_Bean setIdParutionRef:v_BParu.idParutionReferentiel];
            [v_Bean setIdEditionRef:v_BParu.idEdition];
        }
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Distri];
        [v_Bean setQuantiteDistribuee:p_Qte];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.initBeanForNewQteDistribuee %@",NSStringFromClass([self class]),self] andExparams:nil];
    }
    return v_Bean;
}
-(BeanAction*) CreateBeanActionForNewQteRetourBonEtat:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution
{
    BeanAction* v_Bean = nil;
    @try{
        BeanParution* v_BParu = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:p_IdParution];
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        [v_Bean setIdParution:p_IdParution];
        if(v_BParu != nil)
        {
            [v_Bean setIdParutionRef:v_BParu.idParutionReferentiel];
            [v_Bean setIdEditionRef:v_BParu.idEdition];
        }
        [v_Bean setCodeAction:PEG_EnuActionMobilite_RetourBonEtat];
        [v_Bean setQuantiteRecuperee:p_Qte];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.CreateBeanActionForNewQteRetour",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Bean;
}

-(BeanAction*) CreateBeanActionForNewQteRetour:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution
{
    BeanAction* v_Bean = nil;
    @try{
        BeanParution* v_BParu = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:p_IdParution];
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        [v_Bean setIdParution:p_IdParution];
        if(v_BParu != nil)
        {
            [v_Bean setIdParutionRef:v_BParu.idParutionReferentiel];
            [v_Bean setIdEditionRef:v_BParu.idEdition];
        }
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Retour];
        [v_Bean setQuantiteRecuperee:p_Qte];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.CreateBeanActionForNewQteRetour",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Bean;
}

-(void)AddOrUpdatePresentoirControleVisuelByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        

        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_ControleVisuel])
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
            [v_Bean setIdPresentoir:p_IdPresentoir];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_ControleVisuel];
            [v_Bean setValeurTexte:@"oui"];
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
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}


-(BOOL)IsPresentoirControleVisuelByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    BOOL v_Retour = false;
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_ControleVisuel])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)AddOrUpdatePresentoirPhoto:(NSNumber*)p_IdPresentoir andNomPhoto:(NSString*)p_NomPhoto andFait:(BOOL)p_Fait
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        //MAJ de la date de derniere photo
        v_Presentoir.dateDernierePhoto = [NSDate date];
        
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Photo])
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
            [v_Bean setIdPresentoir:v_Presentoir.idPointDistribution];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_Photo];
            [v_Bean setValeurTexte:p_NomPhoto];
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
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdatePresentoirPhoto",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(BOOL)IsPresentoirPhotoByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    BOOL v_Retour = false;
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Photo])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.IsPresentoirPhotoByIdPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)AddOrUpdatePresentoirNettoyeByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        

        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Nettoye])
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
            [v_Bean setIdPresentoir:p_IdPresentoir];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_Nettoye];
            [v_Bean setValeurTexte:@"oui"];
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
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(BOOL)IsPresentoirNettoyeByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    BOOL v_Retour = false;
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Nettoye])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)AddOrUpdatePresentoirReplaceByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        

        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Replace])
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
            [v_Bean setIdPresentoir:p_IdPresentoir];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_Replace];
            [v_Bean setValeurTexte:@"oui"];
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
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(BOOL)IsPresentoirReplaceByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    BOOL v_Retour = false;
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Replace])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)AddOrUpdatePresentoirDeplaceByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        

        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Deplace])
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
            [v_Bean setIdPresentoir:p_IdPresentoir];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_Deplace];
            [v_Bean setValeurTexte:@"oui"];
            [v_Bean setDateAction:[NSDate date]];
            [v_Bean setTypePresentoir:v_Presentoir.tYPE];
            [v_Bean setEmplacement:v_Presentoir.emplacement];
            [v_Bean setLocalisation:v_Presentoir.localisation];
            [v_Bean setIdPointDistribution:v_Presentoir.idPointDistribution];
            [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
            
            PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
            [v_Bean setCoordX:v_Pt.Long];
            [v_Bean setCoordY:v_Pt.Lat];
            [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
            
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            [[PEG_FMobilitePegase CreateLieu] UpdateTachePresentoirByLieu:v_Presentoir.parentLieu andTache:PEG_EnumActionTache_AppporterPresentoir andFait:YES andAFaire:NO];
        }
        else{
            if(v_Bean != nil)
            {
                [app.managedObjectContext deleteObject:v_Bean];
                
                [[PEG_FMobilitePegase CreateCoreData] Save];
            }
        }
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(BOOL)IsPresentoirDeplaceByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    BOOL v_Retour = false;
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue] && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Deplace])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)AddOrUpdatePresentoirRemplaceByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Remplace])
            {
                v_Bean = v_BAP;
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(v_Bean == nil)
        {
            v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
            [v_LP addListActionObject:v_Bean];
        }
        [v_Bean setIdLieu:v_LP.idLieu];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Remplace];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setTypePresentoir:v_Presentoir.tYPE];
        [v_Bean setEmplacement:v_Presentoir.emplacement];
        [v_Bean setLocalisation:v_Presentoir.localisation];
        [v_Bean setIdPointDistribution:v_Presentoir.idPointDistribution];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdatePresentoirRemplaceByIdPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(void)AddOrUpdatePresentoirVoleByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Vole])
            {
                v_Bean = v_BAP;
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(v_Bean == nil)
        {
            v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
            [v_LP addListActionObject:v_Bean];
        }
        [v_Bean setIdLieu:v_LP.idLieu];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Vole];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdatePresentoirVoleByIdPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(void)AddOrUpdatePresentoirCreationByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_CreationPresentoir])
            {
                v_Bean = v_BAP;
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        if(v_Bean == nil)
        {
            v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
            [v_LP addListActionObject:v_Bean];
        }
        [v_Bean setIdLieu:v_LP.idLieu];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_CreationPresentoir];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setTypePresentoir:v_Presentoir.tYPE];
        [v_Bean setEmplacement:v_Presentoir.emplacement];
        [v_Bean setLocalisation:v_Presentoir.localisation];
        [v_Bean setGuidPresentoir:v_Presentoir.guidpresentoir];
        [v_Bean setIdPointDistribution:v_Presentoir.idPointDistribution];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdatePresentoirCreationByIdPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(void)UpdatePresentoirCreationByIdPresentoir:(NSNumber*)p_IdPresentoir andEmplacement:(NSString*)p_Emplacement andLocalisation:(NSString*)p_Localisation
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_CreationPresentoir])
            {
                v_Bean = v_BAP;
            }
        }
        
        if(v_Bean != nil)
        {
            [v_Bean setEmplacement:p_Emplacement];
            [v_Bean setLocalisation:p_Localisation];
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.UpdatePresentoirCreationByIdPresentoirandEmplacementandLocalisation",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(void)AddOrUpdatePresentoirSupprimeByIdPresentoir:(NSNumber*)p_IdPresentoir
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Supprime])
            {
                v_Bean = v_BAP;
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(v_Bean == nil)
        {
            v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
            [v_LP addListActionObject:v_Bean];
        }
        [v_Bean setIdLieu:v_LP.idLieu];
        [v_Bean setIdPresentoir:p_IdPresentoir];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Supprime];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdatePresentoirSupprimeByIdPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}


-(void)AddOrUpdatePresentoirMaterielByIdPresentoir:(NSNumber*)p_IdPresentoir andCodeMateriel:(NSString*)p_CodeMateriel andFait:(BOOL)p_Fait
{
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
                
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Materiel]
               && [v_BAP.valeurTexte isEqualToString:p_CodeMateriel])
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
            [v_Bean setIdPresentoir:p_IdPresentoir];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_Materiel];
            [v_Bean setValeurTexte:p_CodeMateriel];
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
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:v_Presentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(BOOL)IsPresentoirMaterielByIdPresentoir:(NSNumber*)p_IdPresentoir andCodeMateriel:(NSString*)p_CodeMateriel
{
    BOOL v_Retour = false;
    @try{
        BeanPresentoir* v_Presentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:v_Presentoir.idLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([p_IdPresentoir intValue]== [v_BAP.idPresentoir intValue]
               && [v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Materiel]
               && [v_BAP.valeurTexte isEqualToString:p_CodeMateriel])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuControleVisuelByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}


-(void)AddOrUpdateLieuRelationnelByIdLieu:(NSNumber*)p_IdLieu andFait:(BOOL)p_Fait
{
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Relationnel])
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
            [v_Bean setIdLieu:p_IdLieu];
            [v_Bean setCodeAction:PEG_EnuActionMobilite_Relationnel];
            [v_Bean setValeurTexte:@"oui"];
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
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuRelationnelByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(BOOL)IsLieuRelationnelByIdLieu:(NSNumber*)p_IdLieu
{
    BOOL v_Retour = false;
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Relationnel])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.IsLieuRelationnelByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)AddOrUpdateCadeauByIdLieu:(NSNumber*)p_IdLieu andCodeCadeau:(NSString*)p_CodeCadeau andQte:(NSNumber*)p_NbCadeau
{
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Cadeau])
            {
                if( [v_BAP.valeurTexte isEqualToString:p_CodeCadeau]){
                    v_Bean = v_BAP;
                }
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(v_Bean == nil)
        {
            v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
            [v_LP addListActionObject:v_Bean];
        }
        [v_Bean setIdLieu:p_IdLieu];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Cadeau];
        [v_Bean setValeurTexte:p_CodeCadeau];
        [v_Bean setValeurInt:p_NbCadeau];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuRelationnelByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(void)DeleteCadeauByIdLieu:(NSNumber*)p_IdLieu andCodeCadeau:(NSString*)p_CodeCadeau
{
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
         PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Cadeau])
            {
                if( [v_BAP.valeurTexte isEqualToString:p_CodeCadeau]){
                    if([v_BAP.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Added])
                    {
                        //Ajouté dans la session donc on le supprime simplement
                        //PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                        [app.managedObjectContext deleteObject:v_BAP];
                    }
                    else{
                        v_BAP.flagMAJ = PEG_EnumFlagMAJ_Deleted;
                    }
                }
            }
        }
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.DeleteConcurenFortLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}


-(NSArray*) GetBeanActionListCadeauByIdLieu:(NSNumber*)p_IdLieu{
    NSMutableArray* v_listeAction = [[NSMutableArray alloc] init];
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
      
        for (BeanAction* v_BAP in v_LP.listAction) {
            if(![v_BAP.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted] &&[v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Cadeau])
            {
                [v_listeAction addObject:v_BAP];
            }
        }
        
        
               
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.GetBeanActionListCadeauByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_listeAction;

}

-(void)AddOrUpdateLieuCoordonneeByIdLieu:(NSNumber*)p_IdLieu andBeanPoint:(PEG_BeanPoint*)p_BeanPoint
{
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        BeanLieu* v_BLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
        
        v_BLieu.coordXpda = [[NSDecimalNumber alloc] initWithDecimal:[p_BeanPoint.Long decimalValue]];
        v_BLieu.coordYpda = [[NSDecimalNumber alloc] initWithDecimal:[p_BeanPoint.Lat decimalValue]];
        
        BeanAction* v_Bean = nil;
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Coordonnees])
            {
                v_Bean = v_BAP;
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(v_Bean == nil)
        {
            v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
            [v_LP addListActionObject:v_Bean];
        }
        [v_Bean setIdLieu:p_IdLieu];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Coordonnees];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.AddOrUpdateLieuCoordonneeByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(BOOL)IsLieuCoordonneeByIdLieu:(NSNumber*)p_IdLieu
{
    BOOL v_Retour = false;
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
        for (BeanAction* v_BAP in v_LP.listAction) {
            if([v_BAP.codeAction isEqualToString:PEG_EnuActionMobilite_Coordonnees])
            {
                v_Retour = true;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.IsLieuCoordonneeByIdLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_Retour;
}

-(void)UpdatePresentoirTacheByPresentoir:(BeanPresentoir*)p_BeanPresentoir andTache:(NSString*)p_Tache andFait:(BOOL)p_Fait andAFaire:(BOOL)p_AFaire
{
    @try{
        
        BeanTache* v_Bean = nil;
        for (BeanTache* v_BT in p_BeanPresentoir.listTache) {
            if([v_BT.code isEqualToString:p_Tache])
            {
                v_Bean = v_BT;
                [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Modified];
            }
        }
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        if(!p_Fait && !p_AFaire)
        {
            if(v_Bean != nil)
            {
                [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Deleted];
            }
            [self AddOrUpdatePresentoirMaterielByIdPresentoir:p_BeanPresentoir.idPointDistribution andCodeMateriel:p_Tache andFait:p_Fait];
        }
        else if(p_Fait)
        {
            if(v_Bean != nil)
            {
                [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Deleted];
            }
            if([p_Tache isEqualToString:PEG_EnumActionTache_PHOTO])
            {
            }
            else
            {
                [self AddOrUpdatePresentoirMaterielByIdPresentoir:p_BeanPresentoir.idPointDistribution andCodeMateriel:p_Tache andFait:p_Fait];
            }
        }
        else if(p_AFaire)
        {
            if(v_Bean == nil)
            {
                v_Bean = (BeanTache *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanTache" inManagedObjectContext:app.managedObjectContext];
                [p_BeanPresentoir addListTacheObject:v_Bean];
                [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
            }
            
            [v_Bean setDate:[NSDate date]];
            [v_Bean setIdLieu:p_BeanPresentoir.idLieu];
            [v_Bean setIdPresentoir:p_BeanPresentoir.id];
            [v_Bean setCode:p_Tache];
            
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        //On enregistre pour generé l'ID
        if([v_Bean.idTache intValue] == 0)
        {
            [v_Bean setIdTache:[[NSNumber alloc]initWithInteger:[v_Bean autoId]]];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanPresentoir.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.UpdatePresentoirTacheByPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(void)AddLieuVisiteByIdLieu:(NSNumber*)p_IdLieu
{
    @try
    {
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_IdLieu];
        
        BeanAction* v_Bean = nil;
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
        [v_LP addListActionObject:v_Bean];
        
        [v_Bean setIdLieu:p_IdLieu];
        [v_Bean setCodeAction:PEG_EnuActionMobilite_Visite];
        [v_Bean setDateAction:[NSDate date]];
        [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
        
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [v_Bean setCoordX:v_Pt.Long];
        [v_Bean setCoordY:v_Pt.Lat];
        [v_Bean setCoordGPSFiable:v_Pt.CoordFiable];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateLieu] SetDateDerniereVisiteByIdLieu:p_IdLieu];
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddLieuVisiteByIdLieu" andExparams:nil];
    }
}

@end
