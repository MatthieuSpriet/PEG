//
//  PEG_BeanPresentoir.m
//  PEG
//
//  Created by 10_200_11_120 on 01/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanPresentoir.h"
#import "PEG_FTechnical.h"
#import "PEG_BeanTache.h"
#import "PEG_BeanHistoriqueParutionPresentoir.h"
#import "PEGException.h"
#import "PEG_EnumFlagMAJ.h"

@implementation PEG_BeanPresentoir

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {Id :%@,DateAnnule :%@,DateDernierePhoto :%@,Emplacement :%@,NomBatiment :%@,FlagMAJ :%@,FlagPhoto :%i,Guidpresentoir :%@,IdLieu :%@,IdPointDistribution :%@,ListTache :%@,Localisation :%@,PreAnnuleId :%@,TYPE :%@, ListHistoriqueParutionPresentoir : %@}",
            NSStringFromClass([self class]),
            self,
            self.Id,
            self.DateAnnule,
            self.DateDernierePhoto,
            self.Emplacement,
            self.NomBatiment,
            self.FlagMAJ,
            self.FlagPhoto,
            self.Guidpresentoir,
            self.IdLieu,
            self.IdPointDistribution,
            self.ListTache,
            self.Localisation,
            self.PreAnnuleId,
            self.TYPE,
            self.ListHistoriqueParutionPresentoir
            ];
    
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    @try{
        self = [self init];
        if (self)
        {
            self.Id = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"Id"]];
            //if([p_json stringForKeyPath:@"DateAnnule"] != nil)
            self.DateAnnule = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateAnnule"]];
            //if([p_json stringForKeyPath:@"DateDernierePhoto"] != nil)
            self.DateDernierePhoto = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateDernierePhoto"]];
            self.Emplacement = [p_json stringForKeyPath:@"Emplacement"];
            self.NomBatiment = [p_json stringForKeyPath:@"NomBatiment"];
            self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
            self.FlagPhoto = [p_json boolForKeyPath:@"FlagPhoto"];
            self.Guidpresentoir = [p_json stringForKeyPath:@"Guidpresentoir"];
            if([self.Guidpresentoir isEqualToString:@""]) self.Guidpresentoir = @"00000000-0000-0000-0000-000000000000";
            self.IdLieu = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieu"]];
            self.IdPointDistribution = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdPointDistribution"]];
            //self.ListTache = [p_json stringForKeyPath:@"FlagMAJ"];
            
            NSArray* v_ListTache = [p_json arrayForKeyPath:@"ListeTache"];
            self.ListTache = [[NSMutableArray alloc] init];
            for (NSDictionary* v_ItemListTache in v_ListTache)
            {
                PEG_BeanTache* v_BeanTache = [[PEG_BeanTache alloc] initBeanWithJson:v_ItemListTache];
                [self.ListTache addObject:v_BeanTache];
                [v_BeanTache release];
            }
            
            self.Localisation = [p_json stringForKeyPath:@"Localisation"];
            self.PreAnnuleId = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"PreAnnuleId"]];
            
            self.TYPE = [p_json stringForKeyPath:@"TYPE"];
            self.IdParution = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdParution"]];
            
            
            NSArray* v_ListHistoriqueParutionPresentoir = [p_json arrayForKeyPath:@"ListeHistoriqueParutionPresentoir"];
            self.ListHistoriqueParutionPresentoir = [[NSMutableArray alloc] init];
            for (NSDictionary* v_ItemListHistoriqueParutionPresentoir in v_ListHistoriqueParutionPresentoir)
            {
                PEG_BeanHistoriqueParutionPresentoir* v_BeanHistoriqueParutionPresentoir = [[PEG_BeanHistoriqueParutionPresentoir alloc] initBeanWithJson:v_ItemListHistoriqueParutionPresentoir];
                [self.ListHistoriqueParutionPresentoir addObject:v_BeanHistoriqueParutionPresentoir];
                [v_BeanHistoriqueParutionPresentoir release];
            }
            
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanPresentoir.initBeanWithJson Id: %@",self.Id] andExparams:nil];
    }
    return self;
}

