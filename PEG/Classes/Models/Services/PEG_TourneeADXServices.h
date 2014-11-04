//
//  PEG_TourneeADXServices.h
//  PEG
//
//  Created by Horsmedia3 on 19/05/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

// pm 140526: it was empty. I assume I should use it

#import <Foundation/Foundation.h>
#import "BeanTourneeADX.h"
#import "BeanActionADX.h"

@interface PEG_TourneeADXServices : NSObject

-(BeanTourneeADX*) GetTourneeByIdTournee:(NSNumber*)p_IdTournee;
-(NSArray*) GetTourneeBetweenDateDebut:(NSDate*)p_DtDebut andDateFin:(NSDate*)p_DateFin;
-(NSArray*) GetListeLieuPassageByTournee:(NSNumber*)p_IdTournee;
-(NSNumber*) GetNbTacheByTournee:(NSNumber*)p_IdTournee;
-(BeanActionADX*) GetBeanActionADXByIdParution:(NSNumber *)p_idParution;
-(NSString*) GetLibelleMagazinesForDesignByTournee:(BeanTourneeADX*)P_BeanTournee andNbCarTrunc:(int)p_NbCarTrunc andEntete:(BOOL)p_Entete;
-(NSMutableArray*) GetListPresentoirParutionByLieuPassageADX:(BeanLieuPassageADX*)p_Lieu;
-(NSNumber*) GetQteDistriByPresentoir:(NSNumber*)p_IdPresentoir andParutionRef:(NSNumber*)p_IdParutionRef andBeanLieuPassage:(BeanLieuPassageADX*)p_LieuPassage;
-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParutionRef:(NSNumber*)p_IdParutionRef andBeanLieuPassage:(BeanLieuPassageADX*)p_LieuPassage;
-(NSNumber*) GetQteRetourByPresentoir:(NSNumber*)p_IdPresentoir andParutionRef:(NSNumber*)p_IdParutionRef andBeanLieuPassage:(BeanLieuPassageADX*)p_LieuPassage;
-(BeanLieuPassageADX*) GetBeanLieuPassageADXById:(NSNumber *)p_idLieuPassage;

-(BOOL) IsCompteRenduTourneeDebuteeByIdTournee:(NSNumber*)p_IdTournee;
-(BOOL) IsCompteRenduTourneeTermineeByIdTournee:(NSNumber*)p_IdTournee;

@end
