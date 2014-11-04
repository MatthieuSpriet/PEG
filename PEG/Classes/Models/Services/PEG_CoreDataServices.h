//
//  PEG_CoreDataServices.h
//  PEG
//
//  Created by Horsmedia3 on 25/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_CoreDataServices : NSObject

-(NSMutableArray*)coreDataEntityToJson:(NSString *)entityName;
- (void)jsonToCoreDataEntity:(NSDictionary *)keyedValues andEntityName:(NSString *)entityName;// andDateFormatter:(NSDateFormatter *)dateFormatter;

-(NSMutableDictionary*)getLieuParutionForJSonModified;

-(void)ViderCoreData;
-(NSString*)GetContenuDebugCoreData;
-(NSError*)Save;
-(NSError*)SavePhoto;

-(NSString*)NSDateToString:(NSData*)p_Data;
- (NSData*)jsonStructureFromManagedObjectsModified:(NSArray*)managedObjects;
- (NSData*)jsonStructureFromManagedObjects:(NSArray*)managedObjects ;
- (NSArray*)managedObjectsFromJSONStructure:(NSString*)json withObjectName:(NSString*)p_Entity withManagedObjectContext:(NSManagedObjectContext*)moc;
- (NSArray*)managedObjectsFromJSONStructure:(NSString*)p_json withObjectName:(NSString*)p_Entity withManagedObjectContext:(NSManagedObjectContext*)moc andDedoublonnage:(BOOL)p_Dedoub;

- (NSArray*)dataStructuresFromManagedObjectsModified:(NSArray*)managedObjects;		// pm140221 made public

@end
