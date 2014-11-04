//
//  PEG_ParutionServices.m
//  PEG
//
//  Created by 10_200_11_120 on 09/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ParutionServices.h"
#import "PEGException.h"
#import "PEGAppDelegate.h"
#import "PEG_FTechnical.h"
#import "BeanEdition.h"
#import "BeanCPCommune.h"

@implementation PEG_ParutionServices

-(BeanParution*) GetBeanParutionById:(NSNumber *)p_idParution
{
    BeanParution* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanParution" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"id == %@",p_idParution]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanParutionById" andExparams:[NSString stringWithFormat:@"p_idParution:%@",p_idParution]];
    }
    return v_retour;
}

-(BeanParution*) GetBeanParutionSuivanteById:(NSNumber *)p_idParution
{
    BeanParution* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanParution" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idParutionPrec == %@",p_idParution]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanParutionById" andExparams:[NSString stringWithFormat:@"p_idParution:%@",p_idParution]];
    }
    return v_retour;
}

-(BeanParution*) GetBeanParutionCouranteByIdEdition:(NSNumber *)p_idEdition
{
    BeanParution* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanParution" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idEdition == %@ AND %K <= %@ AND %K >= %@ ",p_idEdition, @"dateDebut",[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]],@"dateFin",[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]]];
        
        NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
        v_retour = [v_array lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanParutionCouranteByIdEdition" andExparams:[NSString stringWithFormat:@"p_idEdition:%@",p_idEdition]];
    }
    return v_retour;
}

-(NSArray*) GetListBeanParutionCouranteByCP:(NSString*)p_CodePostal
{
    NSArray* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        
        [req setEntity:[NSEntityDescription entityForName:@"BeanCPCommune" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@" cP == %@ ", p_CodePostal]];
        BeanCPCommune* v_CP = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        
        NSMutableArray* v_ArrayPredicateOr = [NSMutableArray array];
        for (BeanEdition* v_BE in v_CP.listEdition) {
            [v_ArrayPredicateOr addObject:[NSPredicate predicateWithFormat:@"idEdition == %@",v_BE.idEdition]];
        }
        NSPredicate* v_PredicateOr = [NSCompoundPredicate orPredicateWithSubpredicates:v_ArrayPredicateOr];
        
        NSMutableArray* v_ArrayPredicateAnd = [NSMutableArray array];
        [v_ArrayPredicateAnd addObject:v_PredicateOr];
        [v_ArrayPredicateAnd addObject:[NSPredicate predicateWithFormat:@" %K <= %@ AND %K >= %@ ", @"dateDebut",[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]],@"dateFin",[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]]];

        NSPredicate* v_PredicateAnd = [NSCompoundPredicate andPredicateWithSubpredicates:v_ArrayPredicateAnd];
    
        [req setEntity:[NSEntityDescription entityForName:@"BeanParution" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:v_PredicateAnd];
        
        v_retour= [app.managedObjectContext executeFetchRequest:req error:nil];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanParutionCouranteByIdEdition" andExparams:nil];
    }
    return v_retour;
}


-(NSArray*) GetListBeanParutionCourante
{
    NSArray* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanParution" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@" %K <= %@ AND %K >= %@ ", @"dateDebut",[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]],@"dateFin",[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]]];
        
        v_retour= [app.managedObjectContext executeFetchRequest:req error:nil];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanParutionCouranteByIdEdition" andExparams:nil];
    }
    return v_retour;
}

@end
