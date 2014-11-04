//
//  PEG_BeanPointDsgn.m
//  PEG
//
//  Created by 10_200_11_120 on 09/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanPointDsgn.h"

@implementation PEG_BeanPointDsgn

- (NSComparisonResult)compareMetre:(PEG_BeanPointDsgn *)otherObject {
    return [self.NbMetre compare:otherObject.NbMetre];
}

- (NSComparisonResult)compareNomAdresse:(PEG_BeanPointDsgn *)otherObject {
    if(![self.NomPoint isEqualToString:otherObject.NomPoint])
    {
        return [[self.NomPoint uppercaseString] compare:[otherObject.NomPoint uppercaseString]];
    }
    else if (![self.Commune isEqualToString:otherObject.Commune])
    {
        return [self.Commune compare:otherObject.Commune];
    }
    else
    {
        return [self.Adresse compare:otherObject.Adresse];
    }
}

@end
