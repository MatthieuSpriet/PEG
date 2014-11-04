//
//  BeanCPCommune.h
//  PEG
//
//  Created by Horsmedia3 on 14/02/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanEdition, BeanMobilitePegase;

@interface BeanCPCommune : NSManagedObject

@property (nonatomic, strong) NSString * codeCommune;
@property (nonatomic, strong) NSString * commune;
@property (nonatomic, strong) NSString * cP;
@property (nonatomic, strong) BeanMobilitePegase *parentMobilitePegase;
@property (nonatomic, strong) NSSet *listEdition;
@end

@interface BeanCPCommune (CoreDataGeneratedAccessors)

- (void)addListEditionObject:(BeanEdition *)value;
- (void)removeListEditionObject:(BeanEdition *)value;
- (void)addListEdition:(NSSet *)values;
- (void)removeListEdition:(NSSet *)values;

@end
