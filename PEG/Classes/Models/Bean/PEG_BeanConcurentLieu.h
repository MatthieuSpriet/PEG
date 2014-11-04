//
//  PEG_BeanConcurrentLieu.h
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanConcurentLieu : NSObject


@property (nonatomic, retain) NSNumber* IdConcurrence;
@property (nonatomic, retain) NSNumber*   IdLieu;
@property (nonatomic, retain) NSDate*   DateDebut;
@property (nonatomic, retain) NSDate*   DateFin;
@property (nonatomic, retain) NSString* Famille;
@property (nonatomic, retain) NSString* Emplacement;
@property (nonatomic, retain) NSString* FlagMAJ;


-(id) initBeanWithJson :(NSDictionary*)p_json;

-(NSMutableDictionary* ) objectToJson;
@end
