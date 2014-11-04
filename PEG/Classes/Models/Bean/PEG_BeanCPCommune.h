//
//  PEG_BeanCPCommune.h
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanCPCommune : NSObject

@property (nonatomic, retain) NSString* CP;
@property (nonatomic, retain) NSString* CodeCommune;
@property (nonatomic, retain) NSString* Commune;

-(id) initBeanWithJson :(NSDictionary*)p_json;

-(NSMutableDictionary* ) objectToJson;
@end
