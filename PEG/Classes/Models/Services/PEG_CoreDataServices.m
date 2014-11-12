//
//  PEG_CoreDataServices.m
//  PEG
//
//  Created by Horsmedia3 on 25/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGAppDelegate.h"
#import "PEG_CoreDataServices.h"
#import "BeanTournee.h"
#import "PEG_FTechnical.h"
#import "JSONKit.h"
#import "PEGException.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"
#import "PEG_EnumFlagMAJ.h"
#import "BeanAction.h"
#import "BeanLieuPassage.h"
#import "BeanSuiviKMUtilisateur.h"
//#import "NSDictionary+ConvenientAccess.h"

@implementation PEG_CoreDataServices

//See more at: http://door3.com/insights/ios-programming-preparing-coredata-json-transmission#sthash.z5UpgJ4j.dpuf
-(NSMutableArray*)coreDataEntityToJson:(NSString *)entityName
{
    NSMutableArray* v_retour = [NSMutableArray array];
    
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:app.managedObjectContext];
    [request setEntity:entity];
    
    NSArray *array = [[app.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
    
    for (NSManagedObject *managedObject in array) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        
        for (NSPropertyDescription *property in entity) {
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                if ([managedObject valueForKey:property.name]) {
                    [dictionary setObject:[managedObject valueForKey:property.name] forKey:property.name];
                }
            }
        }
        [v_retour addObject:dictionary];
        NSLog(@"Dictionary: %@", dictionary);
    }
    return v_retour;
}

//- (void)safeSetManagedValuesForKeysWithDictionary:(NSDictionary *)keyedValues andEntityName:(NSString *)entityName andDateFormatter:(NSDateFormatter *)dateFormatter
- (void)jsonToCoreDataEntity:(NSDictionary *)keyedValues andEntityName:(NSString *)entityName // andDateFormatter:(NSDateFormatter *)dateFormatter
{
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:app.managedObjectContext];
    NSDictionary *attributes = [entity attributesByName];
    for (NSString *attribute in attributes) {
        id value = [keyedValues objectForKey:attribute];
        if (value == nil) {
            continue;
        }
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value integerValue]];
        } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) /*&& (dateFormatter != nil)*/) {
            //value = [dateFormatter dateFromString:value];
            value = [PEG_FTechnical getDateFromJson:[keyedValues stringForKeyPath:attribute]];
        }
        //We don't handle nested object yet
        else if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSDictionary class]])) {
            value = nil;
        }
        //Convert NSNull to nil
        else if ([value isKindOfClass:[NSNull class]]) {
            value = nil;
        }
        
        [self setValue:value forKey:attribute];
    }
}

/*-(NSMutableArray*)jsonToCoreDataEntity:(NSDictionary*) p_dico
 {
 @try{
 if ([p_dico count]!=0)
 {
 PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
 
 NSArray* v_ListTournee = [p_dico arrayForKeyPath:@"ListTournee"];
 for (NSDictionary* v_ItemTournee in v_ListTournee)
 {
 BeanTournee* v_Bean = (BeanTournee *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanTournee" inManagedObjectContext:app.managedObjectContext];
 [v_Bean setIdPresentoir:p_IdPresentoir];
 //BeanTournee* v_BeanTournee =
 [v_BT initCDWithJson:v_ItemTournee];
 [v_BT release];
 }
 PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
 NSError *saveError = nil;
 if([app.managedObjectContext hasChanges])
 {
 [app.managedObjectContext save:&saveError];
 }
 }
 else
 {
 [SPIRTechnicalException raise:@"EmptyFileException" format:@"le fichier est vide"];
 }
 
 }@catch(NSException* p_exception){
 
 [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromNSDictionaryToCDByJSON" andExparams:p_dico.description];
 }
 
 NSMutableArray* v_retour = [NSMutableArray array];
 
 if([p_dico count] > 0)
 {
 
 
 NSArray* v_ListTournee = [p_dico arrayForKeyPath:@"ListTournee"];
 for (NSDictionary* v_ItemTournee in v_ListTournee)
 {
 PEG_BeanTournee* v_BeanTournee = [[PEG_BeanTournee alloc] initBeanWithJson:v_ItemTournee];
 [p_ObjectToFill.ListTournee addObject:v_BeanTournee];
 [
 
 
 v_Bean = (BeanAction *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext];
 [v_Bean setIdPresentoir:p_IdPresentoir];
 
 }
 
 
 PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
 NSFetchRequest *request = [[NSFetchRequest alloc] init];
 NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:app.managedObjectContext];
 [request setEntity:entity];
 
 NSArray *array = [[app.managedObjectContext executeFetchRequest:request error:nil] mutableCopy];
 
 for (NSManagedObject *managedObject in array) {
 NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
 
 for (NSPropertyDescription *property in entity) {
 if ([property isKindOfClass:[NSAttributeDescription class]]) {
 if ([managedObject valueForKey:property.name]) {
 [dictionary setObject:[managedObject valueForKey:property.name] forKey:property.name];
 }
 }
 }
 [v_retour addObject:dictionary];
 NSLog(@"Dictionary: %@", dictionary);
 }
 return v_retour;
 }*/



