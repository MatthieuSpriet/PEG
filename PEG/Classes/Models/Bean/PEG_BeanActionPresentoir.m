//
//  PEG_BeanActionPresentoir.m
//  PEG
//
//  Created by 10_200_11_120 on 11/09/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanActionPresentoir.h"
#import "PEG_FTechnical.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEG_EnuActionMobilite.h"
#import "PEGAppDelegate.h"
#import "PEGException.h"

@implementation PEG_BeanActionPresentoir

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdPresentoir :%@,IdParution :%@,ActionType :%@,TypeActionCptRendu :%@,QuantitePrevue :%@,QuantiteDistribuee :%@,QuantiteRecuperee :%@,CheminPhoto :%@,ValeurTexte :%@,DateCreation :%@,CoordX :%@,CoordY :%@,CoordGPSFiable :%c,FlagMAJ :%@}",
            NSStringFromClass([self class]),
            self,
            self.IdPresentoir,
            self.IdParution,
            self.ActionType,
            self.TypeActionCptRendu,
            self.QuantitePrevue,
            self.QuantiteDistribuee,
            self.QuantiteRecuperee,
            self.CheminPhoto,
            self.ValeurTexte,
            self.DateCreation,
            self.CoordX,
            self.CoordY,
            self.CoordGPSFiable,
            self.FlagMAJ
            ];
    
}



-(id) initBeanWithJson :(NSDictionary*)p_json
{
    
    @try{
        self = [self init];
        if (self)
        {
            
            //if([p_json objectForKey:@"CP"] != nil )
            self.IdPresentoir= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdPresentoir"]];
            self.IdParution= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdParution"]];
            self.ActionType= [p_json stringForKeyPath:@"ActionType"];
            self.TypeActionCptRendu= [p_json stringForKeyPath:@"TypeActionCptRendu"];
            self.QuantitePrevue= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"QuantitePrevue"]];
            self.QuantiteDistribuee= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"QuantiteDistribuee"]];
            self.CheminPhoto= [p_json stringForKeyPath:@"CheminPhoto"];
            self.ValeurTexte= [p_json stringForKeyPath:@"ValeurTexte"];
            self.DateCreation = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateCreation"]];
            self.CoordX= [[NSNumber alloc]initWithDouble:[[p_json valueForKeyPath:@"CoordX"] doubleValue]];
            self.CoordY= [[NSNumber alloc]initWithDouble:[[p_json valueForKeyPath:@"CoordY"] doubleValue]];
            self.CoordGPSFiable= [p_json boolForKeyPath:@"CoordGPSFiable"];
            self.FlagMAJ= [p_json stringForKeyPath:@"FlagMAJ"];
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.initBeanWithJson %@",NSStringFromClass([self class]),self] andExparams:nil];
    }
    return self;
    
}

