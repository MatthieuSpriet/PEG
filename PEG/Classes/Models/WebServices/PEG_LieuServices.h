//
//  PEG_LieuServices.h
//  PEG
//
//  Created by 10_200_11_120 on 01/07/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanLieu.h"
#import "BeanLieuPassage.h"
//#import "PEG_BeanTournee.h"
//#import "PEG_BeanMobilitePegase.h"
#import "PEG_BeanPoint.h"
//#import "PEG_BeanConcurents.h"

@interface PEG_LieuServices : NSObject

-(NSArray*) GetAllBeanLieuActif;
-(NSArray*) GetAllBeanLieuActifAvecCoordGPS;
-(NSArray*) GetAllBeanLieuEnAlerte;
-(NSArray*) GetAllBeanLieuInactif;
-(BeanLieu*) GetBeanLieuById:(NSNumber *)p_idLieu;
-(BOOL) isLieuActif:(NSNumber *)p_idLieu;
-(NSMutableArray*) GetListeBeanLieuByDistance:(NSNumber *)p_DistanceMetre AndPoint:(PEG_BeanPoint*)p_Point;

-(BeanLieuPassage*) GetBeanLieuPassageById:(NSNumber *)p_idLieuPassage;
-(BeanLieuPassage*) GetBeanLieuPassageByIdLieu:(NSNumber *)p_idLieu andIdTournee:(NSNumber*)p_idTournee;
-(BeanLieuPassage*) GetBeanLieuPassageOnTourneeMerchByIdLieu:(NSNumber *)p_idLieu;
-(BeanLieuPassage*) GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:(NSNumber *)p_idLieu;

-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution;
-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage;
-(NSNumber*) GetQteDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSNumber*) GetQteDistriByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage;
-(NSNumber*) GetHistoQteDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSNumber*) GetQteRetourBonEtatByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSNumber*) GetQteRetourByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSNumber*) GetQteRetourByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution andBeanLieuPassage:(BeanLieuPassage*)p_LieuPassage;
-(NSNumber*) GetHistoQteRetourByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSArray*) GetHistoListDateDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSArray*) GetHistoListQteDistribueeByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSArray*) GetListHistoDistriByIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution;
-(NSArray*) GetListHistoDistriByIdPresentoir:(NSNumber*)p_idPresentoir andIdEdition:(NSNumber*)p_idEdition;

-(void) AddOrUpdateQteDistribueByIdLieu:(NSNumber*)p_IdLieu andIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution andQte:(NSNumber*)p_Qte;
-(void) AddOrUpdateQteRetourBonEtatByIdLieu:(NSNumber*)p_IdLieu andIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution andQte:(NSNumber*)p_Qte;
-(void) AddOrUpdateQteRetourParutionPrecByIdLieu:(NSNumber*)p_IdLieu andIdPresentoir:(NSNumber*)p_idPresentoir andIdParution:(NSNumber*)p_idParution andQte:(NSNumber*)p_Qte;

-(NSMutableArray*) GetListeBeanLieuWithTache;

-(BOOL) IsTacheAFaireIsOnLieu:(NSString*)p_CodeMateriel andIdLieu:(NSNumber*)p_idLieu;
-(BOOL) IsTacheAFaireMaterielOnLieu:(NSNumber*)p_idLieu;
-(BOOL) IsTacheAFairePhotoOnLieu:(NSNumber*)p_idLieu;
-(BOOL) IsTacheAFaireApporterPresentoirOnLieu:(NSNumber*)p_idLieu;
-(int) GetNbAllTacheForLieu:(BeanLieu*)p_Lieu;
-(int) GetNbTacheForAllLieu;
-(int) GetNbTachePhotoForAllLieu;
-(int) GetNbTacheMaterielForAllLieu;


-(NSNumber*) GetDistanceMetreEntreDeuxPoint1:(PEG_BeanPoint*)p_Point1 AndPoint2:(PEG_BeanPoint*)p_Point2;

-(NSString*) GetAdresseComplete:(BeanLieu*)p_Lieu;
-(BOOL) IsLivrable247:(BeanLieu*)p_Lieu;
-(void) UpdateLivrable247:(BeanLieu*)p_BeanLieu andLivrable247:(BOOL)p_VFLivrable247;

-(NSMutableArray*) GetHorairesComplet:(BeanLieu*)p_BeanLieu;
-(BeanHoraire*) GetBeanHoraireByIndex:(NSUInteger) v_Index andLieu:(BeanLieu*)p_BeanLieu;
-(void) AddOrReplaceHoraireFormSemaineCompleteForAMDebut:(NSDate*)p_AMDebut andAMFin:(NSDate*)p_AMFin andPMDebut:(NSDate*)p_PMDebut andPMFin:(NSDate*)p_PMFin andLieu:(BeanLieu*)p_BeanLieu;
-(void) AddOrReplaceHoraireForJour:(NSNumber*)p_Jour andAMDebut:(NSDate*)p_AMDebut andAMFin:(NSDate*)p_AMFin andPMDebut:(NSDate*)p_PMDebut andPMFin:(NSDate*)p_PMFin  andLieu:(BeanLieu*)p_BeanLieu;

-(void)UpdateLieuExclusifByLieu:(BeanLieu*)p_BeanLieu andExclusif:(BOOL)p_Exclusif;
-(void)UpdateLieuClientMagByLieu:(BeanLieu*)p_BeanLieu andClientMag:(BOOL)p_ClientMag;

-(BeanLieu*) CreateBeanLieu;
-(void) AnnuleCreateBeanLieu:(NSNumber*)p_IdLieu;

-(int) GetNbPresentoir:(BeanLieu*)p_BeanLieu;
-(NSMutableArray*) GetListPresentoirParutionTourneeMerchByLieu:(BeanLieu*)p_Lieu;
-(NSMutableArray*) GetListPresentoirParutionByLieu:(BeanLieu*)p_Lieu andIdTournee:(NSNumber*)p_IdTournee;

-(void) SetLieuInactif:(NSNumber*)p_idLieu;

-(BOOL)IsLieuEnAlerte:(BeanLieu*)p_BeanLieu;
-(void)SetDateDerniereVisiteByIdLieu:(NSNumber*)p_IdLieu;

-(void)AddOrUpdateApporterPresentoirByIdLieu:(NSNumber*)p_IdLieu andFait:(BOOL)p_Fait;
-(BOOL)IsApporterPresentoirByIdLieu:(NSNumber*)p_IdLieu;
-(void)UpdateTachePresentoirByLieu:(BeanLieu*)p_BeanLieu andTache:(NSString*)p_Tache andFait:(BOOL)p_Fait andAFaire:(BOOL)p_AFaire;

@end
