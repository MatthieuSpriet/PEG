//
//  PEG_TourneeADXServices.m
//  PEG
//
//  Created by Horsmedia3 on 19/05/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

// pm 140526: it was an empty place holder. I assume I should use it
// modeled after PEG_TourneeServices.m

#import "PEG_TourneeADXServices.h"
#import "PEGException.h"
#import "PEGAppDelegate.h"
#import "PEG_FTechnical.h"
#import "BeanLieuPassageADX.h"
#import "BeanActionADX.h"
#import "PEG_EnuActionMobilite.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_BeanPresentoirParutionADX.h"

@implementation PEG_TourneeADXServices

-(BeanTourneeADX*) GetTourneeByIdTournee:(NSNumber*)p_IdTournee
{
    BeanTourneeADX* v_retour = nil;
    @try
    {
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanTourneeADX" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idTournee == %@",p_IdTournee]];
        NSError* v_error;
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:&v_error] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetTourneeByIdTournee" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
    }
    return v_retour;
}


- (NSArray*) GetTourneeBetweenDateDebut:(NSDate*)p_DtDebut andDateFin:(NSDate*)p_DateFin
{
    NSArray* v_retour = [[NSMutableArray alloc] init];
    @try
    {
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanTourneeADX" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"dtDebut >= %@ AND dtDebut <= %@ ",[PEG_FTechnical GetDateYYYYMMDDFromDate:p_DtDebut],[[PEG_FTechnical GetDateYYYYMMDDFromDate:p_DateFin] dateByAddingTimeInterval:((3600*24)-1) ]]];
        NSError* v_error;
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:&v_error];
        if(v_ArrayBean != nil)
        {
            v_retour = v_ArrayBean;
        }
        else{
            DLog("%@",v_error);
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetTourneeBetweenDateDebutandDateFin" andExparams:[NSString stringWithFormat:@"p_DtDebut:%@, p_DateFin:%@",p_DtDebut,p_DateFin]];
    }
    return v_retour;
}


- (NSNumber*) GetNbTacheByTournee:(NSNumber*)p_IdTournee
{
    return @0;  // pas affiché si à zéro
}


-(NSArray*) GetListeLieuPassageByTournee:(NSNumber*)p_IdTournee
{
    NSArray* v_retour = [[NSArray alloc] init];
    @try
    {
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassageADX" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idTournee == %@",p_IdTournee]];
        NSError* v_error;
        NSArray* v_ArrayBean = [app.managedObjectContext executeFetchRequest:req error:&v_error];
        if (v_ArrayBean != nil)
        {
            // DLog("GetListeLieuPassageByTournee v_ArrayBean: %@",v_ArrayBean);
            NSSortDescriptor *positionSort = [NSSortDescriptor sortDescriptorWithKey:@"nbOrdrePassage" ascending:YES];
            v_retour = [v_ArrayBean sortedArrayUsingDescriptors:[NSArray arrayWithObject:positionSort]];
        }
        else
        {
            DLog("%@",v_error);
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListeLieuPassageByTournee" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
    }
    return v_retour;
}

-(BeanActionADX*) GetBeanActionADXByIdParution:(NSNumber *)p_idParution
{
    BeanActionADX* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanActionADX" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idParution == %@",p_idParution]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanActionADXByIdParution" andExparams:[NSString stringWithFormat:@"p_idParution:%@",p_idParution]];
    }
    return v_retour;
}


