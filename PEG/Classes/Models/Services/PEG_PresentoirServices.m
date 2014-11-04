//
//  PEG_PresentoirServices.m
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_PresentoirServices.h"
//#import "PEG_BeanLieu.h"
#import "PEGException.h"
#import "PEG_FMobilitePegase.h"
//#import "PEG_BeanTache.h"
#import "PEGAppDelegate.h"
#import "PEG_EnumFlagMAJ.h"
#import "BeanTache.h"
#import "PEG_EnuActionMobilite.h"
#import "PEG_EnumActionTache.h"
#import "PEG_FTechnical.h"
#import "BeanHistoriqueParutionPresentoir.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"
#import "PEG_BeanPresentoirParution.h"
#import "BeanPresentoirParution.h"

@implementation PEG_PresentoirServices


-(BeanPresentoir*) GetBeanPresentoirById:(NSNumber *)p_idPresentoir{
    BeanPresentoir* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanPresentoir" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"id == %@",p_idPresentoir]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanParutionById" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@",p_idPresentoir]];
    }
    return v_retour;
    
}

-(void)UpdatePresentoirEmplacementByPresentoir:(BeanPresentoir*)p_BeanPresentoir andEmplacement:(NSString*)p_Emplacement
{
    @try{
        if(![p_Emplacement isEqualToString:p_BeanPresentoir.emplacement])
        {
            p_BeanPresentoir.emplacement = p_Emplacement;
            p_BeanPresentoir.flagMAJ = [PEG_EnumFlagMAJ UpdateFlagMAJ:PEG_EnumFlagMAJ_Modified];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.UpdatePresentoirEmplacementByPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}
-(void)UpdatePresentoirLocalisationByPresentoir:(BeanPresentoir*)p_BeanPresentoir andLocalisation:(NSString*)p_Localisation
{
    @try{
        if(![p_Localisation isEqualToString:p_BeanPresentoir.localisation])
        {
            p_BeanPresentoir.localisation = p_Localisation;
            p_BeanPresentoir.flagMAJ = [PEG_EnumFlagMAJ UpdateFlagMAJ:PEG_EnumFlagMAJ_Modified];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.UpdatePresentoirLocalisationByPresentoir",NSStringFromClass([self class])] andExparams:nil];
    }
}

-(BOOL) IsTacheAFaireIsOnPresentoir:(NSString*)p_CodeMateriel andIdPresentoir:(NSNumber*)p_idPresentoir{
    
    BOOL v_retour=false;
    
    @try
    {
        BeanPresentoir* v_beanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_idPresentoir];
        for (BeanTache* v_ItemTache in v_beanPresentoir.listTache)
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
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsTacheAFaireIsOnPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@",p_idPresentoir]];
    }
    
    return v_retour;
}


-(BOOL) IsTacheFaitIsOnPresentoir:(NSString*)p_CodeMateriel andIdPresentoir:(NSNumber*)p_idPresentoir{
    
    BOOL v_retour=false;
    @try
    {
        v_retour = [[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirMaterielByIdPresentoir:p_idPresentoir andCodeMateriel:p_CodeMateriel];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsTacheFaitIsOnPresentoir" andExparams:[NSString stringWithFormat:@"p_idPresentoir:%@",p_idPresentoir]];
    }
    
    return v_retour;
}

-(BeanPresentoir*) CreateBeanPresentoirOnLieu:(BeanLieu *)p_BeanLieu andType:(NSString*)p_CodeTypePresentoir
{
    BeanPresentoir* v_retour = nil;
    @try
    {
        if(p_BeanLieu != nil ){
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            v_retour = (BeanPresentoir *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanPresentoir" inManagedObjectContext:app.managedObjectContext];
            [v_retour setIdLieu:p_BeanLieu.idLieu];
            [v_retour setTYPE:p_CodeTypePresentoir];
            [v_retour setGuidpresentoir:[PEG_FTechnical genererGUID]];
            [v_retour setFlagMAJ:PEG_EnumFlagMAJ_Added];
            
            [p_BeanLieu addListPresentoirObject:v_retour];
            [[PEG_FMobilitePegase CreateCoreData] Save];
            //On preenregistre pour avoir un ID generé
            [v_retour setId:[[NSNumber alloc]initWithInt:[v_retour autoId]]];
            [v_retour setIdPointDistribution:[[NSNumber alloc]initWithInt:[v_retour autoId]]];
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirCreationByIdPresentoir:v_retour.id];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans CreateBeanPresentoirOnLieu" andExparams:[NSString stringWithFormat:@"p_BeanLieu.idLieu : %@, p_CodeTypePresentoir:%@",p_BeanLieu.idLieu,p_CodeTypePresentoir]];
    }
    return v_retour;
}

-(BeanPresentoir*) RemplacerBeanPresentoirOnLieu:(BeanLieu *)p_BeanLieu andBeanPresentoirOrigine:(BeanPresentoir*)p_PresentoirOrigine andType:(NSString*)p_CodeTypePresentoir
{
    BeanPresentoir* v_retour = nil;
    @try
    {
        if(p_BeanLieu != nil ){
            [p_PresentoirOrigine setFlagMAJ:PEG_EnumFlagMAJ_Deleted];
            
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            v_retour = (BeanPresentoir *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanPresentoir" inManagedObjectContext:app.managedObjectContext];
            [v_retour setIdLieu:p_BeanLieu.idLieu];
            [v_retour setIdPointDistribution:p_PresentoirOrigine.idPointDistribution];
            [v_retour setId:p_PresentoirOrigine.idPointDistribution];
            [v_retour setTYPE:p_CodeTypePresentoir];
            [v_retour setLocalisation:p_PresentoirOrigine.localisation];
            [v_retour setEmplacement:p_PresentoirOrigine.emplacement];
            [v_retour setGuidpresentoir:[PEG_FTechnical genererGUID]];
            [v_retour setFlagMAJ:PEG_EnumFlagMAJ_Added];
            
            [p_BeanLieu addListPresentoirObject:v_retour];
            [[PEG_FMobilitePegase CreateCoreData] Save];
            //On preenregistre pour avoir un ID generé
            [v_retour setId:[[NSNumber alloc]initWithInt:[v_retour autoId]]];
            [[PEG_FMobilitePegase CreateCoreData] Save];
            
            [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirRemplaceByIdPresentoir:v_retour.id];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans RemplacerBeanPresentoirOnLieu" andExparams:[NSString stringWithFormat:@"p_BeanLieu.idLieu : %@, p_CodeTypePresentoir:%@",p_BeanLieu.idLieu,p_CodeTypePresentoir]];
    }
    return v_retour;
}


-(void)SetPresentoirDeleted:(BeanPresentoir*)p_BeanPresentoir{
    @try
    {
        [p_BeanPresentoir setFlagMAJ:PEG_EnumFlagMAJ_Deleted];
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirSupprimeByIdPresentoir:p_BeanPresentoir.id];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans SetPresentoirDeleted" andExparams:nil];
    }
}

- (BeanParution*) GetParutionEnCoursByPresentoir:(BeanPresentoir*)p_BeanPresentoir
{
    BeanParution* v_retour = nil;
    @try{
        
        //////////////////////////////////
        //On récupère la derniere parution
        //////////////////////////////////
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"BeanHistoriqueParutionPresentoir" inManagedObjectContext:app.managedObjectContext];
        [request setEntity:entity];
        [request setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@",p_BeanPresentoir.id]];
        // Results should be in descending order of timeStamp.
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSArray *results = [app.managedObjectContext executeFetchRequest:request error:NULL];
        if (results == nil) {
            // Handle the error.
        }
        else {
            if ([results count] > 0) {
                BeanHistoriqueParutionPresentoir *latestEntity = [results objectAtIndex:0];
                BeanParution* v_LastParutionHisto =[[PEG_FMobilitePegase CreateParution] GetBeanParutionById:latestEntity.idParution];
                
//                if([[PEG_FTechnical GetDateYYYYMMDDFromDate:v_LastParutionHisto.dateDebut] compare:[NSDate date]] == NSOrderedAscending /*<*/
//                   && [[[PEG_FTechnical GetDateYYYYMMDDFromDate:v_LastParutionHisto.dateFin] dateByAddingTimeInterval:((3600*24)-1)] compare:[NSDate date]] == NSOrderedDescending /*>*/
//				   )
				// pm201402 replaced previous lines to avoid warning
				NSDate * oneDayAfterEndDate = [[PEG_FTechnical GetDateYYYYMMDDFromDate:v_LastParutionHisto.dateFin] dateByAddingTimeInterval:((3600*24)-1)];
                if([[PEG_FTechnical GetDateYYYYMMDDFromDate:v_LastParutionHisto.dateDebut] compare:[NSDate date]] == NSOrderedAscending /*<*/
                   && [oneDayAfterEndDate compare:[NSDate date]] == NSOrderedDescending /*>*/
				   )
                {
                    v_retour = v_LastParutionHisto;
                }
                else
                {
                    v_retour = [[PEG_FMobilitePegase CreateParution] GetBeanParutionCouranteByIdEdition:v_LastParutionHisto.idEdition];
                }
            }
        }
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"GetParutionEnCoursByPresentoir" andExparams:[NSString stringWithFormat:@"p_BeanPresentoir.idPointDistribution : %@", p_BeanPresentoir.idPointDistribution]];
    }
    return v_retour;
}
- (void) MAJParutionPresentoir
{
    @try{
        /*NSArray* v_AllLieu = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieu];
         for (BeanLieu* v_lieu in v_AllLieu) {
         for(BeanPresentoir* v_ItemPresentoir in v_lieu.listPresentoir)
         {
         //BeanParution* v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_ItemPresentoir.idParution];
         BeanParution* v_BeanParution = nil;
         if(v_ItemPresentoir.idParution != nil && ![v_ItemPresentoir.idParution isEqualToNumber:[[NSNumber alloc] initWithInt:0]])
         {
         //Rien
         }
         else{
         v_BeanParution = [[PEG_FMobilitePegase CreatePresentoir] GetParutionEnCoursByPresentoir:v_ItemPresentoir];
         v_ItemPresentoir.idParution = v_BeanParution.id;
         }
         }
         }
         [[PEG_FMobilitePegase CreateCoreData] Save];*/
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"MAJParutionPresentoir" andExparams:nil];
    }
}

-(void) AjouterJournalToPresentoir:(NSNumber*)p_idJournal andIdPresentoir:(NSNumber*)p_idPresentoir andLieu:(NSNumber*)p_idLieu{
    @try{
        BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:p_idLieu];
        [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_LP.idLieu andIdPresentoir:p_idPresentoir andIdParution:p_idJournal andQte:[[NSNumber alloc] initWithInt:0]];
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"MAJParutionPresentoir" andExparams:nil];
    }
    
}

-(NSMutableArray*) GetListPresentoirParutionByPresentoir:(BeanPresentoir*)p_Presentoir
{
    NSMutableArray* v_Retour = [[NSMutableArray alloc] init];
    @try
    {
        bool v_IsFirstPres = true;
        
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        //On ajoute les parutions selon la règle métier
        req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanPresentoirParution" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@",p_Presentoir.idPointDistribution]];
        
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
                    v_BPP.IsFirstPres = v_IsFirstPres;
                    v_IsFirstPres = false; //Le prochain ne sera plus le premier
                    v_BPP.Presentoir = p_Presentoir;
                    v_BPP.Parution = v_ParutionCourante;
                    NSPredicate *valuePredicate=[NSPredicate predicateWithFormat:@"self.Parution.id == %d && self.Presentoir.idPointDistribution == %d",[v_BPresPar.idParution intValue],[p_Presentoir.idPointDistribution intValue]];
                    
                    if ([[v_Retour filteredArrayUsingPredicate:valuePredicate] count]==0)
                    {
                        [v_Retour addObject:v_BPP];
                    }
                }
            }
        }
        
        //BeanLieuPassage* v_BLP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageOnTourneeMerchByIdLieu:p_Presentoir.idLieu];
        
        //On complete avec les actions saisie
        [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@ and (codeAction == %@ OR codeAction == %@)",p_Presentoir.idPointDistribution,PEG_EnuActionMobilite_Previ,PEG_EnuActionMobilite_Distri]];
        
        //On trie par parution pour eviter, qu'en fonction des saisie l'ordre change
        sortDescription = [[NSSortDescriptor alloc] initWithKey:@"idParutionRef" ascending:YES];
        [req setSortDescriptors: [NSArray arrayWithObject:sortDescription ]];
        
        //BeanAction* v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        NSArray* v_arrayAction = [app.managedObjectContext executeFetchRequest:req error:nil];
        
        if(v_arrayAction.count > 0)
        {
            for (BeanAction* v_BAction in v_arrayAction) {
                if([p_Presentoir.idPointDistribution intValue] == [v_BAction.idPresentoir intValue])
                {
                    if([v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Distri]
                       || [v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Previ])
                    {
                        PEG_BeanPresentoirParution* v_BPP = [[PEG_BeanPresentoirParution alloc] init];
                        v_BPP.IsFirstPres = v_IsFirstPres;
                        v_IsFirstPres = false; //Le prochain ne sera plus le premier
                        v_BPP.Presentoir = p_Presentoir;
                        v_BPP.Parution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_BAction.idParution];
                        
                        NSPredicate *valuePredicate=[NSPredicate predicateWithFormat:@"self.Parution.id == %d && self.Presentoir.idPointDistribution == %d",[v_BAction.idParution intValue],[p_Presentoir.idPointDistribution intValue]];
                        
                        if ([[v_Retour filteredArrayUsingPredicate:valuePredicate] count]==0)
                        {
                            [v_Retour addObject:v_BPP];
                        }
                    }
                }
            }
        }
        
        if(v_Retour.count == 0)
        {
            PEG_BeanPresentoirParution* v_BPP = [[PEG_BeanPresentoirParution alloc] init];
            v_BPP.IsFirstPres = true;
            v_BPP.Presentoir = p_Presentoir;
            v_BPP.Parution = nil;
            [v_Retour addObject:v_BPP];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListPresentoirParutionByPresentoir" andExparams:nil];
    }
    return v_Retour;
}

