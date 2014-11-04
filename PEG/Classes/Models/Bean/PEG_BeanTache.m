//
//  PEG_BeanTache.m
//  PEG
//
//  Created by 10_200_11_120 on 01/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanTache.h"
#import "PEG_FTechnical.h"

@implementation PEG_BeanTache


-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdTache :%@,IdLieu :%@,Id :%@,Date :%@,Libelle :%@,Valeur :%@,CodeCR :%@,CodeAction :%@,FlagMAJ :%@}",
            NSStringFromClass([self class]),
            self,
            self.IdTache,
            self.IdLieu,
            self.Id,
            self.Date,
            self.Libelle,
            self.Valeur,
            self.CodeCR,
            self.CodeAction,
            self.FlagMAJ];
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    self = [self init];
    if (self)
    {
        self.IdTache = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdTache"]];
        self.IdLieu = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieu"]];
        self.Id = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"Id"]];
        self.Date = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"Date"]];
        self.Libelle = [p_json stringForKeyPath:@"Libelle"];
        self.Valeur = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"Valeur"]];
        self.CodeCR = [p_json stringForKeyPath:@"CodeCR"];
        self.CodeAction = [p_json stringForKeyPath:@"CodeAction"];
        self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
    }
    
    return self;
}

-(NSMutableDictionary* ) objectToJson
{
       
    
    /*NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.IdTache,@"IdTache",
                                     self.IdLieu,@"IdLieu",
                                     self.Id,@"Id",
                                     [PEG_FTechnical getJsonFromDate:self.Date],@"Date",
                                     self.Libelle,@"Libelle",
                                     self.Valeur,@"Valeur",
                                     self.CodeCR,@"CodeCR",
                                     self.CodeAction,@"CodeAction",
                                     self.FlagMAJ,@"FlagMAJ",
                                     nil];*/
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.IdTache != nil)[v_Return2 setObject:self.IdTache forKey:@"IdTache"];
    if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
    if (self.Id != nil)[v_Return2 setObject:self.Id forKey:@"Id"];
    if ([PEG_FTechnical getJsonFromDate:self.Date] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.Date] forKey:@"Date"];
    if (self.Libelle != nil)[v_Return2 setObject:self.Libelle forKey:@"Libelle"];
    if (self.Valeur != nil)[v_Return2 setObject:self.Valeur forKey:@"Valeur"];
    if (self.CodeCR != nil)[v_Return2 setObject:self.CodeCR forKey:@"CodeCR"];
    if (self.CodeAction != nil)[v_Return2 setObject:self.CodeAction forKey:@"CodeAction"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
    
    return v_Return2;
    
}

@end
