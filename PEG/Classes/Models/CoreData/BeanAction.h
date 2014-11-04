//
//  BeanAction.h
//  PEG
//
//  Created by Horsmedia3 on 22/04/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanLieuPassage;

@interface BeanAction : NSManagedObject

@property (nonatomic, retain) NSString * codeAction;
@property (nonatomic, retain) NSNumber * coordGPSFiable;
@property (nonatomic, retain) NSNumber * coordX;
@property (nonatomic, retain) NSNumber * coordY;
@property (nonatomic, retain) NSDate * dateAction;
@property (nonatomic, retain) NSString * emplacement;
@property (nonatomic, retain) NSString * flagMAJ;
@property (nonatomic, retain) NSString * guidPresentoir;
@property (nonatomic, retain) NSNumber * idLieu;
@property (nonatomic, retain) NSNumber * idParution;
@property (nonatomic, retain) NSNumber * idParutionRef;
@property (nonatomic, retain) NSNumber * idPointDistribution;
@property (nonatomic, retain) NSNumber * idPresentoir;
@property (nonatomic, retain) NSString * localisation;
@property (nonatomic, retain) NSNumber * quantiteDistribuee;
@property (nonatomic, retain) NSNumber * quantitePrevue;
@property (nonatomic, retain) NSNumber * quantiteRecuperee;
@property (nonatomic, retain) NSString * typePresentoir;
@property (nonatomic, retain) NSNumber * valeurInt;
@property (nonatomic, retain) NSString * valeurTexte;
@property (nonatomic, retain) NSNumber * idEditionRef;
@property (nonatomic, retain) BeanLieuPassage *parentLieuPassage;

@end
