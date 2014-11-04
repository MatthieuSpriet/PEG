//
//  BeanConcurents.h
//  PEG
//
//  Created by Horsmedia3 on 12/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanMobilitePegase;

@interface BeanConcurents : NSManagedObject

@property (nonatomic, strong) NSDate * dateDebut;
@property (nonatomic, strong) NSDate * dateFin;
@property (nonatomic, strong) NSNumber * idConcurentRef;
@property (nonatomic, strong) NSString * libelleConcurent;
@property (nonatomic, strong) BeanMobilitePegase *parentMobilitePegase;

@end
