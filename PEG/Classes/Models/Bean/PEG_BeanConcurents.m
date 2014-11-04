//
//  PEG_BeanConcurents.m
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanConcurents.h"
#import "PEG_FTechnical.h"
#import "PEGException.h"

@implementation PEG_BeanConcurents

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdConcurentRef :%@,LibelleConcurent :%@,DateDebut :%@,DateFin :%@}",
            NSStringFromClass([self class]),
            self,
            self.IdConcurentRef,
            self.LibelleConcurent,
            self.DateDebut,
            self.DateFin
            ];
    
}



-(id) initBeanWithJson :(NSDictionary*)p_json
{
    
    @try{
        self = [self init];
        if (self)
        {
              self.IdConcurentRef = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdConcurentRef"]];
            
             // if([p_json stringForKeyPath:@"LibelleConcurent"] != nil )
                  self.LibelleConcurent= [p_json stringForKeyPath:@"LibelleConcurent"];
              //if([p_json stringForKeyPath:@"DateDebut"] != nil )
              self.DateDebut = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateDebut"]];
              //if([p_json stringForKeyPath:@"DateFin"] != nil )
              self.DateFin = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateFin"]];
             
            
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanConcurents.initBeanWithJson Id: %@",self.IdConcurentRef] andExparams:nil];
    }
    return self;
    
}

-(NSMutableDictionary* ) objectToJson
{
    
    
    NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.IdConcurentRef,@"IdConcurentRef",
                                     self.LibelleConcurent,@"LibelleConcurent",
                                     [PEG_FTechnical getJsonFromDate:self.DateDebut],@"DateDebut",
                                     [PEG_FTechnical getJsonFromDate:self.DateFin],@"DateFin",
                                     nil];
    
    return v_Return;
    
}

@end