-(NSError*)Save
{
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    NSError *saveError = nil;
    if([app.managedObjectContext hasChanges])
    {
        [app.managedObjectContext save:&saveError];
    }
    return saveError;
}

-(NSError*)SavePhoto
{
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    NSError *saveError = nil;
    if([app.managedObjectContextPhoto hasChanges])
    {
        [app.managedObjectContextPhoto save:&saveError];
    }
    return saveError;
}

-(void)ViderCoreData
{
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    //NSArray *myEntities = [app.managedObjectModel entities];
    //NSDictionary *myEntities = [app.managedObjectModel entitiesByName];
    NSArray *myEntities = [[app.managedObjectModel entities] valueForKey:@"name"];
    
    for (NSString* v_Entity in myEntities) {
        //if([v_Entity isEqualToString:@"BeanSuiviKMUtilisateur"]) continue;
        if([v_Entity isEqualToString:@"BeanParametre"]) continue; //Pour le module de com
        //if([v_Entity isEqualToString:@"BeanPhoto"]) continue; // Si la photo n'est pas passée à la synchro c'est trop tard
        NSFetchRequest * allElements = [[NSFetchRequest alloc] init];
        [allElements setEntity:[NSEntityDescription entityForName:v_Entity inManagedObjectContext:app.managedObjectContext]];
        [allElements setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * cars = [app.managedObjectContext executeFetchRequest:allElements error:&error];
        //error handling goes here
        for (NSManagedObject * car in cars) {
            // On garde le kilometrage du jour au cas où la synchro plante suite à l'effacement, on a pas besoin de resaisir les km
            if([v_Entity isEqualToString:@"BeanSuiviKMUtilisateur"]
               && [[PEG_FTechnical GetDateYYYYMMDDFromDate:((BeanSuiviKMUtilisateur*)car).date] isEqualToDate:[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]] ) continue;
            [app.managedObjectContext deleteObject:car];
        }
        NSError *saveError = nil;
        if([app.managedObjectContext hasChanges])
        {
            [app.managedObjectContext save:&saveError];
        }
        //more error handling here
    }
}

-(NSString*)GetContenuDebugCoreData
{
    NSString* v_retour = @"";
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    
    //NSArray *myEntities = [app.managedObjectModel entities];
    //NSDictionary *myEntities = [app.managedObjectModel entitiesByName];
    //NSArray *myEntities = app.managedObjectModel.entities.name;
    NSArray *myEntities = [[app.managedObjectModel entities] valueForKey:@"name"];
    
    for (NSString* v_Entity in myEntities) {
        NSFetchRequest * allElements = [[NSFetchRequest alloc] init];
        [allElements setEntity:[NSEntityDescription entityForName:[NSString stringWithFormat:@"%@",v_Entity] inManagedObjectContext:app.managedObjectContext]];
        //[allElements setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * v_obj = [app.managedObjectContext executeFetchRequest:allElements error:&error];
        v_retour = [NSString stringWithFormat:@"%@%@ %i lignes\n",v_retour,v_Entity,v_obj.count];
    }
    return v_retour;
}

#pragma mark JSON
-(NSMutableDictionary*)getLieuParutionForJSonModified
{
    NSMutableDictionary* v_retour = [[NSMutableDictionary alloc]init];
    NSMutableArray* v_ArrayParution = [[NSMutableArray alloc]init];
    NSMutableArray* v_ArrayLieu = [[NSMutableArray alloc]init];
    NSMutableArray* v_ArrayPresentoir = [[NSMutableArray alloc]init];
    
    
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    //On récupère les Id Lieu à conserver
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    [req setEntity:[NSEntityDescription entityForName:@"BeanAction" inManagedObjectContext:app.managedObjectContext]];
    [req setPredicate:[NSPredicate predicateWithFormat:@"flagMAJ == %@ OR flagMAJ == %@",PEG_EnumFlagMAJ_Modified,PEG_EnumFlagMAJ_Added]];
    
    NSArray* v_array = [app.managedObjectContext executeFetchRequest:req error:nil];
    for (BeanAction* v_BeanAP in v_array) {
        if(v_BeanAP.idParution != nil && ![v_ArrayParution containsObject:v_BeanAP.idParution])
        {
            [v_ArrayParution addObject:v_BeanAP.idParution];
        }
        if(![v_ArrayLieu containsObject:v_BeanAP.parentLieuPassage.idLieu])
        {
            [v_ArrayLieu addObject:v_BeanAP.parentLieuPassage.idLieu];
        }
        if(v_BeanAP.idPresentoir !=nil && ![v_ArrayPresentoir containsObject:v_BeanAP.idPresentoir])
        {
            [v_ArrayPresentoir addObject:v_BeanAP.idPresentoir];
        }
    }
    [v_retour setObject:v_ArrayParution forKey:@"BeanParution"];
    [v_retour setObject:v_ArrayLieu forKey:@"BeanLieu"];
    [v_retour setObject:v_ArrayPresentoir forKey:@"BeanPresentoir"];
    
    return v_retour;
}

-(NSMutableDictionary*)managedObjectToJson:(NSManagedObject *)p_ManagedObject
{
    NSMutableDictionary* v_retour = [[NSMutableDictionary alloc]init];
    NSEntityDescription *entity = [p_ManagedObject entity];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (NSPropertyDescription *property in entity) {
        if ([property isKindOfClass:[NSAttributeDescription class]]) {
            if ([p_ManagedObject valueForKey:property.name]) {
                
                /* On reformat pour les dates */
                NSDictionary *attributes = [entity attributesByName];
                NSString *attribute =property.name;
                //id value = [keyedValues objectForKey:attribute];
                id value = [p_ManagedObject valueForKey:property.name];
                if (value == nil) {
                    continue;
                }
                NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
                
                if (attributeType == NSStringAttributeType) {
                    //value = value;
                } else if ((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType)) {
                    value = [value stringValue];
                } else if (attributeType == NSBooleanAttributeType) {
                    if([value integerValue] != 0)
                    {
                        value = @"true";
                    }
                    else
                    {
                        value = @"false";
                    }
                } else if (attributeType == NSFloatAttributeType) {
                    value = [value stringValue];
                } else if (attributeType == NSDateAttributeType) {
                    value = [PEG_FTechnical getJsonFromDate:value];
                }
                //We don't handle nested object yet
                /*else if (attributeType == NSStringAttributeType) {
                 value = nil;
                 }*/
                //Convert NSNull to nil
                else if ([value isKindOfClass:[NSNull class]]) {
                    value = nil;
                }
                /***/
				// pm201402 setObject avec value = nil va déclencher une exception !
                [dictionary setObject:value forKey:property.name];
            }
        }
    }
    //[v_retour addObject:dictionary];
    [v_retour addEntriesFromDictionary:dictionary];
    //NSLog(@"Dictionary: %@", dictionary);
    
    return v_retour;
}
//On ne remonte que les element contenant des valeurs modifié (ou supprimé...)
- (NSDictionary*)dataStructureFromManagedObjectModified:(NSManagedObject*)managedObject andObjetAGarder:(NSMutableDictionary*)p_DicoAGarder andAGarderEnChaine:(BOOL)p_AGarderEnChaine
{
    NSString* v_IsExportable = [[[managedObject entity] userInfo] objectForKey:@"isExportForSave"];
    if (v_IsExportable != nil && [v_IsExportable boolValue] == NO)
    {
        return nil;
    }
    //NSDictionary *attributesByName = [[managedObject entity] attributesByName];
    NSDictionary *relationshipsByName = [[managedObject entity] relationshipsByName];
    NSMutableDictionary *valuesDictionary = [self managedObjectToJson:managedObject];
    BOOL v_HasFils = false;
    NSString* v_DebugEntityName = @"";
    //valuesDictionary = [[managedObject dictionaryWithValuesForKeys:[attributesByName allKeys]] mutableCopy];
    //[valuesDictionary setObject:[[managedObject entity] name] forKey:@"ManagedObjectName"];
    //[valuesDictionary setObject:[[managedObject entity] name] forKey:p_Entity];
    for (NSString *relationshipName in [relationshipsByName allKeys]) {
        NSRelationshipDescription *description = [[[managedObject entity] relationshipsByName] objectForKey:relationshipName];
        if (![description isToMany]) {
            //On ne fait rien sinon on tourne en rond (recursivité)
            //NSManagedObject *relationshipObject = [managedObject valueForKey:relationshipName];
            //[valuesDictionary setObject:[self dataStructureFromManagedObject:relationshipObject] forKey:relationshipName];
            continue;
        }
        //NSSet *relationshipObjects = [managedObject objectForKey:relationshipName];
        NSSet *relationshipObjects = [managedObject valueForKey:relationshipName];
        NSMutableArray *relationshipArray = [[NSMutableArray alloc] init];
        BOOL v_AGarderEnChaine = false;
        for (NSManagedObject *relationshipObject in relationshipObjects) {
            v_AGarderEnChaine = p_AGarderEnChaine;
            if (([[[managedObject entity]name] isEqualToString:@"BeanTournee"] || [[[managedObject entity]name] isEqualToString:@"BeanTourneeADX"])
                && ![((BeanTournee*)managedObject).flagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
                //&& [[PEG_FTechnical GetDateYYYYMMDDFromDate:((BeanTournee*)managedObject).dtDebutReelle ] isEqualToDate:[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]])
            {
                v_AGarderEnChaine = true;
            }
            NSDictionary* v_DicTmp = [self dataStructureFromManagedObjectModified:relationshipObject andObjetAGarder:p_DicoAGarder andAGarderEnChaine:v_AGarderEnChaine];
            if(v_DicTmp != nil)
            {
                [relationshipArray addObject:v_DicTmp];
            }
            v_DebugEntityName = [[managedObject entity] name];
        }
        if(relationshipArray.count > 0)
        {
            //Si on a des fils, on remonte les ascendant, même si pas de modif des ascendants
            //valuesDictionary = [self managedObjectToJson:managedObject];
            [valuesDictionary setObject:relationshipArray forKey:relationshipName];
            v_HasFils = true;
        }
        else
        {
            //RAS
        }
    }
    //Si on a pas de fils, alors on vérifie que l'element courant ne soit pas unchanged
    if(!v_HasFils)
    {
            //valuesDictionary = [self managedObjectToJson:managedObject];
            //Si on force a garder, on garde
            BOOL v_PeutOnNePasPrendre = true;
            NSArray* v_Lstid = [p_DicoAGarder objectForKey:[[managedObject entity]name]];
            if(v_Lstid != nil)
            {
                if ([[[managedObject entity]name] isEqualToString:@"BeanLieu"]) {
                    for (NSNumber* v_idAGarder in v_Lstid) {
                        v_PeutOnNePasPrendre = !([v_idAGarder intValue] == [[valuesDictionary objectForKey:@"idLieu"] intValue]);
                    }
                }
                if ([[[managedObject entity]name] isEqualToString:@"BeanPresentoir"]) {
                    for (NSNumber* v_idAGarder in v_Lstid) {
                        v_PeutOnNePasPrendre = !([v_idAGarder intValue] == [[valuesDictionary objectForKey:@"idPresentoir"] intValue]);
                    }
                }
                if ([[[managedObject entity]name] isEqualToString:@"BeanMobilitePegase"])
                {
                    v_PeutOnNePasPrendre = NO;
                }
                if(p_AGarderEnChaine)
                {
                    v_PeutOnNePasPrendre = NO;
                }
            }
        if(p_AGarderEnChaine)
        {
            v_PeutOnNePasPrendre = NO;
        }
            if(v_PeutOnNePasPrendre)
            {
                //Si on a pas de fils modifié, alors on vérifie si l'element courant est modifié
                //S'il n'est pas modifié, on ne le remonte pas
                if([valuesDictionary valueForKey:@"flagMAJ"] == nil || [[valuesDictionary valueForKey:@"flagMAJ"] isEqualToString:PEG_EnumFlagMAJ_Unchanged])
                {
                    //Si l'élément courant n'est pas modifié on le supprime
                    valuesDictionary = nil;
                }
            }
    }
    return valuesDictionary;
}

- (NSDictionary*)dataStructureFromManagedObject:(NSManagedObject*)managedObject
{
    NSString* v_IsExportable = [[[managedObject entity] userInfo] objectForKey:@"isExportForSave"];
    if (v_IsExportable != nil && [v_IsExportable boolValue] == NO)
    {
        return nil;
    }
    //NSDictionary *attributesByName = [[managedObject entity] attributesByName];
    NSDictionary *relationshipsByName = [[managedObject entity] relationshipsByName];
    //NSMutableDictionary *valuesDictionary = [[managedObject dictionaryWithValuesForKeys:[attributesByName allKeys]] mutableCopy];
    NSMutableDictionary *valuesDictionary = [self managedObjectToJson:managedObject];
    //[valuesDictionary setObject:[[managedObject entity] name] forKey:@"ManagedObjectName"];
    //[valuesDictionary setObject:[[managedObject entity] name] forKey:p_Entity];
    for (NSString *relationshipName in [relationshipsByName allKeys]) {
        NSRelationshipDescription *description = [[[managedObject entity] relationshipsByName] objectForKey:relationshipName];
        if (![description isToMany]) {
            //On ne fait rien sinon on tourne en rond (recursivité)
            //NSManagedObject *relationshipObject = [managedObject valueForKey:relationshipName];
            //[valuesDictionary setObject:[self dataStructureFromManagedObject:relationshipObject] forKey:relationshipName];
            continue;
        }
        //NSSet *relationshipObjects = [managedObject objectForKey:relationshipName];
        NSSet *relationshipObjects = [managedObject valueForKey:relationshipName];
        NSMutableArray *relationshipArray = [[NSMutableArray alloc] init];
        for (NSManagedObject *relationshipObject in relationshipObjects) {
            NSDictionary* v_DicTmp = [self dataStructureFromManagedObject:relationshipObject];
            if(v_DicTmp != nil)
            {
                [relationshipArray addObject:v_DicTmp];
            }
        }
        if(relationshipArray.count > 0)
        {
            [valuesDictionary setObject:relationshipArray forKey:relationshipName];
        }
    }
    return valuesDictionary;
}

- (NSArray*)dataStructuresFromManagedObjectsModified:(NSArray*)managedObjects
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    //TODO MSP supprime pour test
    //NSMutableDictionary* v_Dico = [self getLieuParutionForJSonModified];
    NSMutableDictionary* v_Dico = [[NSMutableDictionary alloc]init];
    
    for (NSManagedObject *managedObject in managedObjects) {
        NSDictionary* v_Dic = [self dataStructureFromManagedObjectModified:managedObject andObjetAGarder:v_Dico andAGarderEnChaine:NO];
        if(v_Dic != nil)
        {
            [dataArray addObject:v_Dic];
        }
    }
    return dataArray;
}

- (NSArray*)dataStructuresFromManagedObjects:(NSArray*)managedObjects
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSManagedObject *managedObject in managedObjects) {
        NSDictionary* v_Dic = [self dataStructureFromManagedObject:managedObject];
        if(v_Dic != nil)
        {
            [dataArray addObject:v_Dic];
        }
    }
    return dataArray;
}

