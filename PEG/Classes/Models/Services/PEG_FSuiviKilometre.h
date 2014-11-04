//
//  PEG_ServiceSuiviKilometre.h
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PEG_BeanMobilitePegase.h"
#import "BeanSuiviKMUtilisateur.h"

@interface PEG_FSuiviKilometre : NSObject
//<PEG_BeanSuiviKMUtilisateurDataSource>

- (bool) IsKilometrageDuJourDejaSaisie:(NSString*)p_Matricule;

-(void) AddOrUpdateSuiviKilometragePourMatricule:(NSString *)p_Matricule andDate:(NSDate *)p_Date andKM:(NSNumber *)p_Km;
-(void) AddOrUpdateSuiviKilometragePourMatricule:(NSString *)p_Matricule andDate:(NSDate *)p_Date andKM:(NSNumber *)p_Km andFlagMAJ:(NSString*)p_FlagMAJ;
-(void) AddOrUpdateSuiviKilometragePourBeanSuiviKMUtilisateur:(BeanSuiviKMUtilisateur *)p_BeanSuiviKMUtilisateur;

#pragma mark Get
- (NSNumber*) GetDernierKilometrageByMatricule:(NSString*)p_Matricule;
- (NSString*) GetDernierKilometrageDesignByMatricule:(NSString*)p_Matricule;

#pragma mark Set
//-(void) SetSuiviKilometrageToSISynchronous;

@end
