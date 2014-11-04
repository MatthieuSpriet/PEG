//
//  PEGException.h
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEGException : NSObject

+ (PEGException *)sharedInstance;

-(void)ManageExceptionWithThrow:(NSException*)p_Exception andMessage:(NSString*)p_message andExparams:(NSString*)p_exparams;

-(void)ManageExceptionWithoutThrow:(NSException*)p_Exception andMessage:(NSString*)p_message andExparams:(NSString*)p_exparams;
-(void)ManageErrorWithoutThrow:(NSError*)p_Error andMessage:(NSString*)p_message andExparams:(NSString*)p_exparams;

@end
