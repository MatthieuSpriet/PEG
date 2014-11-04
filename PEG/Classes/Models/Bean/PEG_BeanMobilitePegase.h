//
//  PEG_BeanMobilitePegase.h
//  PEG
//
//  Created by 10_200_11_120 on 07/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEG_BeanSuiviKMUtilisateur.h"
#import "PEG_BeanCPCommune.h"
#import "PEG_BeanConcurents.h"
#import "PEG_BeanParution.h"
#import "PEG_BeanChoix.h"


@interface PEG_BeanMobilitePegase : NSObject

#pragma mark Singleton
+ (PEG_BeanMobilitePegase *)sharedInstance;


#pragma mark Proprietes
//liste de PEG_BeanSuiviKMUtilisateur
@property (nonatomic,retain) NSMutableArray* ListSuiviKMUtilisateur;

//liste de PEG_BeanTournee
@property (nonatomic,retain) NSMutableArray* ListTournee;

//liste de PEG_BeanLieu
@property (nonatomic,retain) NSMutableArray* ListLieu;

//liste de PEG_BeanConcurents
@property (nonatomic,retain) NSMutableArray* ListConcurents;

//liste de PEG_BeanCPCommune
@property (nonatomic,retain) NSMutableArray* ListCommune;

//liste de PEG_BeanParution
@property (nonatomic,retain) NSMutableArray* ListParution;

//liste de PEG_BeanChoix
@property (nonatomic,retain) NSMutableArray* ListChoix;


-(NSMutableDictionary* ) objectToJson;
-(NSMutableDictionary* ) objectModifiedToJson;
@end

