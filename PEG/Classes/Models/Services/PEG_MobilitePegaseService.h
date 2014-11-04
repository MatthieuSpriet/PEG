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

#pragma mark Persistance du bean
//-(void) SaveBeanMobilitePegaseInFile:(PEG_BeanMobilitePegase*) p_PEG_BeanMobilitePegase;
//-(void) SaveBeanMobiliteModifiedPegaseInFile:(PEG_BeanMobilitePegase*) p_PEG_BeanMobilitePegase;

//-(PEG_BeanMobilitePegase*) GetBeanMobilitePegaseFromFile;

//- (void) FromNSDictionaryToBeanByJSON:(NSDictionary*) p_dico andBeanMobilitePegaseToFill:(PEG_BeanMobilitePegase*)p_ObjectToFill;
//- (void) FromNSDictionaryToCDByJSON:(NSDictionary*) p_dico;
//- (PEG_BeanMobilitePegase*)FromStringToBeanByJSON:(NSString*) p_string;

//- (NSString*)FromBeanToStringByJSON:(PEG_BeanMobilitePegase*) p_PEG_BeanMobilitePegase;
#pragma mark Data-Access methods model

//Composant technique
@property (nonatomic,weak) id<PEG_MobilitePegaseServiceDataSource> observerMP;
- (void) GetBeanMobilitePegaseWithObserver:(id<PEG_MobilitePegaseServiceDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule andDate:(NSDate*) p_date;
- (void) GetBeanTourneeWithObserver:(id<PEG_MobilitePegaseServiceDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule andDateDebut:(NSDate*) p_dateDebut andDateFin:(NSDate*) p_dateFin;
- (void) SaveBeanMobilitePegaseWithObserver:(id<PEG_MobilitePegaseServiceDataSource>)p_ObserverOwner;


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
