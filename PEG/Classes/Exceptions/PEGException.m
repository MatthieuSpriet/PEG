//
//  PEGException.m
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGException.h"
#import "PEG_LogSpirRequest.h"
#import "PEG_FTechnical.h"

@implementation PEGException

static PEGException *sharedExceptionInstance = nil;

-(void) dealloc
{
    [NSException raise:@"This method couldn't be call !!!!" format:@"Impossible to call a dealloc of singleton",nil];
}

+ (PEGException *)sharedInstance
{
	if (sharedExceptionInstance == nil)
	{
		sharedExceptionInstance = [[super allocWithZone:NULL] init];
        
	}
	return sharedExceptionInstance;
}

- (id)init
{
    self = [super init];
    
    return self;
}

-(void)ManageExceptionWithThrow:(NSException*)p_Exception andMessage:(NSString*)p_message andExparams:(NSString*)p_exparams
{
    @try{
        NSLog(@"<== EXCEPTION ==> %@ , MESSAGE: %@", p_Exception.debugDescription,p_message);
        
        //APPEL LOG
        PEG_BeanException * v_PEGBeanException =[[PEG_BeanException alloc]init];
        v_PEGBeanException.Message=  [NSString stringWithString:p_message];
        v_PEGBeanException.Parametres= [NSMutableArray array];
        if(p_exparams != nil)
        {
            [v_PEGBeanException.Parametres addObject:p_exparams];
        }
        v_PEGBeanException.Exception=[NSString stringWithString:p_Exception.debugDescription];
        [v_PEGBeanException LogError];
        [PEG_FTechnical traceErrorWithMessage:[NSString stringWithString:p_message]];
        
    }
    @catch (NSException *p_exception) {}
    
    //RAISE EXCEPTION
    [p_Exception raise];
}

-(void)ManageExceptionWithoutThrow:(NSException*)p_Exception andMessage:(NSString*)p_message andExparams:(NSString*)p_exparams
{
    @try
    {
        //APPEL LOG
        PEG_BeanException * v_PEGBeanException =[[PEG_BeanException alloc]init];
        v_PEGBeanException.Message=  [NSString stringWithString:p_message];
        v_PEGBeanException.Parametres= [NSMutableArray array];
        if(p_exparams != nil)
        {
            [v_PEGBeanException.Parametres addObject:p_exparams];
        }
        if(p_Exception != nil)
        {
            v_PEGBeanException.Exception=[NSString stringWithString:p_Exception.debugDescription];
        }
        [v_PEGBeanException LogError];
        [PEG_FTechnical traceErrorWithMessage:[NSString stringWithFormat:@"Exception WithoutThrow - %@",[NSString stringWithString:p_message]]];
    }
    @catch (NSException *p_exception) {}
}

-(void)ManageErrorWithoutThrow:(NSError*)p_Error andMessage:(NSString*)p_message andExparams:(NSString*)p_exparams
{
    @try
    {
        //APPEL LOG
        PEG_BeanException * v_PEGBeanException =[[PEG_BeanException alloc]init];
        v_PEGBeanException.Message=  [NSString stringWithString:p_message];
        v_PEGBeanException.Parametres= [NSMutableArray array];
        if(p_exparams != nil)
        {
            [v_PEGBeanException.Parametres addObject:p_exparams];
        }
        if(p_Error != nil)
        {
            v_PEGBeanException.Exception=[NSString stringWithString:p_Error.debugDescription];
        }
        [v_PEGBeanException LogError];
        [PEG_FTechnical traceErrorWithMessage:[NSString stringWithFormat:@"Exception WithoutThrow - %@",[NSString stringWithString:p_message]]];
    }
    @catch (NSException *p_exception) {}
}



@end
