//
//  PEGAppDelegate.m
//  PEG
//
//  Created by 10_200_11_120 on 05/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

//#import <Parse/Parse.h>
#import <dlfcn.h>

#import "GAI.h"
#import "PEGAppDelegate.h"
#import "PEGSession.h"
#import "SPIRFunction.h"
#import "PEGParametres.h"
#import "SPIRSession.h"
#import "PEGException.h"
#import "PEG_FMobilitePegase.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "PEG_ModuleCommunicationRequest.h"
#import "BeanParametre.h"
#import <Crashlytics/Crashlytics.h>
#import "PEGWebServices.h"


// https://github.com/millenomi/diceshaker/blob/master/iPhone/Classes/DiceshakerAppDelegate.m
static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold)
{
	double
	deltaX = fabs(last.x - current.x),
	deltaY = fabs(last.y - current.y),
	deltaZ = fabs(last.z - current.z);
	
	return
	(deltaX > threshold && deltaY > threshold) ||
	(deltaX > threshold && deltaZ > threshold) ||
	(deltaY > threshold && deltaZ > threshold);
}

@interface PEGAppDelegate () <UIAccelerometerDelegate, UIAlertViewDelegate,PEG_BeanImageDataSource,MFMailComposeViewControllerDelegate                                                                                                                                                                                                                                                                                                                                                                                                                                                              >
{
	// shake handling
	BOOL									 histeresisExcited;
	UIAcceleration							*lastAcceleration;
	
	BOOL									 hasLoadedProfile;
}

@property (nonatomic, strong) UIAcceleration *lastAcceleration;
@property (nonatomic, strong) UIAlertView *debugAlertView;
@end

@implementation PEGAppDelegate
@synthesize lastAcceleration;

- (void)dealloc
{
    @try{
        
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    NSSetUncaughtExceptionHandler(&myExceptionHandler);
}

// pm201402 test avec Reveal- TODO: remove that !
// la variable d'environement REVEAL_DYLIB_PATH est défini dans le scheme debug…
//- (void)initializeReveal
//{
//	NSString *revealDylibPath = NSProcessInfo.processInfo.environment[@"REVEAL_DYLIB_PATH"];
//	if (revealDylibPath)
//	{
//		if (dlopen([revealDylibPath fileSystemRepresentation], 0x02))
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:self];
//		else
//			NSLog(@"erreur");
//	}
//}

