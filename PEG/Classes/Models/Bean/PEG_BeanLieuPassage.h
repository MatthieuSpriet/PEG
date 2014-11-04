//
//  PEG_BeanLieuPassage.h
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanLieuPassage.h"

@interface PEG_BeanLieuPassage : NSObject

@property (nonatomic, retain) NSNumber* IdLieuPassage;
@property (nonatomic, retain) NSNumber* IdLieu;
@property (nonatomic, retain) NSNumber* IdTournee;
@property (nonatomic, retain) NSNumber* NbOrdrePassage;
@property (nonatomic, retain) NSNumber* NbNewOrdrePassage;
@property (nonatomic, assign) BOOL FlagCreerMerch;
@property (nonatomic, retain) NSDate* DateValeur;
@property (nonatomic, retain) NSString* LiCommentaire;
@property (nonatomic, retain) NSString* FlagMAJ;
@property (nonatomic, retain) NSDate* DatePassageReel;


//liste de PEG_BeanActionPresentoir
@property (nonatomic,retain) NSMutableArray* ListActionPresentoir;

-(id) initBeanWithJson :(NSDictionary*)p_json;
-(BeanLieuPassage*) initCDWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
-(NSMutableDictionary* ) objectModifiedToJson;

/*-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution;
-(NSNumber*) GetQteDistriByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution;
-(NSNumber*) GetQteRetourByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution;*/

@end
