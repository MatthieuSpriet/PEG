//
//  PEG_EnumFlagMAJ.h
//  PEG
//
//  Created by 10_200_11_120 on 21/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const PEG_EnumFlagMAJ_Added;
extern NSString* const PEG_EnumFlagMAJ_Deleted;
extern NSString* const PEG_EnumFlagMAJ_Modified;
extern NSString* const PEG_EnumFlagMAJ_Unchanged;

@interface PEG_EnumFlagMAJ : NSObject

+(NSString*)UpdateFlagMAJ:(NSString*)p_FlagMAJ;

@end
