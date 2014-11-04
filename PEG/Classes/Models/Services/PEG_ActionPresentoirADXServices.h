//
//  PEG_ActionPresentoirADXServices.h
//  PEG
//
//  Created by Pierre Marty on 28/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanActionADX.h"
@class BeanPresentoir;

@interface PEG_ActionPresentoirADXServices : NSObject


-(void)UpdatePresentoirTacheByPresentoir:(NSNumber*)p_idPresentoir andTache:(NSString*)p_Tache andAFaire:(BOOL)p_AFaire;
-(void)UpdateLieuTacheByLieu:(NSNumber*)p_idLieu andTache:(NSString*)p_Tache andAFaire:(BOOL)p_AFaire;

-(void) AddOrUpdateQteDistribueByIdLieuPassageADX:(NSNumber*)p_IdLieuPassageADX andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionRef:(NSNumber*)p_IdParutionRef andIdEditionRef:(NSNumber*)p_IdEditionRef andQte:(NSNumber*)p_Qte;

-(void) AddOrUpdateQteRetourByIdLieuPassageADX:(NSNumber*)p_IdLieuPassageADX andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionPrecRef:(NSNumber*)p_IdParutionPrecRef andIdEditionRef:(NSNumber*)p_IdEditionRef andQte:(NSNumber*)p_Qte;

-(BeanActionADX*) CreateBeanActionADXForNewQteDistribuee:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionRef:(NSNumber*)p_IdParutionRef andIdEditionRef:(NSNumber*)p_IdEditionRef;

-(BeanActionADX*) CreateBeanActionADXForNewQteRetour:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParutionRef:(NSNumber*)p_IdParutionRef andIdEditionRef:(NSNumber*)p_IdEditionRef;
@end
