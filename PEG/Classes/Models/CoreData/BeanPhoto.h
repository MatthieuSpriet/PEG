//
//  BeanPhoto.h
//  PEG
//
//  Created by Horsmedia3 on 10/07/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BeanPhoto : NSManagedObject

@property (nonatomic, retain) NSNumber * idPresentoir;
@property (nonatomic, retain) NSNumber * isSend;
@property (nonatomic, retain) NSString * nom;

@end
