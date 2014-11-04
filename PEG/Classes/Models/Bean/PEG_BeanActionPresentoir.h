//
//  PEG_BeanActionPresentoir.h
//  PEG
//
//  Created by 10_200_11_120 on 11/09/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanAction.h"

@interface PEG_BeanActionPresentoir : NSObject

@property (nonatomic, retain) NSNumber* IdPresentoir;
@property (nonatomic, retain) NSNumber* IdParution;
@property (nonatomic, retain) NSString* ActionType;
@property (nonatomic, retain) NSString* TypeActionCptRendu;
@property (nonatomic, retain) NSNumber* QuantitePrevue;
@property (nonatomic, retain) NSNumber* QuantiteDistribuee;
@property (nonatomic, retain) NSNumber* QuantiteRecuperee;
@property (nonatomic, retain) NSString* CheminPhoto;
@property (nonatomic, retain) NSString* ValeurTexte;
@property (nonatomic, retain) NSDate*   DateCreation;
@property (nonatomic, retain) NSNumber* CoordX;
@property (nonatomic, retain) NSNumber* CoordY;
@property (nonatomic, assign) BOOL      CoordGPSFiable;
@property (nonatomic, retain) NSString* FlagMAJ;

-(id) initBeanWithJson :(NSDictionary*)p_json;
-(BeanAction*) initCDWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
//-(id) initBeanForNewQteDistribuee:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution;
//-(id) initBeanForNewQteRetour:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution;
@end
