//
//  BeanPresentoir.h
//  PEG
//
//  Created by Horsmedia3 on 27/03/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BeanHistoriqueParutionPresentoir, BeanLieu, BeanTache;

@interface BeanPresentoir : NSManagedObject

@property (nonatomic, retain) NSDate * dateAnnule;
@property (nonatomic, retain) NSDate * dateDernierePhoto;
@property (nonatomic, retain) NSString * emplacement;
@property (nonatomic, retain) NSString * flagMAJ;
@property (nonatomic, retain) NSNumber * flagPhoto;
@property (nonatomic, retain) NSString * guidpresentoir;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * idLieu;
@property (nonatomic, retain) NSNumber * idParution;
@property (nonatomic, retain) NSNumber * idPointDistribution;
@property (nonatomic, retain) NSString * localisation;
@property (nonatomic, retain) NSString * nomBatiment;
@property (nonatomic, retain) NSNumber * preAnnuleId;
@property (nonatomic, retain) NSString * tYPE;
@property (nonatomic, retain) NSSet *listHistoriqueParutionPresentoir;
@property (nonatomic, retain) NSSet *listTache;
@property (nonatomic, retain) BeanLieu *parentLieu;
@property (nonatomic, retain) NSManagedObject *listPresentoirParution;
@end

@interface BeanPresentoir (CoreDataGeneratedAccessors)

- (void)addListHistoriqueParutionPresentoirObject:(BeanHistoriqueParutionPresentoir *)value;
- (void)removeListHistoriqueParutionPresentoirObject:(BeanHistoriqueParutionPresentoir *)value;
- (void)addListHistoriqueParutionPresentoir:(NSSet *)values;
- (void)removeListHistoriqueParutionPresentoir:(NSSet *)values;

- (void)addListTacheObject:(BeanTache *)value;
- (void)removeListTacheObject:(BeanTache *)value;
- (void)addListTache:(NSSet *)values;
- (void)removeListTache:(NSSet *)values;

@end
