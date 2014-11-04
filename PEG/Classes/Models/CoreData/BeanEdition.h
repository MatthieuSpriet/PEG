//
//  BeanEdition.h
//  PEG
//
//  Created by Horsmedia3 on 14/02/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanCPCommune;

@interface BeanEdition : NSManagedObject

@property (nonatomic, strong) NSString * cP;
@property (nonatomic, strong) NSNumber * idEdition;
@property (nonatomic, strong) NSString * libelleEdition;
@property (nonatomic, strong) BeanCPCommune *parentCP;

@end
