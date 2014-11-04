//
//  BeanHoraire+.h
//  PEG
//
//  Created by Horsmedia3 on 13/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanHoraire.h"

@interface BeanHoraire (compare)

- (NSComparisonResult)compare:(BeanHoraire *)otherObject;

@end
