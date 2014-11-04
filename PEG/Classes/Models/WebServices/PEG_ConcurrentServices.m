//
//  PEG_ConcurrentServices.m
//  PEG
//
//  Created by 10_200_11_120 on 28/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ConcurrentServices.h"
#import "PEGException.h"
#import "PEGAppDelegate.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEG_FTechnical.h"
#import "PEG_FMobilitePegase.h"

@implementation PEG_ConcurrentServices

-(NSMutableArray*) GetAllBeanConcurents
{
    NSMutableArray* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanConcurents" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"dateDebut <= %@ && dateFin >= %@",[NSDate date],[NSDate date]]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
        [v_retour sortUsingSelector:@selector(compareTrie:)];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetAllBeanConcurents" andExparams:@""];
    }
    return v_retour;
}

-(BeanConcurents*) GetBeanConcurentsById:(NSNumber *)p_idConcurent
{
    BeanConcurents* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanConcurents" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idConcurentRef == %@",p_idConcurent]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanConcurentsById" andExparams:[NSString stringWithFormat:@"p_idConcurent:%@",p_idConcurent]];
    }
    return v_retour;
}
-(NSArray*) GetBeanConcurentLieuByLieu:(BeanLieu *)p_BeanLieu
{
    @try{
        NSMutableArray * v_retour = [[NSMutableArray alloc] init];
        for (BeanConcurentLieu* v_CL in p_BeanLieu.listConcurentLieu) {
            if( ! [v_CL.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                [v_retour addObject:v_CL];
            }
        }
        return v_retour;
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.GetBeanConcurentLieuByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(int) GetNbConcurentLieuByLieu:(BeanLieu *)p_BeanLieu
{
    int v_retour = 0;
    @try{
        for (BeanConcurentLieu* v_CL in p_BeanLieu.listConcurentLieu) {
            if( ! [v_CL.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                v_retour++;
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.GetNbConcurentLieuByLieu",NSStringFromClass([self class])] andExparams:nil];
    }
    return v_retour;
}
-(void)DeleteConcurenFortLieu:(BeanLieu*)p_BeanLieu andIdConcurent:(NSNumber*)p_idConcurrence
{
    @try{
        for (BeanConcurentLieu* v_CL in p_BeanLieu.listConcurentLieu) {
            if([v_CL.idConcurrence isEqualToNumber:p_idConcurrence])
            {
                if([v_CL.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Added])
                {
                    //Ajouté dans la session donc on le supprime simplement
                    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                    [app.managedObjectContext deleteObject:v_CL];
                }
                else{
                    [v_CL setFlagMAJ:PEG_EnumFlagMAJ_Deleted];
                }
            }
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanLieu.idLieu];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.DeleteConcurenFortLieu",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(void)AddOrReplaceConcurrent:(NSNumber*)p_idConcurent AndBeanLieu:(BeanLieu *)p_BeanLieu andFamille:(NSString*)p_Famille andEmplacement:(NSString*)p_Emplacement{
    
    @try{
        //BeanLieu * v_BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_idLieu];
        
        BeanConcurentLieu* v_Bean = nil;
        for (BeanConcurentLieu* v_RowConcurentLieu in p_BeanLieu.listConcurentLieu){
            if([v_RowConcurentLieu.idConcurrence isEqualToNumber:p_idConcurent])
            {
                v_Bean = v_RowConcurentLieu;
                break;
            }
        }
        if(v_Bean == nil)
        {
            //ici on ajoute un concurent, on doit supprimer le sans concurent (du lieu)
            [[PEG_FMobilitePegase CreateConcurrent] UpdateSansConcurrentByBeanLieu:p_BeanLieu andSansConcurent:NO];
            
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            v_Bean = (BeanConcurentLieu *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanConcurentLieu" inManagedObjectContext:app.managedObjectContext];
            [v_Bean setIdConcurrence:p_idConcurent];
            [v_Bean setIdLieu:p_BeanLieu.idLieu];
            [v_Bean setDateDebut:[NSDate date]];
            [v_Bean setDateFin:[PEG_FTechnical GetDate2090]];
            [v_Bean setFamille:p_Famille];
            [v_Bean setEmplacement:p_Emplacement];
            [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Added];
            
            [p_BeanLieu addListConcurentLieuObject:v_Bean];
            
            //On annule le sans concurent
            //[p_BeanLieu setAucunConcurent:NO];
            [p_BeanLieu setAucunConcurent:[[NSNumber alloc]initWithBool:NO]];
        }
        else
        {
            [v_Bean setFamille:p_Famille];
            [v_Bean setEmplacement:p_Emplacement];
            [v_Bean setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        }
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanLieu.idLieu];
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AddOrReplaceConcurrent" andExparams:nil];
    }
    
}

-(void)UpdateSansConcurrentByBeanLieu:(BeanLieu *)p_BeanLieu andSansConcurent:(BOOL)p_VFSansConcurent
{
    @try{
        //On flag sans concurent
        [p_BeanLieu setAucunConcurent:[[NSNumber alloc]initWithBool:p_VFSansConcurent]];
        [p_BeanLieu setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        
        if(p_VFSansConcurent)
        {
            //On supprime tous les conncurent qui pourraient encore exister
            for (BeanConcurentLieu* v_CL in [self GetBeanConcurentLieuByLieu:p_BeanLieu]) {
                [self DeleteConcurenFortLieu:p_BeanLieu andIdConcurent:v_CL.idConcurrence];
            }
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:p_BeanLieu.idLieu];
        
    }@catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans UpdateSansConcurrentByBeanLieu" andExparams:nil];
    }
}
@end
