//
//  BeanHoraire.h
//  PEG
//
//  Created by Horsmedia3 on 12/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanLieu;

@interface BeanHoraire : NSManagedObject

@property (nonatomic, strong) NSDate * aMDebut;
@property (nonatomic, strong) NSDate * aMFin;
@property (nonatomic, strong) NSString * flagMAJ;
@property (nonatomic, strong) NSNumber * idLieu;
@property (nonatomic, strong) NSNumber * jour;
@property (nonatomic, strong) NSNumber * livre24;
@property (nonatomic, strong) NSDate * pMDebut;
@property (nonatomic, strong) NSDate * pMFin;
@property (nonatomic, strong) BeanLieu *parentLieu;

@end
