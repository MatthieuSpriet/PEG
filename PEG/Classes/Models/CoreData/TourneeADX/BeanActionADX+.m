//
//  BeanActionADX+.m
//  PEG
//
//  Created by Horsmedia3 on 09/06/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "BeanActionADX+.h"
#import "BeanLieuPassageADX.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"

@implementation BeanActionADX (flagMAJ)

-(void) setFlagMAJ:(NSString*)p_FlagMAJ
{
    [super setFlagMAJ:p_FlagMAJ];
    if(![p_FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        //Cela permet de passer la chaine de la tournee en modif pour la synchro
        [[self parentLieuPassageADX] setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    }
}

@end
