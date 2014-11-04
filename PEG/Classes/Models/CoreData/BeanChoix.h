//
//  BeanChoix.h
//  PEG
//
//  Created by Horsmedia3 on 20/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanMobilitePegase, BeanRestrictionChoix;

@interface BeanChoix : NSManagedObject

@property (nonatomic, strong) NSString * categorie;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSDate * dateDebut;
@property (nonatomic, strong) NSDate * dateFin;
@property (nonatomic, strong) NSNumber * idItemListChoix;
@property (nonatomic, strong) NSString * libelle;
@property (nonatomic, strong) NSString * restriction;
@property (nonatomic, strong) BeanMobilitePegase *parentMobilitePegase;
@property (nonatomic, strong) NSSet *listRestriction;
@end

@interface BeanChoix (CoreDataGeneratedAccessors)

- (void)addListRestrictionObject:(BeanRestrictionChoix *)value;
- (void)removeListRestrictionObject:(BeanRestrictionChoix *)value;
- (void)addListRestriction:(NSSet *)values;
- (void)removeListRestriction:(NSSet *)values;

@end
