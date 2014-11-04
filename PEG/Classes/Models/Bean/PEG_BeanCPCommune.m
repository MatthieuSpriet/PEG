//
//  PEG_BeanCPCommune.m
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanCPCommune.h"
#import "PEGException.h"

@implementation PEG_BeanCPCommune


-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {CP :%@,CodeCommune :%@,Commune :%@}",
            NSStringFromClass([self class]),
            self,
            self.CP,
            self.CodeCommune,
            self.Commune
            ];
    
}


-(id) initBeanWithJson :(NSDictionary*)p_json
{
    
    @try{
        self = [self init];
        if (self)
        {
            
             //if([p_json objectForKey:@"CP"] != nil )
                 self.CP= [p_json stringForKeyPath:@"CP"];
             //if([p_json objectForKey:@"CodeCommune"] != nil )
                 self.CodeCommune= [p_json stringForKeyPath:@"CodeCommune"];
             //if([p_json objectForKey:@"Commune"] != nil )
                 self.Commune= [p_json stringForKeyPath:@"Commune"];
                        
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanCPCommune.initBeanWithJson CodeCommune: %@",self.CodeCommune] andExparams:nil];
    }
    return self;
    
}
-(NSMutableDictionary* ) objectToJson
{
    
    
    NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     self.CP,@"CP",
                                     self.CodeCommune,@"CodeCommune",
                                     self.Commune,@"Commune",
                                     nil];
    
    return v_Return;
    
}


@end
