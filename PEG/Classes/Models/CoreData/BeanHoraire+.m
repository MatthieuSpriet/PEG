//
//  BeanHoraire+.m
//  PEG
//
//  Created by Horsmedia3 on 13/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "BeanHoraire+.h"

@implementation BeanHoraire (compare)

- (NSComparisonResult)compare:(BeanHoraire *)otherObject
{
    return [self.jour compare:otherObject.jour];
}

@end
