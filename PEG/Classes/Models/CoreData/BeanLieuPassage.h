//
//  BeanLieuPassage.h
//  PEG
//
//  Created by Horsmedia3 on 03/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanAction, BeanTournee;

@interface BeanLieuPassage : NSManagedObject

@property (nonatomic, strong) NSDate * datePassageReel;
@property (nonatomic, strong) NSDate * dateValeur;
@property (nonatomic, strong) NSNumber * flagCreerMerch;
@property (nonatomic, strong) NSString * flagMAJ;
@property (nonatomic, strong) NSNumber * idLieu;
@property (nonatomic, strong) NSNumber * idLieuPassage;
@property (nonatomic, strong) NSNumber * idTournee;
@property (nonatomic, strong) NSString * liCommentaire;
@property (nonatomic, strong) NSNumber * nbNewOrdrePassage;
@property (nonatomic, strong) NSNumber * nbOrdrePassage;
@property (nonatomic, strong) NSSet *listAction;
@property (nonatomic, strong) BeanTournee *parentTournee;
@end

@interface BeanLieuPassage (CoreDataGeneratedAccessors)

- (void)addListActionObject:(BeanAction *)value;
- (void)removeListActionObject:(BeanAction *)value;
- (void)addListAction:(NSSet *)values;
- (void)removeListAction:(NSSet *)values;

@end
