//
//  PEG_BeanPointDsgn.h
//  PEG
//
//  Created by 10_200_11_120 on 09/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanPointDsgn : NSObject

@property (nonatomic, strong) NSNumber* IdLieuPassage;
@property (nonatomic, strong) NSNumber* IdLieu;
@property (nonatomic, strong) NSNumber* IdPresentoir;
@property (nonatomic, strong) NSNumber* IdParution;
@property (nonatomic, strong) NSNumber* IdParutionPrec;
@property (nonatomic, strong) NSNumber* IdParutionRef;
@property (nonatomic, strong) NSNumber* IdParutionPrecRef;
@property (nonatomic, strong) NSNumber* IdEditionRef;
@property (nonatomic, assign) BOOL IsBacSecondaire;
@property (nonatomic, strong) NSNumber* NbMetre;
@property (nonatomic, strong) NSNumber* NbSemaine;
@property (nonatomic, assign) BOOL IsLieuAlerte;


@property (strong, nonatomic) NSString* NumeroPoint;
@property (strong, nonatomic) NSString* NomPoint;
@property (strong, nonatomic) NSNumber* NombreTache;
@property (strong, nonatomic) NSString* TypePresentoir;
@property (strong, nonatomic) NSString* Commune;
@property (strong, nonatomic) NSString* Parution;
@property (strong, nonatomic) NSNumber* QuantitePreparee;
@property (strong, nonatomic) NSNumber* QuantiteDistribuee;
@property (strong, nonatomic) NSNumber* QuantiteRetour;


@property (strong, nonatomic) NSString* TypePresentoir2;
@property (strong, nonatomic) NSString* Parution2;
@property (strong, nonatomic) NSNumber* QuantiteDistribuee2;
@property (strong, nonatomic) NSNumber* QuantiteRetour2;

@property (nonatomic, assign) BOOL PlusDeTroisPresentoir;

@property (strong, nonatomic) NSString* ListeTypePresentoirString;
@property (strong, nonatomic) NSString* Adresse;

- (NSComparisonResult)compareMetre:(PEG_BeanPointDsgn *)otherObject;
- (NSComparisonResult)compareNomAdresse:(PEG_BeanPointDsgn *)otherObject;
@end
