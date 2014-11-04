//
//  PEG_PresentoirServices.h
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "PEG_BeanMobilitePegase.h"
#import "BeanPresentoir.h"
#import "PEG_PresentoirServices.h"
#import "BeanChoix.h"
#import "BeanParution.h"

@interface PEG_PresentoirServices : NSObject

-(BeanPresentoir*) GetBeanPresentoirById:(NSNumber *)p_idPresentoir;
-(BeanParution*) GetParutionEnCoursByPresentoir:(BeanPresentoir*)p_BeanPresentoir;

-(void)UpdatePresentoirEmplacementByPresentoir:(BeanPresentoir*)p_BeanPresentoir andEmplacement:(NSString*)p_Emplacement;
-(void)UpdatePresentoirLocalisationByPresentoir:(BeanPresentoir*)p_BeanPresentoir andLocalisation:(NSString*)p_Localisation;

-(BOOL) IsTacheAFaireIsOnPresentoir:(NSString*)p_CodeMateriel andIdPresentoir:(NSNumber*)p_idPresentoir;
-(BOOL) IsTacheFaitIsOnPresentoir:(NSString*)p_CodeMateriel andIdPresentoir:(NSNumber*)p_idPresentoir;

-(BeanPresentoir*) CreateBeanPresentoirOnLieu:(BeanLieu *)p_BeanLieu andType:(NSString*)p_CodeTypePresentoir;
-(BeanPresentoir*) RemplacerBeanPresentoirOnLieu:(BeanLieu *)p_BeanLieu andBeanPresentoirOrigine:(BeanPresentoir*)p_PresentoirOrigine andType:(NSString*)p_CodeTypePresentoir;

-(void) AjouterJournalToPresentoir:(NSNumber*)p_idJournal andIdPresentoir:(NSNumber*)p_idPresentoir andLieu:(NSNumber*)p_idLieu;

-(void)SetPresentoirDeleted:(BeanPresentoir*)p_BeanPresentoir;

- (void) MAJParutionPresentoir;

-(NSMutableArray*) GetListPresentoirParutionByPresentoir:(BeanPresentoir*)p_Presentoir;

-(BOOL) IsAlertePhotoOnPresentoir:(BeanPresentoir*)p_Presentoir;
-(BOOL) IsPhotoEnRougeOnPresentoir:(BeanPresentoir*)p_Presentoir;
-(BOOL) IsPresentoirActif:(BeanPresentoir*)p_Presentoir;
@end
