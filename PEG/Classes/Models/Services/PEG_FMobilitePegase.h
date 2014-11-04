//
//  PEG_FMobilitePegase.h
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEG_MobilitePegaseService.h"
#import "PEG_FSuiviKilometre.h"
#import "PEG_TourneeServices.h"
#import "PEG_LieuServices.h"
#import "PEG_ParutionServices.h"
//#import "PEG_BeanConcurents.h"
#import "PEG_ListeChoixServices.h"
#import "PEG_PresentoirServices.h"
#import "PEG_CoreDataServices.h"
#import "PEG_ConcurrentServices.h"
#import "PEG_ActionPresentoirServices.h"
#import "PEG_ImageServices.h"
#import "PEG_TourneeADXServices.h"
#import "PEG_ActionPresentoirADXServices.h"
#import "PEG_GoogleAnalyticsServices.h"

@interface PEG_FMobilitePegase : NSObject

+(PEG_MobilitePegaseService*) CreateMobilitePegaseService;
+(PEG_FSuiviKilometre*) CreateSuiviKilometre;
+(PEG_TourneeServices*) CreateTournee;
+(PEG_LieuServices*) CreateLieu;
+(PEG_ParutionServices*) CreateParution;
+(PEG_ListeChoixServices*) CreateListeChoix;
+(PEG_PresentoirServices*) CreatePresentoir;
+(PEG_CoreDataServices*) CreateCoreData;
+(PEG_ConcurrentServices*) CreateConcurrent;
+(PEG_ActionPresentoirServices*) CreateActionPresentoir;
+(PEG_ImageServices*) CreateImage;
+(PEG_TourneeADXServices*) CreateTourneeADX;
+(PEG_ActionPresentoirADXServices*) CreateActionPresentoirADX;
+(PEG_GoogleAnalyticsServices*) CreateGoogleAnalytics;

@end
