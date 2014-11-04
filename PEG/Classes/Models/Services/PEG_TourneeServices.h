//
//  PEG_TourneeServices.h
//  PEG
//
//  Created by 10_200_11_120 on 26/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanTournee.h"

@interface PEG_TourneeServices : NSObject

-(BeanTournee*) GetTourneeByIdTournee:(NSNumber*)p_IdTournee;
-(NSArray*) GetTourneeBetweenDateDebut:(NSDate*)p_DtDebut andDateFin:(NSDate*)p_DateFin;
-(BeanTournee*) GetTourneeMerchDuJour;
-(NSArray*) GetListeLieuPassageByTournee:(NSNumber*)p_IdTournee;
-(NSNumber*) GetNbTacheByTournee:(NSNumber*)p_IdTournee;
-(NSString*) GetLibelleMagazinesForDesignByTournee:(BeanTournee*)P_BeanTournee andNbCarTrunc:(int)p_NbCarTrunc andEntete:(BOOL)p_Entete;

/*-(NSNumber*) GetQteDistriByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage;
-(NSNumber*) GetQteRetourByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage;*/


@end
