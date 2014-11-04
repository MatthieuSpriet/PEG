//
//  BeanChoix+.h
//  PEG
//
//  Created by 10_200_11_120 on 18/12/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanChoix.h"

@interface BeanChoix (compareTrie)

- (NSComparisonResult)compareTrie:(BeanChoix *)otherObject;

@end
