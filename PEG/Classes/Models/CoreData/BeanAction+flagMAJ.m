//
//  BeanAction+flagMAJ.m
//  PEG
//
//  Created by Horsmedia3 on 21/02/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "BeanAction+flagMAJ.h"
#import "BeanLieuPassage.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"

@implementation BeanAction (flagMAJ)

-(void) setFlagMAJ:(NSString*)p_FlagMAJ
{
    [super setFlagMAJ:p_FlagMAJ];
    if(![p_FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        //Cela permet de passer la chaine de la tournee en modif pour la synchro
        [[self parentLieuPassage] setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    }
}

@end
