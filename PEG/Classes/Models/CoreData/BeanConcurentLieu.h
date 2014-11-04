//
//  BeanConcurentLieu.h
//  PEG
//
//  Created by Horsmedia3 on 12/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanLieu;

@interface BeanConcurentLieu : NSManagedObject

@property (nonatomic, strong) NSDate * dateDebut;
@property (nonatomic, strong) NSDate * dateFin;
@property (nonatomic, strong) NSString * emplacement;
@property (nonatomic, strong) NSString * famille;
@property (nonatomic, strong) NSString * flagMAJ;
@property (nonatomic, strong) NSNumber * idConcurrence;
@property (nonatomic, strong) NSNumber * idLieu;
@property (nonatomic, strong) BeanLieu *parentLieu;

@end
