//
//  PEG_EnumFlagMAJ.m
//  PEG
//
//  Created by 10_200_11_120 on 21/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_EnumFlagMAJ.h"


@implementation PEG_EnumFlagMAJ

NSString* const PEG_EnumFlagMAJ_Added = @"A";
NSString* const PEG_EnumFlagMAJ_Deleted = @"D";
NSString* const PEG_EnumFlagMAJ_Modified = @"M";
NSString* const PEG_EnumFlagMAJ_Unchanged = @"U";

+(NSString*)UpdateFlagMAJ:(NSString*)p_FlagMAJ
{
    NSString* v_retour = p_FlagMAJ;
    if([p_FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        v_retour = PEG_EnumFlagMAJ_Modified;
    }
    return v_retour;
}
@end
