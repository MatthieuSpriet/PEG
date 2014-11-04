//
//  PEG_BeanMobilitePegase.m
//  PEG
//
//  Created by 10_200_11_120 on 07/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanMobilitePegase.h"
#import "PEG_GetBeanMobilitePegaseRequest.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEGException.h"
#import "PEG_BeanLieu.h"

@implementation PEG_BeanMobilitePegase

#pragma mark Fonctions de base
-(void) dealloc
{
    [NSException raise:@"This method couldn't be call !!!!" format:@"Impossible to call a dealloc of singleton",nil];
    [super dealloc];
}

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {ListSuiviKMUtilisateur :%@} , {ListTournee :%@} , {ListLieu :%@}, {ListConcurents :%@}, {ListCommune :%@}",
			NSStringFromClass([self class]),
			self,
            self.ListSuiviKMUtilisateur,
            self.ListTournee,
            self.ListLieu,
            self.ListConcurents,
            self.ListCommune];
}



#pragma mark Singleton
static PEG_BeanMobilitePegase *sharedBeanMobilitePegaseInstance = nil;

+ (PEG_BeanMobilitePegase *)sharedInstance
{
	if (sharedBeanMobilitePegaseInstance == nil)
	{
        PEG_BeanMobilitePegase* v_Bean = nil;
        //On récupère les infos dans la mémoire s'il existe
        v_Bean = [[PEG_FMobilitePegase CreateMobilitePegaseService] GetBeanMobilitePegaseFromFile];
        if(v_Bean != nil)
        {
            sharedBeanMobilitePegaseInstance = v_Bean;
        }
        else
        {
            sharedBeanMobilitePegaseInstance = [[super allocWithZone:NULL] init];
        }
	}
    //DLog(@"=>PEG_BeanMobilitePegase: %@ ",sharedBeanMobilitePegaseInstance.description);
	return sharedBeanMobilitePegaseInstance;
}

-(NSMutableDictionary* ) objectToJson
{
    
    
    NSMutableArray* v_ListSuiviKMUtilisateur = [NSMutableArray array];
    for(PEG_BeanSuiviKMUtilisateur* v_BeanSuiviKMUtilisateur in self.ListSuiviKMUtilisateur)
    {
        [v_ListSuiviKMUtilisateur addObject:[v_BeanSuiviKMUtilisateur objectToJson]];
    }
    NSMutableArray* v_ListBeanTournee = [NSMutableArray array];
    for(PEG_BeanTournee* v_BeanTournee in self.ListTournee)
    {
        [v_ListBeanTournee addObject:[v_BeanTournee objectToJson]];
    }
    NSMutableArray* v_ListBeanLieu = [NSMutableArray array];
    for(PEG_BeanLieu* v_BeanLieu in self.ListLieu)
    {
        [v_ListBeanLieu addObject:[v_BeanLieu objectToJson]];
    }
    
    NSMutableArray* v_ListBeanConcurents = [NSMutableArray array];
    for(PEG_BeanConcurents* v_BeanConcurents in self.ListConcurents)
    {
        [v_ListBeanConcurents addObject:[v_BeanConcurents objectToJson]];
    }
    
    NSMutableArray* v_ListBeanCPCommune= [NSMutableArray array];
    for(PEG_BeanCPCommune* v_BeanCPCommune in self.ListCommune)
    {
        [v_ListBeanCPCommune addObject:[v_BeanCPCommune objectToJson]];
    }
    
    NSMutableArray* v_ListBeanParution= [NSMutableArray array];
    for(PEG_BeanParution* v_BeanParution in self.ListParution)
    {
        [v_ListBeanParution addObject:[v_BeanParution objectToJson]];
    }
    
    NSMutableArray* v_ListBeanChoix= [NSMutableArray array];
    for(PEG_BeanChoix* v_BeanChoix in self.ListChoix)
    {
        [v_ListBeanChoix addObject:[v_BeanChoix objectToJson]];
    }
    
    /*NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"",@"Msg",
     @"",@"Type",
     v_ListSuiviKMUtilisateur,@"ListSuiviKMUtilisateur",
     v_ListBeanTournee,@"ListTournee",
     v_ListBeanLieu,@"ListLieu",
     v_ListBeanConcurents,@"ListConcurents",
     v_ListBeanCPCommune,@"ListCommune",
     v_ListBeanParution,@"ListParution",
     v_ListBeanChoix,@"ListChoix",
     nil];*/
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (v_ListSuiviKMUtilisateur != nil)[v_Return2 setObject:v_ListSuiviKMUtilisateur forKey:@"ListSuiviKMUtilisateur"];
    if (v_ListBeanTournee != nil)[v_Return2 setObject:v_ListBeanTournee forKey:@"ListTournee"];
    if (v_ListBeanLieu != nil)[v_Return2 setObject:v_ListBeanLieu forKey:@"ListLieu"];
    if (v_ListBeanConcurents != nil)[v_Return2 setObject:v_ListBeanConcurents forKey:@"ListConcurents"];
    if (v_ListBeanCPCommune != nil)[v_Return2 setObject:v_ListBeanCPCommune forKey:@"ListCommune"];
    if (v_ListBeanParution != nil)[v_Return2 setObject:v_ListBeanParution forKey:@"ListParution"];
    if (v_ListBeanChoix != nil)[v_Return2 setObject:v_ListBeanChoix forKey:@"ListChoix"];
    
    return v_Return2;
}

-(NSMutableDictionary* ) objectModifiedToJson
{
    NSMutableDictionary* v_Return2 =nil;
    @try{
        NSMutableArray* v_ListSuiviKMUtilisateur = [NSMutableArray array];
        for(PEG_BeanSuiviKMUtilisateur* v_BeanSuiviKMUtilisateur in self.ListSuiviKMUtilisateur)
        {
            if(![v_BeanSuiviKMUtilisateur.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
            {
                [v_ListSuiviKMUtilisateur addObject:[v_BeanSuiviKMUtilisateur objectToJson]];
            }
        }
        
        NSMutableArray* v_ListBeanTournee = [NSMutableArray array];
        for(PEG_BeanTournee* v_BeanTournee in self.ListTournee)
        {
            NSMutableDictionary* v_JsonTmp = [v_BeanTournee objectModifiedToJson];
            if(v_JsonTmp != nil)
            {
                [v_ListBeanTournee addObject:v_JsonTmp];
            }
        }
        NSMutableArray* v_ListBeanLieu = [NSMutableArray array];
        for(PEG_BeanLieu* v_BeanLieu in self.ListLieu)
        {
            NSMutableDictionary* v_JsonTmp = [v_BeanLieu objectModifiedToJson];
            if(v_JsonTmp != nil)
            {
                [v_ListBeanLieu addObject:v_JsonTmp];
            }
        }
        
        
        if(v_ListSuiviKMUtilisateur.count != 0 || v_ListBeanTournee.count != 0 || v_ListBeanLieu.count != 0 )
        {
            v_Return2 =[[NSMutableDictionary alloc] init];
            if (v_ListSuiviKMUtilisateur.count != 0)[v_Return2 setObject:v_ListSuiviKMUtilisateur forKey:@"ListSuiviKMUtilisateur"];
            if (v_ListBeanTournee.count != 0)[v_Return2 setObject:v_ListBeanTournee forKey:@"ListTournee"];
            if (v_ListBeanLieu.count != 0)[v_Return2 setObject:v_ListBeanLieu forKey:@"ListLieu"];
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans SaveBeanMobiliteModifiedPegaseInFile" andExparams:nil];
    }
    
    return v_Return2;
}

@end
