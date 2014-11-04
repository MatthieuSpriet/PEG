//
//  PEG_BeanPresentoir.h
//  PEG
//
//  Created by 10_200_11_120 on 01/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanPresentoir : NSObject

@property (nonatomic, retain) NSNumber* Id;
@property (nonatomic, retain) NSDate*   DateAnnule;
@property (nonatomic, retain) NSDate*   DateDernierePhoto;
@property (nonatomic, retain) NSString* Emplacement;
@property (nonatomic, retain) NSString* NomBatiment;
@property (nonatomic, retain) NSString* FlagMAJ;
@property (nonatomic, assign) BOOL      FlagPhoto;
@property (nonatomic, retain) NSString* Guidpresentoir;
@property (nonatomic, retain) NSNumber* IdLieu;
@property (nonatomic, retain) NSNumber* IdPointDistribution;
@property (nonatomic, retain) NSString*      Localisation;
@property (nonatomic, retain) NSNumber*      PreAnnuleId;
@property (nonatomic, retain) NSString*      TYPE;
@property (nonatomic, retain) NSNumber* IdParution;


//liste de PEG_BeanHistoriqueParutionPresentoir
@property (nonatomic,retain) NSMutableArray* ListHistoriqueParutionPresentoir;

//liste de PEG_BeanTache
@property (nonatomic,retain) NSMutableArray* ListTache;

-(id) initBeanWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
-(NSMutableDictionary* ) objectModifiedToJson;
@end
