//
//  PEG_BeanTache.h
//  PEG
//
//  Created by 10_200_11_120 on 01/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanTache : NSObject

@property (nonatomic, retain) NSNumber* IdTache;
@property (nonatomic, retain) NSNumber* IdLieu;
@property (nonatomic, retain) NSNumber* Id;
@property (nonatomic, retain) NSDate*   Date;
@property (nonatomic, retain) NSString* Libelle;
@property (nonatomic, retain) NSNumber* Valeur;
@property (nonatomic, retain) NSString* CodeCR;
@property (nonatomic, retain) NSString* CodeAction;
@property (nonatomic, retain) NSString* FlagMAJ;


-(id) initBeanWithJson :(NSDictionary*)p_json;

-(NSMutableDictionary* ) objectToJson;
@end