-(BeanActionPresentoir*) initCDWithJson :(NSDictionary*)p_json
{
    BeanActionPresentoir *v_Bean =nil;
    @try{
        
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = [UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanActionPresentoir" inManagedObjectContext:app.managedObjectContext]];
        //NSString* v_IdLieuPassage = [p_json stringForKeyPath:@"IdLieuPassage"];
        //[req setPredicate:[NSPredicate predicateWithFormat:@"idLieuPassage == %@",v_IdLieuPassage]];
        
        v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        if(v_Bean != nil)
        {
            //La ligne existe déjà on ne fait rien
        }
        else
        {
            v_Bean = (BeanActionPresentoir *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanActionPresentoir" inManagedObjectContext:app.managedObjectContext];
            [v_Bean setIdPresentoir:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdPresentoir"]]];
            [v_Bean setIdParution:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdParution"]]];
            [v_Bean setActionType:[p_json stringForKeyPath:@"ActionType"]];
            [v_Bean setTypeActionCptRendu:[p_json stringForKeyPath:@"TypeActionCptRendu"]];
            [v_Bean setQuantitePrevue:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"QuantitePrevue"]]];
            [v_Bean setQuantiteDistribuee:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"QuantiteDistribuee"]]];
            [v_Bean setCheminPhoto:[p_json stringForKeyPath:@"CheminPhoto"]];
            [v_Bean setValeurTexte:[p_json stringForKeyPath:@"ValeurTexte"]];
            [v_Bean setDateCreation:[PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateCreation"]]];
            [v_Bean setCoordX:[[NSNumber alloc]initWithDouble:[[p_json valueForKeyPath:@"CoordX"] doubleValue]]];
            [v_Bean setCoordY:[[NSNumber alloc]initWithDouble:[[p_json valueForKeyPath:@"CoordY"] doubleValue]]];
            [v_Bean setCoordGPSFiable:[[NSNumber alloc] initWithInt:[p_json integerForKeyPath:@"CoordGPSFiable"]]];
            [v_Bean setFlagMAJ:[p_json stringForKeyPath:@"FlagMAJ"]];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanActionPresentoir.initBeanWithJson IdPresentoir: %i, IdParution: %i",[p_json integerForKeyPath:@"IdPresentoir"],[p_json integerForKeyPath:@"IdParution"]] andExparams:nil];
    }
    return v_Bean;
}

/*-(id) initBeanForNewQteDistribuee:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution
{
    @try{
        self = [self init];
        if (self)
        {
            self.IdPresentoir= p_IdPresentoir;
            self.IdParution= p_IdParution;
            self.TypeActionCptRendu= PEG_EnumTypeActionTournee_Journal_Livrer;
            self.ActionType = PEG_EnumTypeActionTournee_Journal_Livrer;
            self.QuantiteDistribuee= p_Qte;
            //TODO recup les coordonnées
            //self.CoordX= ;
            //self.CoordY= ;
            //self.CoordGPSFiable= ;
            self.DateCreation = [NSDate date];
            self.FlagMAJ= PEG_EnumFlagMAJ_Added;
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.initBeanWithJson %@",NSStringFromClass([self class]),self] andExparams:nil];
    }
    return self;
}

-(id) initBeanForNewQteRetour:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution
{
    @try{
        self = [self init];
        if (self)
        {
            self.IdPresentoir= p_IdPresentoir;
            self.IdParution= p_IdParution;
            self.TypeActionCptRendu= PEG_EnumTypeActionTournee_Journal_RecupererBonEtat;
            self.ActionType = PEG_EnumTypeActionTournee_Journal_RecupererBonEtat;
            self.QuantiteDistribuee= p_Qte;
            //TODO recup les coordonnées
            //self.CoordX= ;
            //self.CoordY= ;
            //self.CoordGPSFiable= ;
            self.DateCreation = [NSDate date];
            self.FlagMAJ= PEG_EnumFlagMAJ_Added;
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"%@.initBeanWithJson %@",NSStringFromClass([self class]),self] andExparams:nil];
    }
    return self;
}*/

-(NSMutableDictionary* ) objectToJson
{

    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.IdPresentoir != nil)[v_Return2 setObject:self.IdPresentoir forKey:@"IdPresentoir"];
    if (self.IdParution != nil)[v_Return2 setObject:self.IdParution forKey:@"IdParution"];
    if (self.ActionType != nil)[v_Return2 setObject:self.ActionType forKey:@"ActionType"];
    if (self.TypeActionCptRendu != nil)[v_Return2 setObject:self.TypeActionCptRendu forKey:@"TypeActionCptRendu"];
    if (self.QuantitePrevue != nil)[v_Return2 setObject:self.QuantitePrevue forKey:@"QuantitePrevue"];
    if (self.QuantiteDistribuee != nil)[v_Return2 setObject:self.QuantiteDistribuee forKey:@"QuantiteDistribuee"];
    if (self.QuantiteRecuperee != nil)[v_Return2 setObject:self.QuantiteRecuperee forKey:@"QuantiteRecuperee"];
    if (self.CheminPhoto != nil)[v_Return2 setObject:self.CheminPhoto forKey:@"CheminPhoto"];
    if (self.ValeurTexte != nil)[v_Return2 setObject:self.ValeurTexte forKey:@"ValeurTexte"];
    if ([PEG_FTechnical getJsonFromDate:self.DateCreation] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateCreation] forKey:@"DateCreation"];
    if (self.CoordX != nil)[v_Return2 setObject:self.CoordX forKey:@"CoordX"];
    if (self.CoordY != nil)[v_Return2 setObject:self.CoordY forKey:@"CoordY"];
    if ([[NSNumber alloc ] initWithBool:self.CoordGPSFiable] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.CoordGPSFiable] forKey:@"CoordGPSFiable"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
    
    return v_Return2;
    
}


@end
