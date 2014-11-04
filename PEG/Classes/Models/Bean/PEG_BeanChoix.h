//
//  PEG_BeanListeChoix.h
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanChoix : NSObject

@property (nonatomic, retain) NSNumber* IdItemListChoix;
@property (nonatomic, retain) NSString* Categorie;
@property (nonatomic, retain) NSString* Code;
@property (nonatomic, retain) NSString* Libelle;
@property (nonatomic, retain) NSString* Restriction;
@property (nonatomic, retain) NSDate* DateDebut;
@property (nonatomic, retain) NSDate* DateFin;


-(id) initBeanWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
@end
