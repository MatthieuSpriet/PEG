//
//  BeanConcurents+.m
//  PEG
//
//  Created by Horsmedia3 on 16/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "BeanConcurents+.h"

@implementation BeanConcurents (compareTrie)

- (NSComparisonResult)compareTrie:(BeanConcurents *)otherObject;
{
    return [self.libelleConcurent compare:otherObject.libelleConcurent];
}

@end
