//
//  BeanHistoriqueParutionPresentoir.h
//  PEG
//
//  Created by Horsmedia3 on 12/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanPresentoir;

@interface BeanHistoriqueParutionPresentoir : NSManagedObject

@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSNumber * idParution;
@property (nonatomic, strong) NSNumber * idPresentoir;
@property (nonatomic, strong) NSNumber * qteDistri;
@property (nonatomic, strong) NSNumber * qteRetour;
@property (nonatomic, strong) BeanPresentoir *parentPresentoir;

@end
