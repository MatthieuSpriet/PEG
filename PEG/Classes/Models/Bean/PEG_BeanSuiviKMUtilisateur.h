//
//  PEG_BeanSuiviKMUtilisateur.h
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanSuiviKMUtilisateur.h"

@protocol PEG_BeanSuiviKMUtilisateurDataSource;

@interface PEG_BeanSuiviKMUtilisateur : NSObject

@property (nonatomic, retain) NSString* Matricule;
@property (nonatomic, retain) NSString* Nom;
@property (nonatomic, retain) NSString* Prenom;
@property (nonatomic, retain) NSString* CodeAgence;
@property (nonatomic, retain) NSString* CodeSociete;
@property (nonatomic, retain) NSString* CodePays;
@property (nonatomic, retain) NSString* CodeLangAppli;
@property (nonatomic, retain) NSDate* Date;
@property (nonatomic, retain) NSNumber* Kilometrage;
@property (nonatomic, retain) NSString* FlagMAJ;

-(id) initBeanWithJson :(NSDictionary*)p_json;
-(NSMutableDictionary* ) objectToJson;

#pragma mark Data-Access methods model
//Composant technique
@property (nonatomic,assign) id<PEG_BeanSuiviKMUtilisateurDataSource> observer;

- (void) GetLastSuiviKMUtilisateurWithObserver:(id<PEG_BeanSuiviKMUtilisateurDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule;

- (void) SetSuiviKMUtilisateurSynchronousWithObserver:(id<PEG_BeanSuiviKMUtilisateurDataSource>)p_ObserverOwner;

@end 

@protocol PEG_BeanSuiviKMUtilisateurDataSource <NSObject>

@optional
-(void) fillFinishedGetLastSuiviKMUtilisateur;
-(void) fillFinishedErrorGetLastSuiviKMUtilisateur;
-(void) fillFinishedSetSuiviKMUtilisateur;


@end