- (NSString*) GetLibelleMagazinesForDesignByTournee:(BeanTourneeADX*)P_BeanTournee andNbCarTrunc:(int)p_NbCarTrunc andEntete:(BOOL)p_Entete
{
    NSString* v_retour = @"";
    int v_traceIdPresentoir = 0;
    @try
    {
        int v_NbPres = 0;
        NSMutableDictionary* p_Dico = [[NSMutableDictionary alloc] init];
        for(BeanLieuPassageADX* v_LP in P_BeanTournee.listLieuPassageADX)
        {
            for (BeanActionADX* v_BA in v_LP.listActionADX) {
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
        }
        if(p_Entete)
        {
            v_retour =[NSString stringWithFormat:@"%@ - %i pres prévis.\n",[PEG_FTechnical GetLibelleDDMMYYYYFromDateString:P_BeanTournee.dtDebut],v_NbPres];
        }
        for (NSString* v_item in [p_Dico allKeys]) {
            BeanActionADX* v_BeanActionADX = [[PEG_FMobilitePegase CreateTourneeADX] GetBeanActionADXByIdParution:[[NSNumber alloc] initWithInt:[v_item intValue]]];
            if(v_BeanActionADX != nil)
            {
                NSString* v_libEdition = v_BeanActionADX.libEdition;
                if(v_libEdition.length > p_NbCarTrunc)
                {
                    v_libEdition = [v_libEdition substringToIndex:p_NbCarTrunc];
                }
                v_retour = [NSString stringWithFormat:@"%@ %@ %@ex",v_retour,v_libEdition,[p_Dico valueForKey:v_item]];
            }
        }
    }
    @catch(NSException* p_exception)
    {
        v_retour = @"erreur...";
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans GetLibelleMagazinesForDesignByTournee" andExparams:[NSString stringWithFormat:@"v_traceIdPresentoir:%i",v_traceIdPresentoir]];
    }
    return v_retour;
}

-(NSMutableArray*) GetListPresentoirParutionByLieuPassageADX:(BeanLieuPassageADX*)p_Lieu
{
    NSMutableArray* v_Retour = [[NSMutableArray alloc] init];
    @try
    {
        //for (BeanActionADX* v_BAADX in p_Lieu.listActionADX) {
            //eanLieuPassage* v_BLP = [self GetBeanLieuPassageByIdLieu:p_Lieu.idLieu andIdTournee:p_IdTournee];
            
            //NSArray* v_Actions = [[PEG_FMobilitePegase CreateActionPresentoir] GetListBeanActionByIdLieuPassage:v_BLP.idLieuPassage];
            NSSet* v_Actions = p_Lieu.listActionADX;
            if(v_Actions.count > 0)
            {
                for (BeanActionADX* v_BAction in v_Actions) {
                    //if([v_BP.idPointDistribution intValue] == [v_BAction.idPresentoir intValue])
                    //{
                        if([v_BAction.codeAction isEqualToString:PEG_EnuActionMobilite_Previ])
                        {
                            PEG_BeanPresentoirParutionADX* v_BPP = [[PEG_BeanPresentoirParutionADX alloc] init];
                            v_BPP.idEditionRef = v_BAction.idEditionRef;
                            v_BPP.idLieu = v_BAction.idLieu;
                            v_BPP.idParution = v_BAction.idParution;
                            v_BPP.idParutionRef = v_BAction.idParutionRef;
                            v_BPP.idParutionRefPrec = v_BAction.idParutionRefPrec;
                            v_BPP.IdPresentoir = v_BAction.idPresentoir;
                            v_BPP.libEdition = v_BAction.libEdition;
                            v_BPP.codeTypePresentoir = v_BAction.codeTypePresentoir;
                            [v_Retour addObject:v_BPP];
                        }
                    //}
                }
            }

        //}
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetListPresentoirParutionByLieu" andExparams:nil];
    }
    return v_Retour;
}

-(NSNumber*) GetQteDistriByPresentoir:(NSNumber*)p_IdPresentoir andParutionRef:(NSNumber*)p_IdParutionRef andBeanLieuPassage:(BeanLieuPassageADX*)p_LieuPassage
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (BeanActionADX* v_Item in p_LieuPassage.listActionADX)
        {
            if([v_Item.idPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_Item.idParutionRef isEqualToNumber:p_IdParutionRef]
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
-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParutionRef:(NSNumber*)p_IdParutionRef andBeanLieuPassage:(BeanLieuPassageADX*)p_LieuPassage
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (BeanActionADX* v_Item in p_LieuPassage.listActionADX)
        {
            if([v_Item.idParutionRef isEqualToNumber:p_IdParutionRef])
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

-(NSNumber*) GetQteRetourByPresentoir:(NSNumber*)p_IdPresentoir andParutionRef:(NSNumber*)p_IdParutionRef andBeanLieuPassage:(BeanLieuPassageADX*)p_LieuPassage
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (BeanActionADX* v_Item in p_LieuPassage.listActionADX)
        {
            if([v_Item.idPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_Item.idParutionRef isEqualToNumber:p_IdParutionRef]
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

-(BeanLieuPassageADX*) GetBeanLieuPassageADXById:(NSNumber *)p_idLieuPassage
{
    BeanLieuPassageADX* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassageADX" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idLieuPassage == %@",p_idLieuPassage]];
        
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanLieuPassageADXById" andExparams:[NSString stringWithFormat:@"p_idLieuPassage:%@",p_idLieuPassage]];
    }
    return v_retour;
}

-(BOOL) IsCompteRenduTourneeDebuteeByIdTournee:(NSNumber*)p_IdTournee
{
    bool v_retour = false;
    @try
    {
        bool v_isActionSaisie = false;
        BeanTourneeADX* v_Tournee = [[PEG_FMobilitePegase CreateTourneeADX] GetTourneeByIdTournee:p_IdTournee];
        for (BeanLieuPassageADX* p_LieuPassage in v_Tournee.listLieuPassageADX)
        {
            v_isActionSaisie = false;
            for (BeanActionADX* v_Item in p_LieuPassage.listActionADX)
            {
                if( ![v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Previ]
                   && (
                   ([v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Distri]
                        && ![v_Item.quantiteDistribuee isEqualToNumber:[[NSNumber alloc]initWithInt:0]]
                    )
                   || ([v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Retour]
                       && ![v_Item.quantiteRecuperee isEqualToNumber:[[NSNumber alloc]initWithInt:0]])
                   ))
                {
                    v_isActionSaisie = true;
                }
            }
            //Si au moins une action saisie sur au moins un lieu, c'est pas debuté
            if(v_isActionSaisie)
            {
                v_retour = true;
                break;
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsCompteRenduTourneeTermineeByIdTournee" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
    }
    return v_retour;
}

//Terminée correspond à au moins un réassort sur chaque lieu de passage presentoir
// Simplifié en au moins autant de distri que de prévi
-(BOOL) IsCompteRenduTourneeTermineeByIdTournee:(NSNumber*)p_IdTournee
{
    bool v_retour = true;
    @try
    {
        int v_NbPrevi = 0;
        int v_NbDistri = 0;
        BeanTourneeADX* v_Tournee = [[PEG_FMobilitePegase CreateTourneeADX] GetTourneeByIdTournee:p_IdTournee];
        for (BeanLieuPassageADX* p_LieuPassage in v_Tournee.listLieuPassageADX)
        {
            for (BeanActionADX* v_Item in p_LieuPassage.listActionADX)
            {
                if([v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Distri])
                {
                    v_NbDistri++;
                }
                else if([v_Item.codeAction isEqualToString:PEG_EnuActionMobilite_Previ])
                {
                    v_NbPrevi++;
                }
            }
            //Si pas d'action sur au moins un lieu, c'est pas terminé
            if(v_NbDistri < v_NbPrevi)
            {
                v_retour = false;
                break;
            }
        }
        
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsCompteRenduTourneeTermineeByIdTournee" andExparams:[NSString stringWithFormat:@"p_IdTournee:%@",p_IdTournee]];
    }
    return v_retour;
}

@end
