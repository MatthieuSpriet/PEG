//
//  PEG_ActionPresentoirServices.h
//  PEG
//
//  Created by Horsmedia3 on 04/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanAction.h"
#import "BeanLieu.h"
#import "BeanPresentoir.h"
#import "PEG_BeanPoint.h"

@interface PEG_ActionPresentoirServices : NSObject
-(NSArray*) GetListBeanActionByIdLieuPassage:(NSNumber*)p_IdLieuPassage;

-(BeanAction*) CreateBeanActionForNewQteDistribuee:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution;
-(BeanAction*) CreateBeanActionForNewQteRetourBonEtat:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution;
-(BeanAction*) CreateBeanActionForNewQteRetour:(NSNumber*)p_Qte andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution;

-(void)AddOrUpdatePresentoirControleVisuelByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait;
-(BOOL)IsPresentoirControleVisuelByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdatePresentoirNettoyeByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait;
-(BOOL)IsPresentoirNettoyeByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdatePresentoirReplaceByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait;
-(BOOL)IsPresentoirReplaceByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdatePresentoirDeplaceByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait;
-(BOOL)IsPresentoirDeplaceByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdatePresentoirRemplaceByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdatePresentoirVoleByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdatePresentoirCreationByIdPresentoir:(NSNumber*)p_IdPresentoir;
-(void)UpdatePresentoirCreationByIdPresentoir:(NSNumber*)p_IdPresentoir andEmplacement:(NSString*)p_Emplacement andLocalisation:(NSString*)p_Localisation;
-(void)AddOrUpdatePresentoirSupprimeByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdateLieuRelationnelByIdLieu:(NSNumber*)p_IdLieu andFait:(BOOL)p_Fait;
-(BOOL)IsLieuRelationnelByIdLieu:(NSNumber*)p_IdLieu;

-(void)AddOrUpdatePresentoirPhoto:(NSNumber*)p_IdPresentoir andNomPhoto:(NSString*)p_NomPhoto andFait:(BOOL)p_Fait;
-(BOOL)IsPresentoirPhotoByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(void)AddOrUpdatePresentoirMaterielByIdPresentoir:(NSNumber*)p_IdPresentoir andCodeMateriel:(NSString*)p_CodeMateriel andFait:(BOOL)p_Fait;
-(BOOL)IsPresentoirMaterielByIdPresentoir:(NSNumber*)p_IdPresentoir andCodeMateriel:(NSString*)p_CodeMateriel;

//-(void)AddOrUpdatePresentoirApporterByIdPresentoir:(NSNumber*)p_IdPresentoir andFait:(BOOL)p_Fait;
//-(BOOL)IsPresentoirApporterByIdPresentoir:(NSNumber*)p_IdPresentoir;

-(NSArray*) GetBeanActionListCadeauByIdLieu:(NSNumber*)p_IdLieu;
-(void)AddOrUpdateCadeauByIdLieu:(NSNumber*)p_IdLieu andCodeCadeau:(NSString*)p_CodeCadeau andQte:(NSNumber*)p_NbCadeau;
-(void)DeleteCadeauByIdLieu:(NSNumber*)p_IdLieu andCodeCadeau:(NSString*)p_CodeCadeau;

-(void)AddOrUpdateLieuCoordonneeByIdLieu:(NSNumber*)p_IdLieu andBeanPoint:(PEG_BeanPoint*)p_BeanPoint;
-(BOOL)IsLieuCoordonneeByIdLieu:(NSNumber*)p_IdLieu;

-(void)UpdatePresentoirTacheByPresentoir:(BeanPresentoir*)p_BeanPresentoir andTache:(NSString*)p_Tache andFait:(BOOL)p_Fait andAFaire:(BOOL)p_AFaire;

-(void)AddLieuVisiteByIdLieu:(NSNumber*)p_IdLieu;
@end
