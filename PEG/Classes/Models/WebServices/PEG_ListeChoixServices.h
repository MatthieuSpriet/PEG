//
//  PEG_ListeChoixServices.h
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanChoix.h"
//#import "PEG_BeanMobilitePegase.h"
#import "PEGException.h"
#import "BeanCPCommune.h"

@interface PEG_ListeChoixServices : NSObject


-(NSArray*) GetListBeanChoixMaterielByTypePresentoir:(NSString*)p_TypePres;
-(BOOL) IsChoixMateriel:(NSString*)p_CodeChoix;
-(NSArray*) GetListBeanChoixInfosADX;
-(NSArray*) GetListBeanChoixEtatLieu;
-(NSString*) GetLibelleEtatLieuByCode:(NSString*)p_Code;
-(NSString*) GetCodeEtatLieuByLibelle:(NSString*)p_Libelle;
-(NSArray*) GetListBeanChoixEmplacementPresentoir;
-(NSArray*) GetListBeanChoixFamillePresentoir;
-(NSArray*) GetListBeanChoixTypePresentoir;
-(NSArray*) GetListBeanChoixTypePresentoirByCodeFamille:(NSString*)p_CodeFamille;
-(NSArray*) GetListBeanChoixCadeau;
-(NSString*) GetLibelleCadeauxByCode:(NSString*)p_Code;
-(NSArray*) GetListBeanChoixTypeVoie;
-(NSString*) GetLibelleTypeVoieByCode:(NSString*)p_Code;
-(NSString*) GetCodeTypeVoieByLibelle:(NSString*)p_Libelle;
-(NSArray*) GetListBeanChoixLiaison;
-(NSString*) GetLibelleLiaisonByCode:(NSString*)p_Code;
-(NSString*) GetCodeLiaisonByLibelle:(NSString*)p_Libelle;
-(NSArray*) GetListBeanChoixNoVoieBisTer;
-(NSArray*) GetListBeanChoixCivilite;
-(NSArray*) GetListBeanChoixActivite;
-(NSString*) GetLibelleActiviteByCode:(NSString*)p_Code;
-(NSString*) GetCodeActiviteByLibelle:(NSString*)p_Libelle;
-(NSArray*) GetListBeanCPCommune;
-(BeanCPCommune*) GetBeanCPCommuneByCodeCP:(NSNumber*)p_CP;
-(BeanCPCommune*) GetBeanCPCommuneByLibelleCommune:(NSString*)p_commune;

-(BeanChoix*) GetBeanChoixByCode:(NSNumber*)p_Code andCategorie:(NSString *)p_Categorie;
@end
