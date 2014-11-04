//
//  BeanMobilitePegase.h
//  PEG
//
//  Created by Horsmedia3 on 19/05/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanCPCommune, BeanChoix, BeanConcurents, BeanLieu, BeanParution, BeanSuiviKMUtilisateur, BeanTournee, BeanTourneeADX;

@interface BeanMobilitePegase : NSManagedObject

@property (nonatomic, retain) NSDate * dateSynchro;
@property (nonatomic, retain) NSString * matricule;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSSet *listChoix;
@property (nonatomic, retain) NSSet *listCommune;
@property (nonatomic, retain) NSSet *listConcurents;
@property (nonatomic, retain) NSSet *listLieu;
@property (nonatomic, retain) NSSet *listParution;
@property (nonatomic, retain) NSSet *listSuiviKMUtilisateur;
@property (nonatomic, retain) NSSet *listTournee;
@property (nonatomic, retain) NSSet *listTourneeADX;
@end

@interface BeanMobilitePegase (CoreDataGeneratedAccessors)

- (void)addListChoixObject:(BeanChoix *)value;
- (void)removeListChoixObject:(BeanChoix *)value;
- (void)addListChoix:(NSSet *)values;
- (void)removeListChoix:(NSSet *)values;

- (void)addListCommuneObject:(BeanCPCommune *)value;
- (void)removeListCommuneObject:(BeanCPCommune *)value;
- (void)addListCommune:(NSSet *)values;
- (void)removeListCommune:(NSSet *)values;

- (void)addListConcurentsObject:(BeanConcurents *)value;
- (void)removeListConcurentsObject:(BeanConcurents *)value;
- (void)addListConcurents:(NSSet *)values;
- (void)removeListConcurents:(NSSet *)values;

- (void)addListLieuObject:(BeanLieu *)value;
- (void)removeListLieuObject:(BeanLieu *)value;
- (void)addListLieu:(NSSet *)values;
- (void)removeListLieu:(NSSet *)values;

- (void)addListParutionObject:(BeanParution *)value;
- (void)removeListParutionObject:(BeanParution *)value;
- (void)addListParution:(NSSet *)values;
- (void)removeListParution:(NSSet *)values;

- (void)addListSuiviKMUtilisateurObject:(BeanSuiviKMUtilisateur *)value;
- (void)removeListSuiviKMUtilisateurObject:(BeanSuiviKMUtilisateur *)value;
- (void)addListSuiviKMUtilisateur:(NSSet *)values;
- (void)removeListSuiviKMUtilisateur:(NSSet *)values;

- (void)addListTourneeObject:(BeanTournee *)value;
- (void)removeListTourneeObject:(BeanTournee *)value;
- (void)addListTournee:(NSSet *)values;
- (void)removeListTournee:(NSSet *)values;

- (void)addListTourneeADXObject:(BeanTourneeADX *)value;
- (void)removeListTourneeADXObject:(BeanTourneeADX *)value;
- (void)addListTourneeADX:(NSSet *)values;
- (void)removeListTourneeADX:(NSSet *)values;

@end
