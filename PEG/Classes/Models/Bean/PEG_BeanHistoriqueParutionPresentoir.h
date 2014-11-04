//
//  PEG_BeanHistoriqueParutionPresentoir.h
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanHistoriqueParutionPresentoir : NSObject


@property (nonatomic, retain) NSNumber* IdPresentoir;
@property (nonatomic, retain) NSNumber* IdParution;
@property (nonatomic, retain) NSNumber* QteDistri;
@property (nonatomic, retain) NSNumber* QteRetour;
@property (nonatomic, retain) NSDate* Date;

-(id) initBeanWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
@end
