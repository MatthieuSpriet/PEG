//
//  PEG_ListeChoixServices.m
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListeChoixServices.h"
#import "SPIRTechnicalException.h"
#import "PEGException.h"
#import "PEGAppDelegate.h"
#import "BeanRestrictionChoix.h"
#import "PEG_FTechnical.h"
#import "BeanCPCommune+.h"

@interface PEG_ListeChoixServices ()

+ (NSMutableDictionary*) DictTypeVoieByCode;
+ (NSMutableDictionary*) SetDictTypeVoieByCodeValue:(NSString*)p_Value ForKey:(NSString*)p_Key;
@end

@implementation PEG_ListeChoixServices

static NSMutableDictionary* _DictTypeVoieByCode;
static NSMutableDictionary* _DictLiaisonVoieByCode;

/*+ (NSMutableDictionary*) idGen { return _DictTypeVoieByCode; }
+ (NSMutableDictionary*) SetDictTypeVoieByCodeValue:(NSString*)p_Value ForKey:(NSString*)p_Key
{
        [self.DictTypeVoieByCode setObject:p_Value forKey:p_Key];
}*/


-(NSArray*) GetListBeanChoixMaterielByTypePresentoir:(NSString*)p_TypePres{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"code == %@",p_TypePres]];
        
        BeanChoix* v_TypePresentoir = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        
        if(v_TypePresentoir != nil)
        {
            //On vérifie si la ligne existe déjà
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
            [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"Materiels"]];
            
            NSArray* v_AllMatos = [app.managedObjectContext executeFetchRequest:req error:nil];
            for (BeanChoix* v_BC in v_AllMatos) {
                for (BeanRestrictionChoix* v_RC in v_TypePresentoir.listRestriction) {
                    
                    if([v_BC.code isEqualToString:v_RC.codeFils])
                    {
                        [v_retour addObject:v_BC];
                    }
                }
            }
         [v_retour sortUsingSelector:@selector(compareTrie:)];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixMateriel" andExparams:nil];
    }
    return v_retour;
}
-(BOOL) IsChoixMateriel:(NSString*)p_CodeChoix{
    
    BOOL v_retour = false;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"code == %@ && categorie == %@",p_CodeChoix,@"Materiels"]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil].count > 0;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsChoixMateriel" andExparams:nil];
    }
    return v_retour;
}
-(NSArray*) GetListBeanChoixInfosADX{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"InfosAdx"]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
        [v_retour sortUsingSelector:@selector(compareTrie:)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixInfosADX" andExparams:nil];
    }
    return v_retour;
}


-(NSArray*) GetListBeanChoixEtatLieu{
    
    NSArray* v_retour = [[NSArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"EtatLieu"]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixEtatLieu" andExparams:nil];
    }
    return v_retour;
}
-(NSString*) GetLibelleEtatLieuByCode:(NSString*)p_Code{
    
    NSString* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND code== %@",@"EtatLieu",p_Code]];
        
        v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).libelle;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetLibelleEtatLieuByCode" andExparams:nil];
    }
    return v_retour;
}
-(NSString*) GetCodeEtatLieuByLibelle:(NSString*)p_Libelle{
    
    NSString* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND libelle== %@",@"EtatLieu",p_Libelle]];
        
        v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).code;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetCodeEtatLieuByLibelle" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanChoixFamillePresentoir{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"FamPresentoir"]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
    [v_retour sortUsingSelector:@selector(compareTrie:)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixFamillePresentoir" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanChoixTypePresentoir{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ && dateDebut <= %@ && dateFin >= %@",@"TypePresentoir",[NSDate date],[NSDate date]]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
            [v_retour sortUsingSelector:@selector(compareTrie:)];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixTypePresentoir" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanChoixTypePresentoirByCodeFamille:(NSString*)p_CodeFamille{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"code == %@",p_CodeFamille]];
        
        BeanChoix* v_FamillePresentoir = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        
        if(v_FamillePresentoir != nil)
        {
            //On vérifie si la ligne existe déjà
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
            [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ && dateDebut <= %@ && dateFin >= %@",@"TypePresentoir",[NSDate date],[NSDate date]]];
            
            NSArray* v_All = [app.managedObjectContext executeFetchRequest:req error:nil];
            for (BeanChoix* v_BC in v_All) {
                for (BeanRestrictionChoix* v_RC in v_FamillePresentoir.listRestriction) {
                    
                    if([v_BC.code isEqualToString:v_RC.codeFils])
                    {
                        [v_retour addObject:v_BC];
                    }
                }
            }
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixTypePresentoirByCodeFamille" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanChoixEmplacementPresentoir{
    
    NSArray* v_retour = [[NSArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"EmpPresentoir"]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixEmplacementPresentoir" andExparams:nil];
    }
    return v_retour;
}



-(NSArray*) GetListBeanChoixCadeau{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ && dateDebut <= %@ && dateFin >= %@",@"Cadeaux",[NSDate date],[NSDate date]]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
        [v_retour sortUsingSelector:@selector(compareTrie:)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixCadeau" andExparams:nil];
    }
    return v_retour;
}

-(NSString*) GetLibelleCadeauxByCode:(NSString*)p_Code{
    
    NSString* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND code== %@",@"Cadeaux",p_Code]];
        
        v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).libelle;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetLibelleEtatLieuByCode" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanChoixTypeVoie{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"Voie"]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
        [v_retour sortUsingSelector:@selector(compareTrie:)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixTypeVoie" andExparams:nil];
    }
    return v_retour;
}


