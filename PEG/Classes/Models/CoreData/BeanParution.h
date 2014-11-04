//
//  BeanParution.h
//  PEG
//
//  Created by Horsmedia3 on 14/02/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanMobilitePegase;

@interface BeanParution : NSManagedObject

@property (nonatomic, strong) NSDate * dateDebut;
@property (nonatomic, strong) NSDate * dateFin;
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * idEdition;
@property (nonatomic, strong) NSNumber * idParutionPrec;
@property (nonatomic, strong) NSNumber * idParutionReferentiel;
@property (nonatomic, strong) NSString * libelleParution;
@property (nonatomic, strong) NSString * nomParution;
@property (nonatomic, strong) NSString * libelleEdition;
@property (nonatomic, strong) BeanMobilitePegase *parentMobilite;

@end
