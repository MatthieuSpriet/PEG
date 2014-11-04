//
//  BeanPresentoirParution.h
//  PEG
//
//  Created by Horsmedia3 on 27/03/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanPresentoir;

@interface BeanPresentoirParution : NSManagedObject

@property (nonatomic, retain) NSNumber * idParution;
@property (nonatomic, retain) NSNumber * idPresentoir;
@property (nonatomic, retain) BeanPresentoir *parentPresentoir;

@end
