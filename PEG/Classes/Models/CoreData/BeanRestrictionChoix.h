//
//  BeanRestrictionChoix.h
//  PEG
//
//  Created by Horsmedia3 on 20/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanChoix;

@interface BeanRestrictionChoix : NSManagedObject

@property (nonatomic, strong) NSString * codeFils;
@property (nonatomic, strong) NSString * codePere;
@property (nonatomic, strong) NSString * typeRestriction;
@property (nonatomic, strong) BeanChoix *parentChoix;

@end