-(NSMutableDictionary* ) objectToJson
{
    
    NSMutableArray* v_listBeanTache = [NSMutableArray array];
    for(PEG_BeanTache* v_BeanTache in self.ListTache)
    {
        [v_listBeanTache addObject:[v_BeanTache objectToJson]];
    }
    
    NSMutableArray* v_listBeanHistoriqueParutionPresentoir = [NSMutableArray array];
    for(PEG_BeanHistoriqueParutionPresentoir* v_BeanHistoriqueParutionPresentoir in self.ListHistoriqueParutionPresentoir)
    {
        [v_listBeanHistoriqueParutionPresentoir addObject:[v_BeanHistoriqueParutionPresentoir objectToJson]];
    }
    
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.Id != nil)[v_Return2 setObject:self.Id forKey:@"Id"];
    if ([PEG_FTechnical getJsonFromDate:self.DateAnnule] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateAnnule] forKey:@"DateAnnule"];
    if ([PEG_FTechnical getJsonFromDate:self.DateDernierePhoto] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateDernierePhoto] forKey:@"DateDernierePhoto"];
    if (self.Emplacement != nil)[v_Return2 setObject:self.Emplacement forKey:@"Emplacement"];
    if (self.NomBatiment != nil)[v_Return2 setObject:self.NomBatiment forKey:@"NomBatiment"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
    if ([[NSNumber alloc ] initWithBool:self.FlagPhoto] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.FlagPhoto] forKey:@"FlagPhoto"];
    if (self.Guidpresentoir != nil)[v_Return2 setObject:self.Guidpresentoir forKey:@"Guidpresentoir"];
    if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
    if (self.IdPointDistribution != nil)[v_Return2 setObject:self.IdPointDistribution forKey:@"IdPointDistribution"];
    if (v_listBeanTache != nil)[v_Return2 setObject:v_listBeanTache forKey:@"ListTache"];
    if (self.Localisation != nil)[v_Return2 setObject:self.Localisation forKey:@"Localisation"];
    if (self.PreAnnuleId != nil)[v_Return2 setObject:self.PreAnnuleId forKey:@"PreAnnuleId"];
    if (self.TYPE != nil)[v_Return2 setObject:self.TYPE forKey:@"TYPE"];
    if (self.IdParution != nil)[v_Return2 setObject:self.IdParution forKey:@"IdParution"];
    if (v_listBeanHistoriqueParutionPresentoir != nil)[v_Return2 setObject:v_listBeanHistoriqueParutionPresentoir forKey:@"ListHistoriqueParutionPresentoir"];
    
    return v_Return2;
    
}


-(NSMutableDictionary* ) objectModifiedToJson
{
    NSMutableArray* v_listBeanTache = [NSMutableArray array];
    for(PEG_BeanTache* v_BeanTache in self.ListTache)
    {
        if(![v_BeanTache.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
        {
            [v_listBeanTache addObject:[v_BeanTache objectToJson]];
        }
    }
    
    NSMutableDictionary* v_Return2 =nil;
    
    if(v_listBeanTache.count != 0 || ![self.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        v_Return2 =[[NSMutableDictionary alloc] init];
        if (self.Id != nil)[v_Return2 setObject:self.Id forKey:@"Id"];
        if ([PEG_FTechnical getJsonFromDate:self.DateAnnule] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateAnnule] forKey:@"DateAnnule"];
        if ([PEG_FTechnical getJsonFromDate:self.DateDernierePhoto] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateDernierePhoto] forKey:@"DateDernierePhoto"];
        if (self.Emplacement != nil)[v_Return2 setObject:self.Emplacement forKey:@"Emplacement"];
        if (self.NomBatiment != nil)[v_Return2 setObject:self.NomBatiment forKey:@"NomBatiment"];
        if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
        if ([[NSNumber alloc ] initWithBool:self.FlagPhoto] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.FlagPhoto] forKey:@"FlagPhoto"];
        if (self.Guidpresentoir != nil)[v_Return2 setObject:self.Guidpresentoir forKey:@"Guidpresentoir"];
        if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
        if (self.IdPointDistribution != nil)[v_Return2 setObject:self.IdPointDistribution forKey:@"IdPointDistribution"];
        if (v_listBeanTache != nil)[v_Return2 setObject:v_listBeanTache forKey:@"ListTache"];
        if (self.Localisation != nil)[v_Return2 setObject:self.Localisation forKey:@"Localisation"];
        if (self.PreAnnuleId != nil)[v_Return2 setObject:self.PreAnnuleId forKey:@"PreAnnuleId"];
        if (self.TYPE != nil)[v_Return2 setObject:self.TYPE forKey:@"TYPE"];
        if (self.IdParution != nil)[v_Return2 setObject:self.IdParution forKey:@"IdParution"];
    }
    
    return v_Return2;
    
}

@end
