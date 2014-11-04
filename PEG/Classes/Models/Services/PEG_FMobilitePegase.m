//
//  PEG_FMobilitePegase.m
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_FMobilitePegase.h"


@implementation PEG_FMobilitePegase
+(PEG_MobilitePegaseService*) CreateMobilitePegaseService{

    return [[PEG_MobilitePegaseService alloc]init];
    
}

+(PEG_FSuiviKilometre*) CreateSuiviKilometre{
    
    return [[PEG_FSuiviKilometre alloc]init];
    
}

+(PEG_TourneeServices*) CreateTournee{
    
    return [[PEG_TourneeServices alloc]init];
    
}

+(PEG_LieuServices*) CreateLieu{
    
    return [[PEG_LieuServices alloc]init];
    
}

+(PEG_ParutionServices*) CreateParution{
    
    return [[PEG_ParutionServices alloc]init];
    
}

+(PEG_ListeChoixServices*) CreateListeChoix{
    
    return [[PEG_ListeChoixServices alloc]init];
    
}

+(PEG_PresentoirServices*) CreatePresentoir{
    
    return [[PEG_PresentoirServices alloc]init];
    
}

+(PEG_CoreDataServices*) CreateCoreData{
    return [[PEG_CoreDataServices alloc]init];
}

+(PEG_ConcurrentServices*) CreateConcurrent{
    
    return [[PEG_ConcurrentServices alloc]init];
    
}

+(PEG_ActionPresentoirServices*) CreateActionPresentoir
{
    return [[PEG_ActionPresentoirServices alloc]init];
}


+(PEG_ImageServices*) CreateImage
{
    return [[PEG_ImageServices alloc]init];
}

+(PEG_TourneeADXServices*) CreateTourneeADX
{
    return [[PEG_TourneeADXServices alloc]init];
}

+(PEG_ActionPresentoirADXServices*) CreateActionPresentoirADX
{
    return [[PEG_ActionPresentoirADXServices alloc]init];
}

+(PEG_GoogleAnalyticsServices*) CreateGoogleAnalytics
{
    return [[PEG_GoogleAnalyticsServices alloc]init];
}

@end
