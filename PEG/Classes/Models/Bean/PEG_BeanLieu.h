//
//  PEG_BeanLieu.h
//  PEG
//
//  Created by 10_200_11_120 on 20/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEG_BeanHoraire.h"


@interface PEG_BeanLieu : NSObject

@property (nonatomic, retain) NSNumber* IdLieu;
@property (nonatomic, retain) NSString* GUIDLieu;
@property (nonatomic, retain) NSString* LiNomLieu;
@property (nonatomic, retain) NSString* LiInfoSupp;
@property (nonatomic, retain) NSNumber* NoVoie;
@property (nonatomic, retain) NSString* NoVoieComplement;
@property (nonatomic, retain) NSString* PrefixDirectionVoie;
@property (nonatomic, retain) NSString* TypeVoie;
@property (nonatomic, retain) NSString* LiaisonVoie;
@property (nonatomic, retain) NSString* NomVoie;
@property (nonatomic, retain) NSString* NomDirecteurVoie;
@property (nonatomic, retain) NSString* SuffixDirectionVoie;
@property (nonatomic, retain) NSString* CodePostal;
@property (nonatomic, retain) NSString* CodePostalComplement;
@property (nonatomic, retain) NSString* Ville;
@property (nonatomic, retain) NSString* Intersection;
@property (nonatomic, retain) NSString* NomBatiment;
@property (nonatomic, retain) NSString* Service;
@property (nonatomic, retain) NSString* Complement;
@property (nonatomic, retain) NSString* Etat;
@property (nonatomic, retain) NSString* CodePays;
@property (nonatomic, retain) NSString* CodeEtatLieu;
@property (nonatomic, retain) NSString* CodeProchainEtatLieu;
@property (nonatomic, retain) NSDate* DateProchainEtatLieu;
@property (nonatomic, retain) NSNumber* CoordX;
@property (nonatomic, retain) NSNumber* CoordY;
@property (nonatomic, retain) NSNumber* CoordXpda;
@property (nonatomic, retain) NSNumber* CoordYpda;
@property (nonatomic, assign) BOOL Proprietaire;
@property (nonatomic, retain) NSDate* DateCreation;
@property (nonatomic, retain) NSDate* DateDerniereVisite;
@property (nonatomic, assign) BOOL VfClientMag;
@property (nonatomic, assign) BOOL VfExclusif;
@property (nonatomic, retain) NSString* FlagMAJ;

@property (nonatomic, retain) NSString* RespCivilite;
@property (nonatomic, retain) NSString* RespNom;
@property (nonatomic, retain) NSString* RespTel;
@property (nonatomic, retain) NSString* CodeActivite;
@property (nonatomic, assign) BOOL Ouvert247;
@property (nonatomic, retain) NSString* Commentaire;
@property (nonatomic, retain) NSDate* DateIntention;
@property (nonatomic, retain) NSNumber* Dist;
@property (nonatomic, assign) BOOL AucunConcurent;

@property (nonatomic, retain) NSString* ProchEtatCode;
@property (nonatomic, retain) NSDate* ProchEtatDate;
//liste de PEG_BeanPresentoir
@property (nonatomic,retain) NSMutableArray* ListPresentoir;

//liste de PEG_BeanConcurentLieu
@property (nonatomic,retain) NSMutableArray* ListConcurentLieu;

//liste de PEG_BeanHoraire
@property (nonatomic,retain) NSMutableArray* ListHoraire;


-(id) initBeanWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;
-(NSMutableDictionary* ) objectModifiedToJson;
-(NSString*) GetAdresseComplete;
-(BOOL) IsLivrable247;
-(NSMutableArray*) GetHorairesComplet;
-(PEG_BeanHoraire*) GetBeanHoraireByIndex:(NSUInteger) v_Index;
-(void) AddOrReplaceHoraire:(PEG_BeanHoraire*) v_BeanHoraire;

@end
