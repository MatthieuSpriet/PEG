//
//  PEG_BeanParution.h
//  PEG
//
//  Created by 10_200_11_120 on 02/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanParution : NSObject

@property (nonatomic, retain) NSNumber* Id;
@property (nonatomic, retain) NSNumber* IdParutionPrec;
@property (nonatomic, retain) NSNumber* IdParutionReferentiel;
@property (nonatomic, retain) NSNumber* IdEdition;
@property (nonatomic, retain) NSString* NomParution;
@property (nonatomic, retain) NSString* LibelleParution;
@property (nonatomic, retain) NSString* LibelleEdition;
@property (nonatomic, retain) NSDate*   DateDebut;
@property (nonatomic, retain) NSDate*   DateFin;



-(id) initBeanWithJson :(NSDictionary*)p_json;

-(NSMutableDictionary* ) objectToJson;
@end
