//
//  BeanTache.h
//  PEG
//
//  Created by Horsmedia3 on 14/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanLieu, BeanPresentoir;

@interface BeanTache : NSManagedObject

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * flagMAJ;
@property (nonatomic, strong) NSNumber * idPresentoir;
@property (nonatomic, strong) NSNumber * idLieu;
@property (nonatomic, strong) NSNumber * idTache;
@property (nonatomic, strong) NSNumber * valeur;
@property (nonatomic, strong) BeanLieu *parentLieu;
@property (nonatomic, strong) BeanPresentoir *parentPresentoir;

@end
