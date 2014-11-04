//
//  BeanActionADX.h
//  PEG
//
//  Created by Horsmedia3 on 30/05/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanLieuPassageADX;

@interface BeanActionADX : NSManagedObject

@property (nonatomic, retain) NSString * codeAction;
@property (nonatomic, retain) NSString * codeTypePresentoir;
@property (nonatomic, retain) NSNumber * idEditionRef;
@property (nonatomic, retain) NSNumber * idLieu;
@property (nonatomic, retain) NSNumber * idParution;
@property (nonatomic, retain) NSNumber * idParutionRef;
@property (nonatomic, retain) NSNumber * idParutionRefPrec;
@property (nonatomic, retain) NSNumber * idPresentoir;
@property (nonatomic, retain) NSNumber * quantiteDistribuee;
@property (nonatomic, retain) NSNumber * quantitePrevue;
@property (nonatomic, retain) NSNumber * quantiteRecuperee;
@property (nonatomic, retain) NSNumber * valeurInt;
@property (nonatomic, retain) NSString * valeurTexte;
@property (nonatomic, retain) NSString * libEdition;
@property (nonatomic, retain) NSString * flagMAJ;
@property (nonatomic, retain) BeanLieuPassageADX *parentLieuPassageADX;

@end
