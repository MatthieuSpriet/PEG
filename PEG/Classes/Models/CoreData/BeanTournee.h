//
//  BeanTournee.h
//  PEG
//
//  Created by Horsmedia3 on 12/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanLieuPassage, BeanMobilitePegase;

@interface BeanTournee : NSManagedObject

@property (nonatomic, strong) NSString * coTourneeType;
@property (nonatomic, strong) NSDate * dtDebutReelle;
@property (nonatomic, strong) NSString * flagMAJ;
@property (nonatomic, strong) NSNumber * idTournee;
@property (nonatomic, strong) NSNumber * idTourneeRef;
@property (nonatomic, strong) NSString * liCommentaire;
@property (nonatomic, strong) NSString * liTournee;
@property (nonatomic, strong) NSNumber * premiereDistribution;
@property (nonatomic, strong) NSSet *listLieuPassage;
@property (nonatomic, strong) BeanMobilitePegase *parentMobilitePegase;
@end

@interface BeanTournee (CoreDataGeneratedAccessors)

- (void)addListLieuPassageObject:(BeanLieuPassage *)value;
- (void)removeListLieuPassageObject:(BeanLieuPassage *)value;
- (void)addListLieuPassage:(NSSet *)values;
- (void)removeListLieuPassage:(NSSet *)values;

@end
