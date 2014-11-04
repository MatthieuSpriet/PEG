//
//  PEG_BeanHoraire.m
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanHoraire.h"
#import "PEG_FTechnical.h"
#import "PEGException.h"

@implementation PEG_BeanHoraire

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdLieu :%@,Jour:%@ ,AMDebut :%@,PMDebut :%@,AMFin :%@,PMFin :%@,Livre24 :%i,FlagMAJ :%@}",
            NSStringFromClass([self class]),
            self,
            self.IdLieu,
            self.Jour,
            self.AMDebut,
            self.PMDebut,
            self.AMFin,
            self.PMFin,
            self.Livre24,
            self.FlagMAJ
            ];
    
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    @try{
        self = [self init];
        if (self)
        {
            self.IdLieu = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieu"]];
            
            self.Jour = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"Jour"]];
            //if([p_json objectForKey:@"AMDebut"] != nil )
                self.AMDebut = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"AMDebut"]];
            //if([p_json valueForKey:@"PMDebut"] != nil )
                self.PMDebut = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"PMDebut"]];
            //if([p_json valueForKey:@"AMFin"] != nil )
                self.AMFin = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"AMFin"]];
            //if([p_json valueForKey:@"PMFin"] != nil )
                self.PMFin = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"PMFin"]];
            //if([p_json objectForKey:@"Livre24"] != nil ) self.Livre24 = [p_json boolForKeyPath:@"Livre24"];
            //if([p_json valueForKey:@"Livre24"] != nil )
                self.Livre24 = [p_json boolForKeyPath:@"Livre24"];
            //else (self.Livre24 = 1);
  
            self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
            
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanHoraire.initBeanWithJson Id: %@",self.IdLieu] andExparams:nil];
    }
    return self;
}

-(NSMutableDictionary* ) objectToJson
{
    
    
    /*NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.IdLieu,@"IdLieu",
                                     self.Jour,@"Jour",
                                     [PEG_FTechnical getJsonFromDate:self.AMDebut],@"AMDebut",
                                     [PEG_FTechnical getJsonFromDate:self.PMDebut],@"PMDebut",
                                     [PEG_FTechnical getJsonFromDate:self.AMFin],@"AMFin",
                                     [PEG_FTechnical getJsonFromDate:self.PMFin],@"PMFin",
                                     [[NSNumber alloc ] initWithBool:self.Livre24 ],@"Livre24",
                                     self.FlagMAJ,@"FlagMAJ",
                                     nil];*/
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
    if (self.Jour != nil)[v_Return2 setObject:self.Jour forKey:@"Jour"];
    if ([PEG_FTechnical getJsonFromDate:self.AMDebut] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.AMDebut] forKey:@"AMDebut"];
    if ([PEG_FTechnical getJsonFromDate:self.PMDebut] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.PMDebut] forKey:@"PMDebut"];
    if ([PEG_FTechnical getJsonFromDate:self.AMFin] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.AMFin] forKey:@"AMFin"];
    if ([PEG_FTechnical getJsonFromDate:self.PMFin] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.PMFin] forKey:@"PMFin"];
    if ([[NSNumber alloc ] initWithBool:self.Livre24 ] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.Livre24 ] forKey:@"Livre24"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];

    
    return v_Return2;
    
}

- (NSComparisonResult)compare:(PEG_BeanHoraire *)otherObject
{
    return [self.Jour compare:otherObject.Jour];
}

@end