void myExceptionHandler(NSException *exception)
{
    NSArray *stack = [exception callStackReturnAddresses];
    NSLog(@"Stack trace: %@", stack);
    [[PEGException sharedInstance] ManageExceptionWithoutThrow:exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:[NSString stringWithFormat:@"stack : %@",stack ]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//	[self initializeReveal];
    @try{
        [Crashlytics startWithAPIKey:@"b2e4c973f5394003b5a16b2f9266dee208ef1111"];
        [Crashlytics setObjectValue:PEG_WS_ENVIRONNEMENT forKey:@"ENV"];
        
        // initialize Google analytics
        // Optional: automatically send uncaught exceptions to Google Analytics.
         [GAI sharedInstance].trackUncaughtExceptions = YES;      //-- on a aussi Crashlytics + @try !
        // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
        [GAI sharedInstance].dispatchInterval = 20;
        // Optional: set Logger to VERBOSE for debug information.
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
        //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
        // Initialize tracker. Replace with your tracking ID.
        
        [[GAI sharedInstance] trackerWithTrackingId:@"UA-25620591-4"];
        self.nbMemoryWarning = 0;

         [self.window makeKeyAndVisible];
        
        // Connect to the Remote Live Logging System
        //FIX ME
        //    [[LibTraceParse sharedInstance] connectAppToLiveLogSystemWithApplicationId:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ParseApplicationId"]
        //                                                                     clientKey:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"ParseClientKey"]
        //                                                                    appVersion:PEG_APP_VERSION
        //                                                                  buildVersion:PEG_BUILD_VERSION];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticationSucceed:) name:PEGLoginSucceedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthenticationFailed:) name:PEGLoginFailedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout:) name:PEGLogoutNotification object:nil];
        
    	_authViewController = [[PEGAuthenticationViewController alloc] init];
    	[_authViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        
        
        [self.window.rootViewController  presentViewController:_authViewController animated:YES completion:NULL];
        //[[PEGSession sharedPEGSession] replaceMatResp:@"00000619"];
        //    [self userAuthenticationSucceed:nil];
        
        //self.isNeedToBeExit = false;
        
        // Override point for customization after application launch.
        return YES;
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self.principalLocationManager stopUpdatingLocation];
    
    /*if(self.isNeedToBeExit)
    {
        exit(0);
    }*/
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    @try{
        //Add For Core Data
        NSError *error = nil;
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
        //Add For Core Data
        
        //FIX ME
        //    [[LibTraceParse sharedInstance] stopLiveLogSession];
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

-(void)applicationDidEnterBackground:(UIApplication *)application
{
    // Stop the Remote Live Logging System
    //FIX ME
    //    [[LibTraceParse sharedInstance] stopLiveLogSession];
    [self stopGPSStandardUpdates];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    @try{
        [self startGPSStandardUpdates];

 /*       if ([[SPIRSession username] length] != 0)
        {
        [[PEGWebServices sharedWebServices] Login:[SPIRSession username] andPassword:[SPIRSession password]  succes:^(bool p_isAuthentif) {
            
            //NSLog (@"getBeanTourneeByMatricule success");
            if(!p_isAuthentif){
//                UIAlertView *debugAlertView;
//                
//                debugAlertView = [[UIAlertView alloc] initWithTitle:nil
//                                                            message:@"session expiré "
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//                
//                [debugAlertView show];
            }
            
        } failure:^() {
//            UIAlertView *debugAlertView;
//            
//            debugAlertView = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"session expiré "
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//            
//            [debugAlertView show];
        }];
        }
*/
        
        
        // Login to Remote Live Logging Systems
        if ([SPIRSession hasSessionInKeychain]) {
            //FIX ME
            //        [[LibTraceParse sharedInstance] loginUserToLiveLogSystemWithUserId:[SPIRSession username]];
        }
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

#pragma mark - Authentification notif

// Traitement après échec de l'authentification
- (void)userAuthenticationFailed:(NSNotification *)notif
{
    @try{
        DLog(@"%@", notif.object);
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

// Traitement après déconnexion de l'utilisateur
- (void)userLogout:(NSNotification *)notif
{
    @try{
        [SPIRSession logout];
        [[PEGSession sharedPEGSession] clearSession];
        //	[_tabController presentModalViewController:_authViewController animated:YES];
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

- (void)startGPSStandardUpdates
{
    if (self.principalLocationManager == nil)
    {
        self.principalLocationManager = [[CLLocationManager alloc] init];
    }
    self.principalLocationManager.distanceFilter = kCLDistanceFilterNone;
    self.principalLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.principalLocationManager.delegate = self;
    [self.principalLocationManager startUpdatingLocation];
}

- (void)stopGPSStandardUpdates
{
    if (self.principalLocationManager == nil)
    {
        [self.principalLocationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation * newLocation = [locations lastObject];
    // post notification that a new location has been found
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newLocationNotif"
                                                        object:self
                                                      userInfo:[NSDictionary dictionaryWithObject:newLocation
                                                                                           forKey:@"newLocationResult"]];
}

- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"error%@",error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            //please check your network connection or that you are not in airplane mode
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Localisation impossible. Veuillez vérifier que vous n'êtes pas en mode avion. Et redémarrer." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            //user has denied to use current Location
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Localisation impossible. Veuillez activer l'utilisation de la localisation. Et redémarrer" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            //unknown network error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Localisation impossible. Erreur lors de la tentative de localisation." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}

// Traitement après authentification réussie
- (void)userAuthenticationSucceed:(NSNotification *)notif
{
    @try{
        
        [Crashlytics setUserIdentifier:[[PEGSession sharedPEGSession] matResp]];
        [Crashlytics setUserName:[[PEGSession sharedPEGSession] matResp]];
        
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
        
        [self startGPSStandardUpdates];
        
        //FIX ME
        //    [[LibTraceParse sharedInstance] loginUserToLiveLogSystemWithUserId:[SPIRSession username]];
        
        // Check if network is measured
        //NSString* DebitFunction =[SPIRFunction endpointForFunction:@"DEBIT"];
        //FIX ME
        //    [[LibTraceParse sharedInstance] setAskMeasureNetwork: DebitFunction];
        
        //TSE ICI on fait l'initialisation
        //    PEGInitAdrexo * v_PEGInitAdrexo=[[PEGInitAdrexo alloc]init];
        //    [v_PEGInitAdrexo performSelectorOnMainThread:@selector(InitialiseAdrexo:) withObject:PEG_WS_ENVIRONNEMENT waitUntilDone:YES];
        
        [self callModuleCom ];
 
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            while(YES){
                // pm_06 : @autoreleasepool inside the loop. Otherwise the memory is never released !
                @autoreleasepool {
                    @try{
                        sleep(30);
                        
                        if([PEGSession sharedPEGSession].IsSynchroOK){
                            // on essaie de transférer ttes les images pas encore uploadées
                            // On en fait que 5 à la fois pour pas saturer la mémoire
                            int v_NbPhotoSend = 0;
                            NSArray* v_arrayPhoto = [[PEG_FMobilitePegase CreateImage] GetAllBeanPhotoNotSend];
                            NSLog (@"---> Background, %d photos to send: %@", v_arrayPhoto.count, v_arrayPhoto);
                            for (BeanPhoto* v_BeanPhoto in v_arrayPhoto) {
                                UIImage* v_image=[[PEG_FMobilitePegase CreateImage] GetPictureFromFileById:[v_BeanPhoto.idPresentoir intValue]];
                                PEG_BeanImage *v_BeanImage = [[PEG_BeanImage alloc ]init];
                                v_BeanImage.IdImage=[v_BeanPhoto.idPresentoir intValue];
                                v_BeanImage.NomImage=[NSString stringWithFormat:@"%@.jpg",v_BeanPhoto.idPresentoir];
                                v_BeanImage.Image=v_image;
                                [v_BeanImage SaveBeanImageWithObserver:self];
                                [[PEG_FMobilitePegase CreateImage] SavePhotoSending:[v_BeanPhoto.idPresentoir intValue]];
                                NSLog (@"---> Background, sending photo : %@", v_BeanPhoto.idPresentoir);
                                v_NbPhotoSend++;
                                if(v_NbPhotoSend >= 5) break;
                            }
                            v_arrayPhoto = nil;//Pour liberer la mémoire des UIImage
                        }
                    }
                    @catch (NSException *p_exception) {
                        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate, envoi des photos" andExparams:@""];
                    }
                }
            }
        });
        
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

-(void) fillFinishedSaveBeanImage:(PEG_BeanImage*)p_BeanImage
{
    @try{
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[PEG_FMobilitePegase CreateImage] SavePhotoSend:p_BeanImage.IdImage];
        //});
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate.fillFinishedSaveBeanImage" andExparams:@""];
    }
}

-(void) finishedWithErrorSaveBeanImage:(PEG_BeanImage*)p_BeanImage
{
    @try{
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[PEG_FMobilitePegase CreateImage] SavePhotoNotSend:p_BeanImage.IdImage];
        //});
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate." andExparams:@""];
    }
}


#pragma mark Add For Core Data

- (NSManagedObjectContext *) managedObjectContext {
    @try{
        if (managedObjectContext != nil) {
            return managedObjectContext;
        }
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            managedObjectContext = [[NSManagedObjectContext alloc] init];
            [managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
        
        return managedObjectContext;
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}



- (NSManagedObjectModel *)managedObjectModel {
    @try{
        if (managedObjectModel != nil) {
            return managedObjectModel;
        }
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        return managedObjectModel;
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    @try
    {
        if (persistentStoreCoordinator != nil) {
            return persistentStoreCoordinator;
        }
        NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                                   stringByAppendingPathComponent: @"BeanMobilitePegase.sqlite"]];
        
        DLog(@"Répertoire Base Core Data%@",storeUrl);
        
        NSError *error = nil;
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                      initWithManagedObjectModel:[self managedObjectModel]];
        if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                     configuration:nil URL:storeUrl options:nil error:&error]) {
            NSLog(@"Erreur de chargement du magasin BeanMobilitePegase.sqlite (On le renome) : %@",storeUrl);
            
            //On arrive plus a charger le CoreData, donc on renome le fichier pour repartir à 0
            NSString *filePath = [NSString stringWithFormat:@"%@/BeanMobilitePegase.sqlite",
                                  [self applicationDocumentsDirectory]];
            DLog(@"Répertoire Base Core Data%@",filePath);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
            NSString *filePathRename = [NSString stringWithFormat:@"%@/%@BeanMobilitePegaseKO.sqlite",[self applicationDocumentsDirectory],[dateFormatter stringFromDate:[NSDate date]]];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            if ([fileMgr moveItemAtPath:filePath toPath:filePathRename error:&error] != YES)
            {
                NSLog(@"Unable to move file: %@", [error localizedDescription]);
            }
            else
            {
                if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                             configuration:nil URL:storeUrl options:nil error:&error]) {
                    NSLog(@"Erreur dans la deuxieme tentative de chargement du magasin BeanMobilitePegase.sqlite");
                    [NSException raise:@"CoreData" format:@"Erreur dans la deuxieme tentative de chargement du magasin BeanMobilitePegase.sqlite"];
                }
                else
                {
                    [NSException raise:@"CoreData" format:@"Erreur dans la tentative de chargement du magasin BeanMobilitePegase.sqlite on l'a rennomé '%@' et crée un vierge",filePathRename];
                }
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans persistentStoreCoordinator" andExparams:nil];
    }
    
    return persistentStoreCoordinator;
}

- (NSManagedObjectContext *) managedObjectContextPhoto {
    @try{
        if (managedObjectContextPhoto != nil) {
            return managedObjectContextPhoto;
        }
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinatorPhoto];
        if (coordinator != nil) {
            managedObjectContextPhoto = [[NSManagedObjectContext alloc] init];
            [managedObjectContextPhoto setPersistentStoreCoordinator: coordinator];
        }
        
        return managedObjectContextPhoto;
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans managedObjectContextPhoto" andExparams:@""];
    }
}



- (NSManagedObjectModel *)managedObjectModelPhoto {
    @try{
        if (managedObjectModelPhoto != nil) {
            return managedObjectModelPhoto;
        }
        managedObjectModelPhoto = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        return managedObjectModelPhoto;
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans managedObjectModelPhoto" andExparams:@""];
    }
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorPhoto {
    @try
    {
        if (persistentStoreCoordinatorPhoto != nil) {
            return persistentStoreCoordinatorPhoto;
        }
        NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                                   stringByAppendingPathComponent: @"BeanMobilitePegase.sqlite"]];
        
        DLog(@"Répertoire Base Core Data%@",storeUrl);
        
        NSError *error = nil;
        persistentStoreCoordinatorPhoto = [[NSPersistentStoreCoordinator alloc]
                                      initWithManagedObjectModel:[self managedObjectModelPhoto]];
        if(![persistentStoreCoordinatorPhoto addPersistentStoreWithType:NSSQLiteStoreType
                                                     configuration:nil URL:storeUrl options:nil error:&error]) {
            NSLog(@"Erreur de chargement du magasin BeanMobilitePegase.sqlite pour le context Photo %@",storeUrl);
            
            //On arrive plus a charger le CoreData, donc on renome le fichier pour repartir à 0
            /*NSString *filePath = [NSString stringWithFormat:@"%@/BeanMobilitePegase.sqlite",
                                  [self applicationDocumentsDirectory]];
            DLog(@"Répertoire Base Core Data%@",filePath);
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
            NSString *filePathRename = [NSString stringWithFormat:@"%@/%@BeanMobilitePegaseKO.sqlite",[self applicationDocumentsDirectory],[dateFormatter stringFromDate:[NSDate date]]];
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            if ([fileMgr moveItemAtPath:filePath toPath:filePathRename error:&error] != YES)
            {
                NSLog(@"Unable to move file: %@", [error localizedDescription]);
            }
            else
            {
                if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                             configuration:nil URL:storeUrl options:nil error:&error]) {
                    NSLog(@"Erreur dans la deuxieme tentative de chargement du magasin BeanMobilitePegase.sqlite");
                    [NSException raise:@"CoreData" format:@"Erreur dans la deuxieme tentative de chargement du magasin BeanMobilitePegase.sqlite"];
                }
                else
                {
                    [NSException raise:@"CoreData" format:@"Erreur dans la tentative de chargement du magasin BeanMobilitePegase.sqlite on l'a rennomé '%@' et crée un vierge",filePathRename];
                }
            }*/
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans persistentStoreCoordinator" andExparams:nil];
    }
    
    return persistentStoreCoordinatorPhoto;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//Add For Core Data

#pragma mark - Shake handling

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    @try{
        if (self.lastAcceleration)
        {
            if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 2))
            {
                histeresisExcited = YES;
                
                NSString *CFBundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
                NSString *message = [NSString stringWithFormat:@"%@ - [%@] - %@ (%@)", CFBundleDisplayName, PEG_WS_ENVIRONNEMENT,PEG_APP_VERSION, PEG_BUILD_VERSION];
                
                UIAlertView *debugAlertView;
                
                debugAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"Mail rapport",nil];
                
                debugAlertView.delegate = self;
                self.debugAlertView = debugAlertView;
                [debugAlertView show];
            }
            else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 1.7))
            {
                histeresisExcited = NO;
            }
        }
        
        self.lastAcceleration = acceleration;
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEGAppDelegate" andExparams:@""];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanParametre" inManagedObjectContext:self.managedObjectContext]];
        BeanParametre * v_BeanParametre =[[self.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        if(v_BeanParametre==nil){
            v_BeanParametre = (BeanParametre *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanParametre" inManagedObjectContext:self.managedObjectContext];
            
        }
        v_BeanParametre.idCommunication=[NSNumber numberWithInt:alertView.tag];
        
        [[PEG_FMobilitePegase CreateCoreData] Save];
    }
    if (buttonIndex == 1)
    {
        NSLog(@"Reply");
        [self SendCodeDATA];
    }
    
}

-(void)SendCodeDATA{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"BeanMobilitePegase.sqlite"];
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	if (controller) {
		controller.mailComposeDelegate = self;
		
		[controller setToRecipients:[NSArray arrayWithObjects:@"tservan@spir.fr",@"mspriet@spir.fr",@"imachmedia@gmail.com",nil]];
		NSString *CFBundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
		NSString *Title = [NSString stringWithFormat:@"%@ - [%@] User : %@",CFBundleDisplayName, PEG_WS_ENVIRONNEMENT, [[PEGSession sharedPEGSession] matResp]]  ;
		
		
		//NSString *message = [NSString stringWithFormat:@"Version : %@ - [%@] - %@ (%@) \nIs admin : %c", CFBundleDisplayName, PEG_WS_ENVIRONNEMENT,PEG_APP_VERSION, PEG_BUILD_VERSION,[[PEGSession sharedPEGSession] IsAdmin]];
		// UIDevice *device = [UIDevice currentDevice];
		//    NSString *message = [NSString stringWithFormat:@"Version : %@ - [%@] - %@ (%@) \n ID_Session:%@", CFBundleDisplayName, PEG_WS_ENVIRONNEMENT,PEG_APP_VERSION, PEG_BUILD_VERSION,[device uniqueIdentifier]];
		NSString *message = [NSString stringWithFormat:@"Version : %@ - [%@] - %@ (%@)", CFBundleDisplayName, PEG_WS_ENVIRONNEMENT,PEG_APP_VERSION, PEG_BUILD_VERSION];
		
		//    [self addRequestHeader:@"X-Device-Id" value:[device uniqueIdentifier]];
		//    [self addRequestHeader:@"X-Device-Os-Name" value:[device systemName]];
		//    [self addRequestHeader:@"X-Device-Os-Version" value:[device systemVersion]];
		//    [self addRequestHeader:@"X-Device-Model" value:[device platform]];
		//    [self addRequestHeader:@"X-Device-Name" value:[device name]];
		[controller setSubject:Title];
		[controller setMessageBody:message isHTML:NO];
		NSData *myData = [NSData dataWithContentsOfFile:filePath];
		
		[controller addAttachmentData:myData mimeType:@"application/x-sqlite3" fileName:@"BeanMobilitePegase.sqlite"];
		
		[self.window.rootViewController  presentViewController:controller animated:YES completion:NULL];	// pm201402 cas si pas de messagerie
	}
    
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error  {
    
    
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application {
	//[super applicationDidReceiveMemoryWarning:application];
    
    CLS_LOG(@"Warning Memory");
    if(self.nbMemoryWarning >= 1)
    {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:[NSString stringWithFormat:@"%@ - Warning Memory",NSStringFromClass([self class])] andExparams:[NSString stringWithFormat:@"Matricule : %@",[[PEGSession sharedPEGSession] matResp]]];
        // ALog(@"Warning");
        
        [[PEG_FMobilitePegase CreateGoogleAnalytics] SendException:@"applicationDidReceiveMemoryWarning"];
        
        UIAlertView *debugAlertView;
        debugAlertView = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                    message:@"Pb de mémoire. Vous devez quitter et relancer l'application."
                                                   delegate:nil
                                          cancelButtonTitle:@"Quitter"
                                          otherButtonTitles:nil];
        
        debugAlertView.delegate = self;
        [debugAlertView show];
    }
    self.nbMemoryWarning++;     // pm 11/2014 nbMemoryWarning reset only when app launches, ie not very often !
}

-(void)callModuleCom
{
    NSNumber* v_idSequence=[NSNumber numberWithInt:0];
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    [req setEntity:[NSEntityDescription entityForName:@"BeanParametre" inManagedObjectContext:self.managedObjectContext]];
    
    BeanParametre * v_BeanParametre =[[self.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    if(v_BeanParametre.idCommunication !=nil)
        v_idSequence=v_BeanParametre.idCommunication;
    
	
    
    [[PEGWebServices sharedWebServices] GetBeanCommunicationByIDRequest:v_idSequence succes:^(PEG_BeanCommunication* p_BeanCommunication) {
        
        //NSLog (@"getBeanTourneeByMatricule success");
        if(p_BeanCommunication.Message !=nil){
            UIAlertView *debugAlertView;
            
            debugAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:p_BeanCommunication.Message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
            
            debugAlertView.delegate = self;
            debugAlertView.tag=p_BeanCommunication.idsequence;
            self.debugAlertView = debugAlertView;
            [debugAlertView show];
        }

    } failure:^(NSError *error) {
        //NSLog (@"getBeanTourneeByMatricule failure.");
        //[self finishedWithErrorGetBeanTournee];
    }];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application
{
    // On n'oblige a fermer que si changement de jour
    if([[PEG_FMobilitePegase CreateMobilitePegaseService] IsChangementJourDepuisDerniereSynchro])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Changement de journée"
                              message:@"Suite à un changement de jour, vous devez redemarrer l'application pour faire une synchronisation."
                              delegate:self
                              cancelButtonTitle:@"Quitter"
                              otherButtonTitles:nil];
        
        [alert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Quitter"])
    {
        NSLog(@"Button Quitter.");
        exit(0);
    }
}

@end
