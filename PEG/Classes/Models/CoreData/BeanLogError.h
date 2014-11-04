//
//  BeanLogError.h
//  PEG
//
//  Created by Horsmedia3 on 30/04/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BeanLogError : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * codeError;
@property (nonatomic, retain) NSString * domainError;

@end
