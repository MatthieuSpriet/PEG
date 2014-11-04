//
//  PEG_BeanTournee.m
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanTournee.h"
#import "PEG_FTechnical.h"
#import "PEG_BeanLieuPassage.h"
#import "PEGException.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEG_FMobilitePegase.h"
#import "PEGAppDelegate.h"
#import "BeanTournee.h"

@implementation PEG_BeanTournee


-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdTournee :%@, LiTournee: %@, CoTourneeType :%@, PremiereDistribution : %i, DtDebutReelle : %@, IdTourneeRef : %@, LiCommentaire : %@, FlagMAJ : %@, ListeLieuPassage %@}",
            NSStringFromClass([self class]),
            self,
            self.IdTournee,
            self.LiTournee,
            self.CoTourneeType,
            self.PremiereDistribution,
            self.DtDebutReelle,
            self.IdTourneeRef,
            self.LiCommentaire,
            self.FlagMAJ,
            self.ListLieuPassage];
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    @try{
        self = [self init];
        if (self)
        {
            self.IdTournee = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdTournee"]];
            self.LiTournee = [p_json stringForKeyPath:@"LiTournee"];
            self.CoTourneeType = [p_json stringForKeyPath:@"CoTourneeType"];
            self.PremiereDistribution = [p_json boolForKeyPath:@"PremiereDistribution"];
            self.DtDebutReelle = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DtDebutReelle"]];
            self.IdTourneeRef = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdTourneeRef"]];
            self.LiCommentaire = [p_json stringForKeyPath:@"LiCommentaire"];
            self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
            
            self.ListLieuPassage =[[NSMutableArray alloc] init];
            NSArray* v_ListLieuPassage = [p_json arrayForKeyPath:@"ListLieuPassage"];
            for (NSDictionary* v_ItemLieuPassage in v_ListLieuPassage)
            {
                PEG_BeanLieuPassage* v_BeanLieuPassage = [[PEG_BeanLieuPassage alloc] initBeanWithJson:v_ItemLieuPassage];
                [self.ListLieuPassage addObject:v_BeanLieuPassage];
                [v_BeanLieuPassage release];
            }

        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanTournee.initBeanWithJson IdTournee: %@",self.IdTournee] andExparams:nil];
    }
    return self;
}
-(BeanTournee*) initCDWithJson :(NSDictionary*)p_json
{
    BeanTournee *v_Bean =nil;
    @try{
       
            //On n'insert que si la ligne n'existe pas
            PEGAppDelegate *app = [UIApplication sharedApplication].delegate;
            
            //On vérifie si la ligne existe déjà
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            [req setEntity:[NSEntityDescription entityForName:@"BeanTournee" inManagedObjectContext:app.managedObjectContext]];
            NSString* v_IdTournee = [p_json stringForKeyPath:@"IdTournee"];
            [req setPredicate:[NSPredicate predicateWithFormat:@"idTournee == %@",v_IdTournee]];
            
           v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
            if(v_Bean != nil)
            {
                //La ligne existe déjà on ne fait rien
            }
            else
            {
                v_Bean = (BeanTournee *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanTournee" inManagedObjectContext:app.managedObjectContext];
                [v_Bean setIdTournee:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdTournee"]]];
                [v_Bean setLiTournee:[p_json stringForKeyPath:@"LiTournee"]];
                [v_Bean setCoTourneeType:[p_json stringForKeyPath:@"CoTourneeType"]];
                [v_Bean setPremiereDistribution:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"PremiereDistribution"] ]];
                [v_Bean setDtDebutReelle:[PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DtDebutReelle"]]];
                [v_Bean setIdTourneeRef:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdTourneeRef"]]];
                [v_Bean setLiCommentaire:[p_json stringForKeyPath:@"LiCommentaire"]];
                [v_Bean setFlagMAJ:[p_json stringForKeyPath:@"FlagMAJ"]];
                
                NSArray* v_ListLieuPassage = [p_json arrayForKeyPath:@"ListLieuPassage"];
                for (NSDictionary* v_ItemLieuPassage in v_ListLieuPassage)
                {
                    PEG_BeanLieuPassage* v_BLP = [PEG_BeanLieuPassage alloc];
                    BeanLieuPassage* v_BeanLieuPassage = [v_BLP initCDWithJson:v_ItemLieuPassage];
                    [v_Bean addListLieuPassageObject:v_BeanLieuPassage];
                    [v_BLP release];
                }
            }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanTournee.initBeanWithJson IdTournee: %@",self.IdTournee] andExparams:nil];
    }
    return v_Bean;
}

-(NSMutableDictionary* ) objectToJson
{
    
    NSMutableArray* v_ListLieuPassage = [NSMutableArray array];
    for(PEG_BeanLieuPassage* v_BeanLieuPassage in self.ListLieuPassage)
    {
        [v_ListLieuPassage addObject:[v_BeanLieuPassage objectToJson]];
    }
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.IdTournee != nil)[v_Return2 setObject:self.IdTournee forKey:@"IdTournee"];
    if (self.LiTournee != nil)[v_Return2 setObject:self.LiTournee forKey:@"LiTournee"];
    if (self.CoTourneeType != nil)[v_Return2 setObject:self.CoTourneeType forKey:@"CoTourneeType"];
    if ([[NSNumber alloc ] initWithBool:self.PremiereDistribution] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.PremiereDistribution] forKey:@"PremiereDistribution"];
    if ([PEG_FTechnical getJsonFromDate:self.DtDebutReelle] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DtDebutReelle] forKey:@"DtDebutReelle"];
    if (self.IdTourneeRef != nil)[v_Return2 setObject:self.IdTourneeRef forKey:@"IdTourneeRef"];
    if (self.LiCommentaire != nil)[v_Return2 setObject:self.LiCommentaire forKey:@"LiCommentaire"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
    if (v_ListLieuPassage != nil)[v_Return2 setObject:v_ListLieuPassage forKey:@"ListLieuPassage"];
    
    
    return v_Return2;
}

-(NSMutableDictionary* ) objectModifiedToJson
{
    NSMutableArray* v_ListLieuPassage = [NSMutableArray array];
    for(PEG_BeanLieuPassage* v_BeanLieuPassage in self.ListLieuPassage)
    {
        NSMutableDictionary* v_JsonTmp = [v_BeanLieuPassage objectModifiedToJson];
        if(v_JsonTmp != nil)
        {
            [v_ListLieuPassage addObject:v_JsonTmp];
        }
    }
    
    NSMutableDictionary* v_Return2 =nil;
    
    if(v_ListLieuPassage.count != 0 || ![self.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        v_Return2 =[[NSMutableDictionary alloc] init];
        if (self.IdTournee != nil)[v_Return2 setObject:self.IdTournee forKey:@"IdTournee"];
        if (self.LiTournee != nil)[v_Return2 setObject:self.LiTournee forKey:@"LiTournee"];
        if (self.CoTourneeType != nil)[v_Return2 setObject:self.CoTourneeType forKey:@"CoTourneeType"];
        if ([[NSNumber alloc ] initWithBool:self.PremiereDistribution] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.PremiereDistribution] forKey:@"PremiereDistribution"];
        if ([PEG_FTechnical getJsonFromDate:self.DtDebutReelle] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DtDebutReelle] forKey:@"DtDebutReelle"];
        if (self.IdTourneeRef != nil)[v_Return2 setObject:self.IdTourneeRef forKey:@"IdTourneeRef"];
        if (self.LiCommentaire != nil)[v_Return2 setObject:self.LiCommentaire forKey:@"LiCommentaire"];
        if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
        if (v_ListLieuPassage != nil)[v_Return2 setObject:v_ListLieuPassage forKey:@"ListLieuPassage"];
    }
    
    return v_Return2;
}

@end