-(NSString*)NSDateToString:(NSData*)p_Data
{
    return[[NSString alloc] initWithData:p_Data encoding:NSUTF8StringEncoding] ;
}

- (NSData*)jsonStructureFromManagedObjectsModified:(NSArray*)managedObjects
{
    NSData *v_retour = nil;
    @try{
        NSArray *objectsArray = [self dataStructuresFromManagedObjectsModified:managedObjects];
        //NSString *v_retour = [[CJSONSerializer serializer] serializeArray:objectsArray];
        if ([NSJSONSerialization isValidJSONObject:objectsArray])
        {
            v_retour = [NSJSONSerialization dataWithJSONObject:objectsArray options:NSJSONWritingPrettyPrinted error:nil];
            //NSString* myString = [[NSString alloc] initWithData:v_retour encoding:NSUTF8StringEncoding];
            //DLog(@"%@",myString);
        }else {
            
            ALog(@"JSON invalid");
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans jsonStructureFromManagedObjectsModified" andExparams:nil];
    }
    return v_retour;
}
- (NSData*)jsonStructureFromManagedObjects:(NSArray*)managedObjects
{
    NSData *v_retour = nil;
    @try{
        NSArray *objectsArray = [self dataStructuresFromManagedObjects:managedObjects];
        //NSString *v_retour = [[CJSONSerializer serializer] serializeArray:objectsArray];
        if ([NSJSONSerialization isValidJSONObject:objectsArray])
        {
            v_retour = [NSJSONSerialization dataWithJSONObject:objectsArray options:NSJSONWritingPrettyPrinted error:nil];
            //NSString* myString = [[NSString alloc] initWithData:v_retour encoding:NSUTF8StringEncoding];
        }else {
            
            ALog(@"JSON invalid");
            
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans jsonStructureFromManagedObjects" andExparams:nil];
    }
    return v_retour;
}

-(NSPredicate*) getPredicateByEntity:(NSString*)p_EntityName andStructure:(NSDictionary*)p_Dico
{
    
    NSPredicate *v_retour = nil;
    @try{
        NSMutableArray *parr = [NSMutableArray array];
        
        for (NSString* v_Key in [p_Dico allKeys]) {
            if([v_Key isEqualToString:@"flagMAJ"])
            {
                //Le FlagMaj de la tournee peut avoir changé entre deux synchro
                continue;
            }
            
            id value = [p_Dico objectForKey:v_Key];
            /*if([p_EntityName isEqualToString:@"BeanLieu"]
             && [v_Key isEqualToString:@"idLieu"]
             && [[value stringValue] isEqualToString:@ "85641"])
             {
             DLog("%@ = %@", v_Key, value);
             }*/
            if (value == nil) {
                continue;
            }
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            NSEntityDescription *v_EntityDescription = [NSEntityDescription entityForName:p_EntityName inManagedObjectContext:app.managedObjectContext];
            NSDictionary *attributes = [v_EntityDescription attributesByName];
            NSAttributeType attributeType = [[attributes objectForKey:v_Key] attributeType];
            
            if (attributeType == NSStringAttributeType){
                if(![value isEqualToString:@""])
                {
                    [parr addObject:[NSPredicate predicateWithFormat:@"%K LIKE %@",v_Key,value]];
                }
            } else if ((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) {
                value = [NSNumber numberWithInteger:[value integerValue]];
                [parr addObject:[NSPredicate predicateWithFormat:@"%K == %@",v_Key,value]];
            } else if (attributeType == NSFloatAttributeType || attributeType == NSDecimalAttributeType){
                value = [NSNumber numberWithDouble:[value doubleValue]];
                [parr addObject:[NSPredicate predicateWithFormat:@"%K == %@",v_Key,value]];
            } else if (attributeType == NSDateAttributeType) {
                value = [PEG_FTechnical getDateFromJson:[p_Dico stringForKeyPath:v_Key]];
                [parr addObject:[NSPredicate predicateWithFormat:@"%K == %@",v_Key,value]];
            }
        }
        if([parr count] > 0)
        {
            v_retour = [NSCompoundPredicate andPredicateWithSubpredicates:parr];
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans getPredicateByEntity" andExparams:nil];
    }
    return v_retour;
}


- (NSManagedObject*)managedObjectFromStructure:(NSDictionary*)structureDictionary withObjectName:(NSString*)p_Entity withManagedObjectContext:(NSManagedObjectContext*)moc andDedoublonnage:(BOOL)p_Dedoub
{
    NSManagedObject *managedObject = nil;
    NSString* v_relationNameForDEBUG = @"";
    @try{
        if(p_Dedoub)
        {
            //On vérifie que la ligne n'existe pas déjà
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            [req setEntity:[NSEntityDescription entityForName:p_Entity inManagedObjectContext:app.managedObjectContext]];
            NSPredicate* v_Predicate = [self getPredicateByEntity:p_Entity andStructure:structureDictionary];
            if(v_Predicate != nil)
            {
                [req setPredicate:v_Predicate];
            }
            managedObject = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        }
        if(managedObject == nil)
        {
            //La ligne n'existe pas on l'ajoute
            managedObject = [NSEntityDescription insertNewObjectForEntityForName:p_Entity inManagedObjectContext:moc];
            //[managedObject setValuesForKeysWithDictionary:structureDictionary];
            [managedObject safeSetManagedValuesForKeysWithDictionary:structureDictionary];
        }
        
        for (NSString *relationshipName in [[[managedObject entity] relationshipsByName] allKeys]) {
            NSRelationshipDescription *description = [[[managedObject entity] relationshipsByName] objectForKey:relationshipName];
            if (![description isToMany]) {
                NSDictionary *childStructureDictionary = [structureDictionary objectForKey:relationshipName];
                if(childStructureDictionary != nil)
                {
                    v_relationNameForDEBUG =[self getEntityNameByList:relationshipName];
                    NSManagedObject *childObject = [self managedObjectFromStructure:childStructureDictionary withObjectName:[self getEntityNameByList:relationshipName] withManagedObjectContext:moc andDedoublonnage:p_Dedoub];
                    //[managedObject setObject:childObject forKey:relationshipName];
                    [managedObject setValue:childObject forKey:relationshipName];
                }
                continue;
            }
            NSMutableSet *relationshipSet = [managedObject mutableSetValueForKey:relationshipName];
            NSArray *relationshipArray = [structureDictionary objectForKey:relationshipName];
            for (NSDictionary *childStructureDictionary in relationshipArray) {
                v_relationNameForDEBUG =[self getEntityNameByList:relationshipName];
                NSManagedObject *childObject = [self managedObjectFromStructure:childStructureDictionary withObjectName:[self getEntityNameByList:relationshipName] withManagedObjectContext:moc andDedoublonnage:p_Dedoub];
                [relationshipSet addObject:childObject];
                
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans managedObjectsFromJSONStructure andDedoublonnage" andExparams:[NSString stringWithFormat:@"p_Entity:%@ p_Dedoub:%hhd v_relationNameForDEBUG:%@",p_Entity,p_Dedoub,v_relationNameForDEBUG] ];
    }
    return managedObject;
}

- (NSArray*)managedObjectsFromJSONStructure:(NSString*)p_json withObjectName:(NSString*)p_Entity withManagedObjectContext:(NSManagedObjectContext*)moc
{
    return [self managedObjectsFromJSONStructure:p_json withObjectName:p_Entity withManagedObjectContext:moc andDedoublonnage:true];
}


- (NSArray*)managedObjectsFromJSONStructure:(NSString*)p_json withObjectName:(NSString*)p_Entity withManagedObjectContext:(NSManagedObjectContext*)moc andDedoublonnage:(BOOL)p_Dedoub
{
    NSMutableArray *objectArray = [[NSMutableArray alloc] init];
    @try{
        NSError *error = nil;
        //NSArray *structureArray = [[CJSONDeserializer deserializer] deserializeAsArray:json error:&error];
        NSDictionary *structureArray = [NSDictionary dictionaryWithDictionary:[p_json objectFromJSONStringWithParseOptions:JKParseOptionNone error:&error]];
        NSAssert2(error == nil, @"Failed to deserialize\n%@\n%@", [error localizedDescription], p_json);
        //for (NSDictionary *structureDictionary in structureArray) {
        [objectArray addObject:[self managedObjectFromStructure:structureArray withObjectName:p_Entity withManagedObjectContext:moc andDedoublonnage:p_Dedoub]];
        //}
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans managedObjectsFromJSONStructure andDedoublonnage" andExparams:nil];
    }
    return objectArray;
}

- (NSString*)getEntityNameByList:(NSString*) p_ListName
{
    if ([p_ListName isEqualToString:@"listTournee"]) {
        return @"BeanTournee";
    }
    else if ([p_ListName isEqualToString:@"listLieuPassage"]) {
        return @"BeanLieuPassage";
    }
    else if ([p_ListName isEqualToString:@"listAction"]) {
        return @"BeanAction";
    }
    else if ([p_ListName isEqualToString:@"listLieu"]) {
        return @"BeanLieu";
    }
    else if ([p_ListName isEqualToString:@"listPresentoir"]) {
        return @"BeanPresentoir";
    }
    else if ([p_ListName isEqualToString:@"listConcurentLieu"]) {
        return @"BeanConcurentLieu";
    }
    else if ([p_ListName isEqualToString:@"listHoraire"]) {
        return @"BeanHoraire";
    }
    else if ([p_ListName isEqualToString:@"listConcurents"]) {
        return @"BeanConcurents";
    }
    else if ([p_ListName isEqualToString:@"listSuiviKMUtilisateur"]) {
        return @"BeanSuiviKMUtilisateur";
    }
    else if ([p_ListName isEqualToString:@"listCommune"]) {
        return @"BeanCPCommune";
    }
    else if ([p_ListName isEqualToString:@"listParution"]) {
        return @"BeanParution";
    }
    else if ([p_ListName isEqualToString:@"listEdition"]) {
        return @"BeanEdition";
    }
    else if ([p_ListName isEqualToString:@"listChoix"]) {
        return @"BeanChoix";
    }
    else if ([p_ListName isEqualToString:@"listHistoriqueParutionPresentoir"]) {
        return @"BeanHistoriqueParutionPresentoir";
    }
    else if ([p_ListName isEqualToString:@"listTache"]) {
        return @"BeanTache";
    }
    else if ([p_ListName isEqualToString:@"listRestriction"]) {
        return @"BeanRestrictionChoix";
    }
    else if ([p_ListName isEqualToString:@"listPresentoirParution"]) {
        return @"BeanPresentoirParution";
    }
    else if ([p_ListName isEqualToString:@"listLieuPassageADX"]) {
        return @"BeanLieuPassageADX";
    }
    else if ([p_ListName isEqualToString:@"listActionADX"]) {
        return @"BeanActionADX";
    }
    else if ([p_ListName isEqualToString:@"listTourneeADX"]) {
        return @"BeanTourneeADX";
    }
    return p_ListName;
}

@end
