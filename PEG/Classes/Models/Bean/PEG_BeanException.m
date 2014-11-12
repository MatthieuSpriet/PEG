//
//  PEG_BeanException.m
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanException.h"
#import "PEG_LogSpirRequest.h"

@implementation PEG_BeanException

-(NSMutableDictionary* ) objectToJson
{
    NSMutableDictionary* v_Return=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.Exception,@"Exception",
                                   self.Message,@"Message",
                                   self.Parametres,@"Parametres",
                                   nil];
    
    return v_Return ;
}

-(void) LogError
{
    
    PEG_LogSpirRequest* v_request=[PEG_LogSpirRequest  requestLogError:self];
    
    [v_request setStartedBlock:^
     {
     }];

    [v_request setCompletionBlock:^
     {
     }];
    
    [v_request startAsynchronous];
    
    
}



@end
