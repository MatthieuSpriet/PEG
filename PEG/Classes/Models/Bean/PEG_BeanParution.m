//
//  PEG_BeanParution.m
//  PEG
//
//  Created by 10_200_11_120 on 02/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanParution.h"
#import "PEG_FTechnical.h"

@implementation PEG_BeanParution

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {Id :%@,IdParutionPrec:%@ ,IdParutionReferentiel :%@,IdEdition :%@,NomParution :%@,LibelleParution :%@,LibelleEdition :%@,DateDebut :%@,DateFin :%@}",
            NSStringFromClass([self class]),
            self,
            self.Id,
            self.IdParutionPrec,
            self.IdParutionReferentiel,
            self.IdEdition,
            self.NomParution,
            self.LibelleParution,
            self.LibelleEdition,
            self.DateDebut,
            self.DateFin
            ];
    
}

-(id) initBeanWithJson :(NSDictionary*)p_json;{

    self = [self init];
    if (self)
    {
        self.Id= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"Id"]];
        self.IdParutionPrec= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdParutionPrec"]];
        self.IdParutionReferentiel= [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdParutionReferentiel"]];
        self.IdEdition=[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdEdition"]];
        self.NomParution= [p_json stringForKeyPath:@"NomParution"];
        self.LibelleParution= [p_json stringForKeyPath:@"LibelleParution"];
        self.LibelleEdition= [p_json stringForKeyPath:@"LibelleEdition"];
        self.DateDebut= [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateDebut"]];
        self.DateFin= [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateFin"]];
    }
    
    return self;
}

-(NSMutableDictionary* ) objectToJson
{
    
    
    NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.Id,@"Id",
                                     self.IdParutionPrec,@"IdParutionPrec",
                                     self.IdParutionReferentiel,@"IdParutionReferentiel",
                                     self.IdEdition,@"IdEdition",
                                     self.NomParution,@"NomParution",
                                     self.LibelleParution,@"LibelleParution",
                                     self.LibelleEdition,@"LibelleEdition",
                                     [PEG_FTechnical getJsonFromDate:self.DateDebut],@"DateDebut",
                                     [PEG_FTechnical getJsonFromDate:self.DateFin],@"DateFin",
                                     nil];
    
    return v_Return;
    
}

@end
