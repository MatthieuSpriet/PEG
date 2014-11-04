//
//  BeanCPCommune+.m
//  PEG
//
//  Created by 10_200_11_120 on 09/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "BeanCPCommune+.h"

@implementation BeanCPCommune (compare)

- (NSComparisonResult)compareTrie:(BeanCPCommune *)otherObject;
{
    return [self.commune compare:otherObject.commune];
}

@end
