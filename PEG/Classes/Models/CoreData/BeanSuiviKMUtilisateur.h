//
//  BeanSuiviKMUtilisateur.h
//  PEG
//
//  Created by Horsmedia3 on 12/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanMobilitePegase;

@interface BeanSuiviKMUtilisateur : NSManagedObject

@property (nonatomic, strong) NSString * codeAgence;
@property (nonatomic, strong) NSString * codeLangAppli;
@property (nonatomic, strong) NSString * codePays;
@property (nonatomic, strong) NSString * codeSociete;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * flagMAJ;
@property (nonatomic, strong) NSNumber * kilometrage;
@property (nonatomic, strong) NSString * matricule;
@property (nonatomic, strong) NSString * nom;
@property (nonatomic, strong) NSString * prenom;
@property (nonatomic, strong) BeanMobilitePegase *parentMobilitePegase;

@end
