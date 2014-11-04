//
//  PEGAppDelegate.h
//  PEG
//
//  Created by 10_200_11_120 on 05/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
// MSP

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import "PEG_BeanImage.h"

#import "PEGAuthenticationViewController.h"

@interface PEGAppDelegate : UIResponder <UIApplicationDelegate,
CLLocationManagerDelegate>
//Add For Core Data
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    NSManagedObjectModel *managedObjectModelPhoto;
    NSManagedObjectContext *managedObjectContextPhoto;
    NSPersistentStoreCoordinator *persistentStoreCoordinatorPhoto;
}
//Add For Core Data

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PEGAuthenticationViewController	*authViewController;
@property (nonatomic, strong) CLLocationManager* principalLocationManager;

//Add For Core Data
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModelPhoto;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContextPhoto;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinatorPhoto;
- (NSString *)applicationDocumentsDirectory;
//Add For Core Data

@property (nonatomic, assign) int nbMemoryWarning;
//@property (assign, nonatomic)  bool isNeedToBeExit;

@end
