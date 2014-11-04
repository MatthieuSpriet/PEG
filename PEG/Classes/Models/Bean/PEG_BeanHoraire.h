//
//  PEG_BeanHoraire.h
//  PEG
//
//  Created by 10_200_11_120 on 18/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanHoraire : NSObject

@property (nonatomic, retain) NSNumber* IdLieu;
@property (nonatomic, retain) NSNumber*   Jour;
@property (nonatomic, retain) NSDate*   AMDebut;
@property (nonatomic, retain) NSDate*   PMDebut;
@property (nonatomic, retain) NSDate*   AMFin;
@property (nonatomic, retain) NSDate*   PMFin;
@property (nonatomic, assign) BOOL   Livre24;
@property (nonatomic, retain) NSString* FlagMAJ;


-(id) initBeanWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
- (NSComparisonResult)compare:(PEG_BeanHoraire *)otherObject;
@end
