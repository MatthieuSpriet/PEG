//
//  BeanLieuPassageADX.h
//  PEG
//
//  Created by Horsmedia3 on 06/05/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanActionADX, BeanTourneeADX;

@interface BeanLieuPassageADX : NSManagedObject

@property (nonatomic, retain) NSNumber * idLieuPassage;
@property (nonatomic, retain) NSNumber * idLieu;
@property (nonatomic, retain) NSNumber * idTournee;
@property (nonatomic, retain) NSNumber * nbOrdrePassage;
@property (nonatomic, retain) NSString * flagMAJ;
@property (nonatomic, retain) NSString * nomLieu;
@property (nonatomic, retain) NSString * commune;
@property (nonatomic, retain) NSSet *listActionADX;
@property (nonatomic, retain) BeanTourneeADX *parentTourneeADX;
@end

@interface BeanLieuPassageADX (CoreDataGeneratedAccessors)

- (void)addListActionADXObject:(BeanActionADX *)value;
- (void)removeListActionADXObject:(BeanActionADX *)value;
- (void)addListActionADX:(NSSet *)values;
- (void)removeListActionADX:(NSSet *)values;

@end
