//
//  PEG_BeanConcurrentLieu.m
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanConcurentLieu.h"
#import "PEG_FTechnical.h"
#import "PEGException.h"

@implementation PEG_BeanConcurentLieu

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdConcurrence :%@,IdLieu :%@,DateDebut :%@,DateFin :%@,Famille :%@,Emplacement :%@,FlagMAJ :%@}",
            NSStringFromClass([self class]),
            self,
            self.IdConcurrence,
            self.IdLieu,
            self.DateDebut,
            self.DateFin,
            self.Famille,
            self.Emplacement,
            self.FlagMAJ
            ];
    
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    
    @try{
        self = [self init];
        if (self)
        {
            self.IdConcurrence = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdConcurrence"]];
            self.IdLieu = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieu"]];
            //if([p_json valueForKey:@"DateDebut"] != nil )
            self.DateDebut = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateDebut"]];
            //if([p_json valueForKey:@"DateFin"] != nil )
            self.DateFin = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateFin"]];

            //if([p_json valueForKey:@"Emplacement"] != nil )
                self.Emplacement = [p_json stringForKeyPath:@"Emplacement"];
            
            //if([p_json valueForKey:@"Famille"] != nil )
                self.Famille = [p_json stringForKeyPath:@"Famille"];
            
            //if([p_json valueForKey:@"FlagMAJ"] != nil )
                self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
            
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanConcurentLieu.initBeanWithJson Id: %@",self.IdConcurrence] andExparams:nil];
    }
    return self;

}

-(NSMutableDictionary* ) objectToJson
{
    
    
    NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.IdConcurrence,@"IdConcurrence",
                                     self.IdLieu,@"IdLieu",
                                     [PEG_FTechnical getJsonFromDate:self.DateDebut],@"DateDebut",
                                     [PEG_FTechnical getJsonFromDate:self.DateFin],@"DateFin",
                                     self.Famille,@"Famille",
                                     self.Emplacement,@"Emplacement",
                                     self.FlagMAJ,@"FlagMAJ",
                                     nil];
    
    return v_Return;
    
}


@end
