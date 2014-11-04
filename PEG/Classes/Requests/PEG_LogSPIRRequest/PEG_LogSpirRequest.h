//
//  PEG_LogSPIRRequest.h
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEGBaseRequest.h"
#import "PEG_BeanException.h"

@interface PEG_LogSpirRequest : PEGBaseRequest

+(PEG_LogSpirRequest *)requestLogDebug:(NSString*)p_message;
+(PEG_LogSpirRequest *)requestLogInfo:(NSString*)p_message;
+(PEG_LogSpirRequest *)requestLogWarn:(NSString*)p_message;
+(PEG_LogSpirRequest *)requestLogError:(PEG_BeanException*)p_Exception;
+(PEG_LogSpirRequest *)requestLogFatal:(NSString*)p_message andException:(NSString*)p_exception;

@end
