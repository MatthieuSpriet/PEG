//
//  BeanLieu.h
//  PEG
//
//  Created by Horsmedia3 on 26/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanConcurentLieu, BeanHoraire, BeanMobilitePegase, BeanPresentoir, BeanTache;

@interface BeanLieu : NSManagedObject

@property (nonatomic, strong) NSNumber * aucunConcurent;
@property (nonatomic, strong) NSString * codeActivite;
@property (nonatomic, strong) NSString * codeEtatLieu;
@property (nonatomic, strong) NSString * codePays;
@property (nonatomic, strong) NSString * codePostal;
@property (nonatomic, strong) NSString * codePostalComplement;
@property (nonatomic, strong) NSString * codeProchainEtatLieu;
@property (nonatomic, strong) NSString * commentaire;
@property (nonatomic, strong) NSString * complement;
@property (nonatomic, strong) NSDecimalNumber * coordX;
@property (nonatomic, strong) NSDecimalNumber * coordXpda;
@property (nonatomic, strong) NSDecimalNumber * coordY;
@property (nonatomic, strong) NSDecimalNumber * coordYpda;
@property (nonatomic, strong) NSDate * dateCreation;
@property (nonatomic, strong) NSDate * dateDerniereVisite;
@property (nonatomic, strong) NSDate * dateIntention;
@property (nonatomic, strong) NSDate * dateProchainEtatLieu;
@property (nonatomic, strong) NSNumber * dist;
@property (nonatomic, strong) NSString * etat;
@property (nonatomic, strong) NSString * flagMAJ;
@property (nonatomic, strong) NSString * gUIDLieu;
@property (nonatomic, strong) NSNumber * idLieu;
@property (nonatomic, strong) NSString * intersection;
@property (nonatomic, strong) NSString * liaisonVoie;
@property (nonatomic, strong) NSString * liInfoSupp;
@property (nonatomic, strong) NSString * liNomLieu;
@property (nonatomic, strong) NSString * nomBatiment;
@property (nonatomic, strong) NSString * nomDirecteurVoie;
@property (nonatomic, strong) NSString * nomVoie;
@property (nonatomic, strong) NSNumber * noVoie;
@property (nonatomic, strong) NSString * noVoieComplement;
@property (nonatomic, strong) NSNumber * ouvert247;
@property (nonatomic, strong) NSString * prefixDirectionVoie;
@property (nonatomic, strong) NSNumber * proprietaire;
@property (nonatomic, strong) NSString * respCivilite;
@property (nonatomic, strong) NSString * respNom;
@property (nonatomic, strong) NSString * respTel;
@property (nonatomic, strong) NSString * service;
@property (nonatomic, strong) NSString * suffixDirectionVoie;
@property (nonatomic, strong) NSString * typeVoie;
@property (nonatomic, strong) NSNumber * vfClientMag;
@property (nonatomic, strong) NSNumber * vfExclusif;
@property (nonatomic, strong) NSString * ville;
@property (nonatomic, strong) NSSet *listConcurentLieu;
@property (nonatomic, strong) NSSet *listHoraire;
@property (nonatomic, strong) NSSet *listPresentoir;
@property (nonatomic, strong) NSSet *listTache;
@property (nonatomic, strong) BeanMobilitePegase *parentMobilitePegase;
@end

@interface BeanLieu (CoreDataGeneratedAccessors)

- (void)addListConcurentLieuObject:(BeanConcurentLieu *)value;
- (void)removeListConcurentLieuObject:(BeanConcurentLieu *)value;
- (void)addListConcurentLieu:(NSSet *)values;
- (void)removeListConcurentLieu:(NSSet *)values;

- (void)addListHoraireObject:(BeanHoraire *)value;
- (void)removeListHoraireObject:(BeanHoraire *)value;
- (void)addListHoraire:(NSSet *)values;
- (void)removeListHoraire:(NSSet *)values;

- (void)addListPresentoirObject:(BeanPresentoir *)value;
- (void)removeListPresentoirObject:(BeanPresentoir *)value;
- (void)addListPresentoir:(NSSet *)values;
- (void)removeListPresentoir:(NSSet *)values;

- (void)addListTacheObject:(BeanTache *)value;
- (void)removeListTacheObject:(BeanTache *)value;
- (void)addListTache:(NSSet *)values;
- (void)removeListTache:(NSSet *)values;

@end
