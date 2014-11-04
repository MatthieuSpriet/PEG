//
//  PEG_BeanConcurents.h
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanConcurents : NSObject

@property (nonatomic, retain) NSNumber* IdConcurentRef;
@property (nonatomic, retain) NSString* LibelleConcurent;
@property (nonatomic, retain) NSDate*   DateDebut;
@property (nonatomic, retain) NSDate*   DateFin;

-(id) initBeanWithJson :(NSDictionary*)p_json;

-(NSMutableDictionary* ) objectToJson;
@end