-(BOOL) IsAlertePhotoOnPresentoir:(BeanPresentoir*)p_Presentoir{
    
    BOOL v_retour=false;
    
    @try
    {
        //Si on est dans le douzieme mois de la photo
        if(p_Presentoir.dateDernierePhoto == nil
           || ([PEG_FTechnical GetNbJourEntreDeuxDatesWithDate1:p_Presentoir.dateDernierePhoto AndDate2:[NSDate date]] > (365 - 30)))
        {
            v_retour = true;
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsAlertePhotoOnPresentoir" andExparams:[NSString stringWithFormat:@"p_Presentoir:%@",p_Presentoir]];
    }
    
    return v_retour;
}

-(BOOL) IsPhotoEnRougeOnPresentoir:(BeanPresentoir*)p_Presentoir{
    
    BOOL v_retour=false;
    
    @try
    {
        //Si on est dans le douzieme mois de la photo
        if(p_Presentoir.dateDernierePhoto == nil
           || ([PEG_FTechnical GetNbJourEntreDeuxDatesWithDate1:p_Presentoir.dateDernierePhoto AndDate2:[NSDate date]] > (365)))
        {
            v_retour = true;
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsAlertePhotoOnPresentoir" andExparams:[NSString stringWithFormat:@"p_Presentoir:%@",p_Presentoir]];
    }
    
    return v_retour;
}

-(BOOL) IsPresentoirActif:(BeanPresentoir*)p_Presentoir{
    
    BOOL v_retour=true;
    
    @try
    {
        //Si on est dans le douzieme mois de la photo
        if(p_Presentoir.flagMAJ == PEG_EnumFlagMAJ_Deleted
           || p_Presentoir.dateAnnule != nil)
        {
            v_retour = false;
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsPresentoirActif" andExparams:[NSString stringWithFormat:@"p_Presentoir:%@",p_Presentoir]];
    }
    
    return v_retour;
}

@end
