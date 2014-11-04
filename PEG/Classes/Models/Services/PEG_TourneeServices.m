//
//  PEG_TourneeServices.m
//  PEG
//
//  Created by 10_200_11_120 on 26/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_TourneeServices.h"
//#import "PEG_BeanMobilitePegase.h"
//#import "PEG_BeanTournee.h"
#import "BeanLieuPassage.h"
#import "PEGException.h"
#import "PEG_FTechnical.h"
#import "PEG_FMobilitePegase.h"
#import "PEGAppDelegate.h"
#import "PEG_EnuActionMobilite.h"
#import "BeanAction.h"
#import "BeanEdition.h"

@implementation PEG_TourneeServices

-(BeanTournee*) GetTourneeByIdTournee:(NSNumber*)p_IdTournee
{
    BeanTournee* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanTournee" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idTournee == %@",p_IdTournee]];
        NSError* v_error;
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:&v_error] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetTourneeByIdTournee" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
    }
    return v_retour;
}

-(NSArray*) GetTourneeBetweenDateDebut:(NSDate*)p_DtDebut andDateFin:(NSDate*)p_DateFin
{
    NSArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanTournee" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"dtDebutReelle >= %@ AND dtDebutReelle <= %@ ",[PEG_FTechnical GetDateYYYYMMDDFromDate:p_DtDebut],[[PEG_FTechnical GetDateYYYYMMDDFromDate:p_DateFin] dateByAddingTimeInterval:((3600*24)-1) ]]];
        NSError* v_error;
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:&v_error];
        if(v_ArrayBean != nil)
        {
            v_retour = v_ArrayBean;
        }
        else{
            DLog("%@",v_error);
        }
        
        /*for (PEG_BeanTournee* v_Item in [PEG_BeanMobilitePegase sharedInstance].ListTournee)
         {
         if([v_Item.DtDebutReelle timeIntervalSinceDate:[PEG_FTechnical GetDateYYYYMMDDFromDate:p_DtDebut]] >= 0
         && ([v_Item.DtDebutReelle timeIntervalSinceDate:[PEG_FTechnical GetDateYYYYMMDDFromDate:p_DateFin]]-(3600*24)-1) <= 0)
         {
         [v_retour addObject:v_Item];
         }
         }*/
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetTourneeBetweenDateDebutandDateFin" andExparams:[NSString stringWithFormat:@"p_DtDebut:%@, p_DateFin:%@",p_DtDebut,p_DateFin]];
    }
    return v_retour;
}

-(BeanTournee*) GetTourneeMerchDuJour
{
    BeanTournee* v_retour = nil;
    @try
    {
        
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanTournee" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"dtDebutReelle >= %@ AND dtDebutReelle <= %@ AND coTourneeType == %@",[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]],[[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]] dateByAddingTimeInterval:((3600*24)-1) ],@"MER"]];
        NSError* v_error;
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:&v_error];
        if(v_ArrayBean != nil && v_ArrayBean.count == 1)
        {
            v_retour = (BeanTournee*)[v_ArrayBean lastObject];
        }
//        else
//        {
//            v_retour = (BeanTournee *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanTournee" inManagedObjectContext:app.managedObjectContext];
//            [[PEG_FMobilitePegase CreateCoreData] Save];
//        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetTourneeMerchDuJour" andExparams:nil];
    }
    return v_retour;
}

/*-(NSMutableArray*) GetListeLieuPassageByTournee:(NSNumber*)p_IdTournee
 {
 NSMutableArray* v_retour = [[NSMutableArray alloc] init];
 @try
 {
 for (PEG_BeanTournee* v_ItemLT in [PEG_BeanMobilitePegase sharedInstance].ListTournee)
 {
 if([v_ItemLT.IdTournee isEqualToNumber:p_IdTournee])
 {
 for (PEG_BeanLieuPassage* v_ItemLP in v_ItemLT.ListLieuPassage)
 {
 [v_retour addObject:v_ItemLP];
 }
 }
 }
 }
 @catch(NSException* p_exception){
 [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetTourneeBetweenDateDebutandDateFin" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
 }
 return v_retour;
 }*/

-(NSArray*) GetListeLieuPassageByTournee:(NSNumber*)p_IdTournee
{
    NSArray* v_retour = [[NSArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas  -- pm: ????
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idTournee == %@",p_IdTournee]];
        NSError* v_error;
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:&v_error];
        if(v_ArrayBean != nil)
        {
            NSSortDescriptor *positionSort = [NSSortDescriptor sortDescriptorWithKey:@"nbOrdrePassage" ascending:YES];
            v_retour = [v_ArrayBean sortedArrayUsingDescriptors:[NSArray arrayWithObject:positionSort]];
        }
        else{
            DLog("%@",v_error);
        }
        
        /*for (PEG_BeanTournee* v_ItemLT in [PEG_BeanMobilitePegase sharedInstance].ListTournee)
         {
         if([v_ItemLT.IdTournee isEqualToNumber:p_IdTournee])
         {
         for (PEG_BeanLieuPassage* v_ItemLP in v_ItemLT.ListLieuPassage)
         {
         [v_retour addObject:v_ItemLP];
         }
         }
         }*/
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetTourneeBetweenDateDebutandDateFin" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
    }
    return v_retour;
}


