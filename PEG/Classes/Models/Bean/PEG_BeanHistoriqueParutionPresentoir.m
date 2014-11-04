//
//  PEG_BeanHistoriqueParutionPresentoir.m
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanHistoriqueParutionPresentoir.h"
#import "PEG_FTechnical.h"
#import "PEGException.h"

@implementation PEG_BeanHistoriqueParutionPresentoir


-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdPresentoir :%@,IdParution :%@, QteDistri :%@,QteRetour :%@, Date :%@}",
            NSStringFromClass([self class]),
            self,
            self.IdPresentoir,
            self.IdParution,
            self.QteDistri,
            self.QteRetour,
            self.Date
            ];
    
}


-(id) initBeanWithJson :(NSDictionary*)p_json
{
    
    @try{
        self = [self init];
        if (self)
        {
            
            self.IdPresentoir= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdPresentoir"]];
            self.IdParution= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdParution"]];
            self.QteDistri= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"QteDistri"]];
            self.QteRetour= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"QteRetour"]];
           self.Date= [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"Date"]];
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanHistoriqueParutionPresentoir.initBeanWithJson IdPresentoir:%@ IdParution: %@",self.IdPresentoir,self.IdParution] andExparams:nil];
    }
    return self;
    
}


-(NSMutableDictionary* ) objectToJson
{
    
    
    
    /*NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.IdPresentoir,@"IdPresentoir",
                                     self.IdParution,@"IdParution",
                                     [PEG_FTechnical getJsonFromDate:self.Date],@"Date",
                                     nil];*/
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.IdPresentoir != nil)[v_Return2 setObject:self.IdPresentoir forKey:@"IdPresentoir"];
    if (self.IdParution != nil)[v_Return2 setObject:self.IdParution forKey:@"IdParution"];
    if ([PEG_FTechnical getJsonFromDate:self.Date] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.Date] forKey:@"Date"];

    return v_Return2;
    
}



@end
