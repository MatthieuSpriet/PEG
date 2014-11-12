//
//  PEG_MobilitePegaseService.h
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanMobilitePegase.h"

@protocol PEG_MobilitePegaseServiceDataSource;
@protocol PEG_BeanSuiviKMUtilisateurDataSource;

@interface PEG_MobilitePegaseService : NSObject

-(void) AppelAssistance;
-(BOOL) IsChangementJourDepuisDerniereSynchro;
-(NSArray*) GetAllBeanMobilitePegase;
-(BeanMobilitePegase*) GetOrCreateBeanMobilitePegaseByMatricule:(NSString*)p_Matricule;
-(BeanMobilitePegase*) GetBeanMobilitePegaseByMatricule:(NSString*)p_Matricule;

#pragma mark Data-Access methods model

//Composant technique
@property (nonatomic,weak) id<PEG_MobilitePegaseServiceDataSource> observerMP;

@property (nonatomic,weak) id<PEG_BeanSuiviKMUtilisateurDataSource> observerKM;
- (void) GetLastSuiviKMUtilisateurWithObserver:(id<PEG_BeanSuiviKMUtilisateurDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule;

@end

@protocol PEG_MobilitePegaseServiceDataSource <NSObject>

@optional
-(void) fillFinishedGetBeanMobilitePegase;
-(void) finishedWithErrorGetBeanMobilitePegase;

-(void) fillFinishedGetBeanTournee;
-(void) finishedWithErrorGetBeanTournee;

-(void) fillFinishedSaveBeanMobilitePegase;
-(void) fillFinishedSaveWithErrorBeanMobilitePegase:(NSError*)p_Error;

@end

@protocol PEG_BeanSuiviKMUtilisateurDataSource <NSObject>

@optional
-(void) fillFinishedGetLastSuiviKMUtilisateur;
-(void) fillFinishedErrorGetLastSuiviKMUtilisateur;
-(void) fillFinishedSetSuiviKMUtilisateur;


@end
