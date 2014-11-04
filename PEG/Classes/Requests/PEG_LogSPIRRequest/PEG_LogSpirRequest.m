//
//  PEG_LogSPIRRequest.m
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_LogSPIRRequest.h"
#import "PEGParametres.h"
#import "PEG_BeanException.h"

@implementation PEG_LogSpirRequest

+ (PEG_LogSpirRequest *)requestLogDebug:(NSString*)p_message
{
    PEG_LogSpirRequest *request;
    
    @try{
        
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesCommun_LogSpir"];
        
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/Debug?message=%@",UrlWebservice,p_message];
        
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        request = [PEG_LogSpirRequest requestWithURL:url];
        
        
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
    }
	return request;
}
+(PEG_LogSpirRequest *)requestLogInfo:(NSString*)p_message
{
    PEG_LogSpirRequest *request;
    
    @try{
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesCommun_LogSpir"];
        
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/Info?message=%@",UrlWebservice,p_message];
        
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        request = [PEG_LogSpirRequest requestWithURL:url];
        
        
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
    }
	return request;
}
+(PEG_LogSpirRequest *)requestLogWarn:(NSString*)p_message
{
    PEG_LogSpirRequest *request;
    
    @try{
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesCommun_LogSpir"];
        
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/Warn?message=%@",UrlWebservice,p_message];
        
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        request = [PEG_LogSpirRequest requestWithURL:url];
        
        
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
    }
	return request;
}
+(PEG_LogSpirRequest *)requestLogError:(PEG_BeanException*)p_Exception
{
    PEG_LogSpirRequest *request;
    
    @try{
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesCommun_LogSpir"];
        
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/Error",UrlWebservice];
        
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        request = [PEG_LogSpirRequest requestWithURL:url];
        
        
        [request configureRequestInJsonCompressedFormat];
        
        
        NSMutableDictionary* v_DataSend = [p_Exception objectToJson];
        if ([NSJSONSerialization isValidJSONObject:v_DataSend])
        {
            NSData* data = [NSJSONSerialization dataWithJSONObject:v_DataSend options:NSJSONWritingPrettyPrinted error:nil];
            DLog(@"=>requestBody: %@ ", [[NSString alloc] initWithData:data
                                                              encoding:NSUTF8StringEncoding]);
            [request setPostBody:[NSMutableData dataWithData:data ]];
        }
        
        
    }@catch(NSException* p_exception){
    }
	return request;
}
+(PEG_LogSpirRequest *)requestLogFatal:(NSString*)p_message andException:(NSString*)p_exception
{
    PEG_LogSpirRequest *request;
    
    @try{
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesCommun_LogSpir"];
        
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/Fatal?message=%@&exception=%@",UrlWebservice,p_message,p_exception];
        
        
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        request = [PEG_LogSpirRequest requestWithURL:url];
        
        
        [request configureRequestInJsonCompressedFormat];
        
    }@catch(NSException* p_exception){
    }
	return request;
}


@end