-(NSString*) GetLibelleTypeVoieByCode:(NSString*)p_Code{
    
    NSString* v_retour = nil;
    @try
    {
        if(p_Code != nil && ![p_Code isEqualToString:@""])
        {
            if(_DictTypeVoieByCode == nil)
            {
                _DictTypeVoieByCode = [[NSMutableDictionary alloc] init];
            }
            
            v_retour = [_DictTypeVoieByCode valueForKey:p_Code];
            if(v_retour == nil)
            {
                //On n'insert que si la ligne n'existe pas
                PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                
                //On vérifie si la ligne existe déjà
                NSFetchRequest *req = [[NSFetchRequest alloc]init];
                [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
                [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND code== %@",@"Voie",p_Code]];
                
                v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).libelle;
                
                [_DictTypeVoieByCode setObject:v_retour forKey:p_Code];
            }
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetLibelleTypeVoieByCode" andExparams:nil];
    }
    return v_retour;
}
-(NSString*) GetCodeTypeVoieByLibelle:(NSString*)p_Libelle{
    
    NSString* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND libelle== %@",@"Voie",p_Libelle]];
        
        v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).code;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetCodeTypeVoieByLibelle" andExparams:nil];
    }
    return v_retour;
}


-(NSArray*) GetListBeanChoixLiaison{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];

    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"Liaison"]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
        [v_retour sortUsingSelector:@selector(compareTrie:)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixLiaison" andExparams:nil];
    }
    return v_retour;
}

-(NSString*) GetLibelleLiaisonByCode:(NSString*)p_Code{
    
    NSString* v_retour = nil;
    @try
    {
        if(p_Code != nil && ![p_Code isEqualToString:@""])
        {
            if(_DictLiaisonVoieByCode == nil)
            {
                _DictLiaisonVoieByCode = [[NSMutableDictionary alloc] init];
            }
            
            v_retour = [_DictLiaisonVoieByCode valueForKey:p_Code];
            if(v_retour == nil)
            {
                
                
                //On n'insert que si la ligne n'existe pas
                PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                
                //On vérifie si la ligne existe déjà
                NSFetchRequest *req = [[NSFetchRequest alloc]init];
                [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
                [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND code== %@",@"Liaison",p_Code]];
                
                v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).libelle;
                
                [_DictLiaisonVoieByCode setObject:v_retour forKey:p_Code];
            }
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetLibelleLiaisonByCode" andExparams:nil];
    }
    return v_retour;
}

-(NSString*) GetCodeLiaisonByLibelle:(NSString*)p_Libelle{
    
    NSString* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND libelle== %@",@"Liaison",p_Libelle]];
        
        v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).code;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetCodeLiaisonByLibelle" andExparams:nil];
    }
    return v_retour;
}


-(NSArray*) GetListBeanChoixNoVoieBisTer{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"NoVoie"]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
         [v_retour sortUsingSelector:@selector(compareTrie:)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixNoVoieBisTer" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanChoixCivilite{
    
    NSArray* v_retour = [[NSArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@",@"Civilite"]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixCivilite" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanChoixActivite{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ && dateDebut <= %@ && dateFin >= %@",@"Activite",
        [NSDate date],[NSDate date]]];
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
         [v_retour sortUsingSelector:@selector(compareTrie:)];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanChoixActivite" andExparams:nil];
    }
    return v_retour;
}
-(NSString*) GetLibelleActiviteByCode:(NSString*)p_Code{
    
    NSString* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND code== %@",@"Activite",p_Code]];
        
        v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).libelle;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetLibelleActiviteByCode" andExparams:nil];
    }
    return v_retour;
}
-(NSString*) GetCodeActiviteByLibelle:(NSString*)p_Libelle{
    
    NSString* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"categorie == %@ AND libelle== %@",@"Activite",p_Libelle]];
        
        v_retour = ((BeanChoix*)[[app.managedObjectContext executeFetchRequest:req error:nil] lastObject]).code;
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetCodeActiviteByLibelle" andExparams:nil];
    }
    return v_retour;
}

-(NSArray*) GetListBeanCPCommune{
    
    NSMutableArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanCPCommune" inManagedObjectContext:app.managedObjectContext]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] mutableCopy];
        
        [v_retour sortUsingSelector:@selector(compareTrie:)];
        //v_retour = [v_array sortedArrayUsingSelector:@selector(compareTrie:)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListBeanCPCommune" andExparams:nil];
    }
    return v_retour;
}

-(BeanCPCommune*) GetBeanCPCommuneByCodeCP:(NSNumber*)p_CP{
    
    BeanCPCommune* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanCPCommune" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"cP == %@ ",p_CP]];
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanChoixByIdChoix" andExparams:nil];
    }
    return v_retour;
}

-(BeanCPCommune*) GetBeanCPCommuneByLibelleCommune:(NSString*)p_commune{
    
    BeanCPCommune* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanCPCommune" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"commune == %@ ",p_commune]];
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanCPCommuneByLibelleCommune" andExparams:nil];
    }
    return v_retour;
}

-(BeanChoix*) GetBeanChoixByCode:(NSNumber*)p_Code andCategorie:(NSString *)p_Categorie{
    
    BeanChoix* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"code == %@ && categorie == %@",p_Code,p_Categorie]];
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanChoixByIdChoix" andExparams:nil];
    }
    return v_retour;
}

@end