-(NSNumber*) GetNbTacheByTournee:(NSNumber*)p_IdTournee
{
    NSNumber* v_retour = nil;
    int v_Count = 0;
    @try
    {
        for (BeanLieuPassage* v_ItemLP in [self GetListeLieuPassageByTournee:p_IdTournee])
        {
            v_Count += [[PEG_FMobilitePegase CreateLieu] GetNbAllTacheForLieu:[[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:v_ItemLP.idLieu]];
            //for(BeanPresentoir* v_Pres in [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:v_ItemLP.idLieu].listPresentoir)
            //{
            //    v_Count += v_Pres.listTache.count;
            //}
        }
        v_retour = [[NSNumber alloc] initWithInt:v_Count];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetNbTacheByTournee" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
    }
    return v_retour;
}

-(NSString*) GetLibelleMagazinesForDesignByTournee:(BeanTournee*)P_BeanTournee andNbCarTrunc:(int)p_NbCarTrunc andEntete:(BOOL)p_Entete
{
    NSString* v_retour = @"";
    int v_traceIdPresentoir = 0;
    @try
    {
        int v_NbPres = 0;
        NSMutableDictionary* p_Dico = [[NSMutableDictionary alloc] init];
        for(BeanLieuPassage* v_LP in P_BeanTournee.listLieuPassage)
        {
            for (BeanAction* v_BA in v_LP.listAction) {
                if([v_BA.codeAction isEqual:PEG_EnuActionMobilite_Previ])
                {                    
                    v_traceIdPresentoir = [v_BA.idPresentoir intValue];
                    v_NbPres++;
                    if([p_Dico valueForKey:[v_BA.idParution stringValue]] == nil)
                    {
                        [p_Dico setObject:v_BA.quantitePrevue forKey:[v_BA.idParution stringValue]];
                    }
                    else
                    {
                        int v_QtOld = [v_BA.quantitePrevue intValue] + [[p_Dico valueForKey:[v_BA.idParution stringValue]] intValue];
                        [p_Dico setObject:[[[NSNumber alloc]initWithInt:v_QtOld ] stringValue] forKey:[v_BA.idParution stringValue]];
                    }
                }
            }
            /*for(BeanPresentoir* v_Pres in [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:v_LP.idLieu].listPresentoir)
            {
                v_traceIdPresentoir = [v_Pres.id intValue];
                if(v_Pres.idParution != nil)
                {
                    NSNumber* v_qt = [[PEG_FMobilitePegase CreateLieu] GetQteDistribueeByIdPresentoir:v_Pres.id andIdParution:v_Pres.idParution];
                    if([p_Dico valueForKey:[v_Pres.idParution stringValue]] == nil)
                    {
                        [p_Dico setObject:v_qt forKey:[v_Pres.idParution stringValue]];
                    }
                    else
                    {
                        int v_QtOld = [v_qt intValue] + [[p_Dico valueForKey:[v_Pres.idParution stringValue]] intValue];
                        [p_Dico setObject:[[[NSNumber alloc]initWithInt:v_QtOld ] stringValue] forKey:[v_Pres.idParution stringValue]];
                    }
                }
            }*/
        }
        if(p_Entete)
        {
            v_retour =[NSString stringWithFormat:@"%@ - %i pres prévis.\n",[PEG_FTechnical GetLibelleDDMMYYYYFromDateString:P_BeanTournee.dtDebutReelle],v_NbPres];
        }
        for (NSString* v_item in [p_Dico allKeys]) {
            BeanParution* v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:[[NSNumber alloc] initWithInt:[v_item intValue]]];
            if(v_BeanParution != nil)
            {
                NSString* v_libEdition = v_BeanParution.libelleEdition;
                if(v_libEdition.length > p_NbCarTrunc)
                {
                    v_libEdition = [v_libEdition substringToIndex:p_NbCarTrunc];
                }
                v_retour = [NSString stringWithFormat:@"%@ %@ %@ex",v_retour,v_libEdition,[p_Dico valueForKey:v_item]];
            }
        }
        //DLog(@"%@",v_retour);
    }
    @catch(NSException* p_exception){
        v_retour = @"erreur...";
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans GetLibelleMagazinesForDesign" andExparams:[NSString stringWithFormat:@"v_traceIdPresentoir:%i",v_traceIdPresentoir]];
    }
    return v_retour;
}

@end
