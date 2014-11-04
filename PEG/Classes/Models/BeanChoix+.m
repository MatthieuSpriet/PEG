//
//  BeanChoix+.m
//  PEG
//
//  Created by 10_200_11_120 on 18/12/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "BeanChoix+.h"

@implementation BeanChoix (compare)

- (NSComparisonResult)compareTrie:(BeanChoix *)otherObject
{
    return [self.libelle compare:otherObject.libelle];
}

@end