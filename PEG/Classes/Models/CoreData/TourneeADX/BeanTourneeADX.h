//
//  BeanTourneeADX.h
//  PEG
//
//  Created by Pierre Marty on 27/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanLieuPassageADX, BeanMobilitePegase;

@interface BeanTourneeADX : NSManagedObject

@property (nonatomic, retain) NSDate * dtDebut;
@property (nonatomic, retain) NSString * flagMAJ;
@property (nonatomic, retain) NSNumber * idTourneeRef;
@property (nonatomic, retain) NSNumber * idTournee;
@property (nonatomic, retain) NSString * liTournee;
@property (nonatomic, retain) NSSet *listLieuPassageADX;
@property (nonatomic, retain) BeanMobilitePegase *parentMobilitePegase;
@end

@interface BeanTourneeADX (CoreDataGeneratedAccessors)

- (void)addListLieuPassageADXObject:(BeanLieuPassageADX *)value;
- (void)removeListLieuPassageADXObject:(BeanLieuPassageADX *)value;
- (void)addListLieuPassageADX:(NSSet *)values;
- (void)removeListLieuPassageADX:(NSSet *)values;

@end
