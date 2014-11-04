//
//  PEG_BeanTournee.h
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanTournee.h"

@interface PEG_BeanTournee : NSObject

@property (nonatomic, retain) NSNumber* IdTournee;
@property (nonatomic, retain) NSString* LiTournee;
@property (nonatomic, retain) NSString* CoTourneeType;
@property (nonatomic, assign) BOOL PremiereDistribution;
@property (nonatomic, retain) NSDate* DtDebutReelle;
@property (nonatomic, retain) NSNumber* IdTourneeRef;
@property (nonatomic, retain) NSString* LiCommentaire;
@property (nonatomic, retain) NSString* FlagMAJ;


//liste de PEG_BeanLieuPassage
@property (nonatomic,retain) NSMutableArray* ListLieuPassage;



-(id) initBeanWithJson :(NSDictionary*)p_json;
-(BeanTournee*) initCDWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
-(NSMutableDictionary* ) objectModifiedToJson;
@end
