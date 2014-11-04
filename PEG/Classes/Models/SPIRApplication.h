//
//  SQLIApplication.h
//  SQLIStore
//
//  Created by Antoine Marcadet on 21/02/11.
//  Copyright 2011 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

typedef enum {
	SPIRApplicationStatusNone = 0,
	SPIRApplicationStatusInstall = 1,
	SPIRApplicationStatusUpdate = 2,
	SPIRApplicationStatusInstalled = 3
} SPIRApplicationStatus;

typedef enum {
	SPIRApplicationUpdateTypeMajor = 0,
	SPIRApplicationUpdateTypeMinor = 1
} SPIRApplicationUpdateType;

@protocol SPIRApplicationDelegate;


typedef struct {
	NSInteger major;
	NSInteger minor;
	NSInteger fixes;
	NSInteger build;
} SPIRApplicationVersion;

/*!
 Renvoie une structure contenant le numéro de version.
 */
SPIRApplicationVersion SPIRApplicationVersionFromString(NSString *string);

/*!
 Renvoie une chaîne de caractères contenant le numéro de version, formattée avec des "." comme séparateurs.
 
 Cette fonction pour être utilisée à des fins de debug.
 */
NSString *NSStringFromSPIRApplicationVersion(SPIRApplicationVersion version);

/*!
 Compare la précédence entre 2 versions d'application.
 
 Si version1 est plus récent que version2, la valeur retournée sera <code>NSOrderedDescending</code>.<br />
 Si version1 est plus vieux que version2, la valeur retournée sera <code>NSOrderedAscending</code>.<br />
 Sinon la valeur retournée sera NSOrderedSame.
 
 Exemple :
 
	NSComparisonResult result;

	result = SPIRApplicationVersionCompare({ 1, 1, 2 }, { 1, 1, 1 });
	// result = NSOrderedDescending
 
	result = SPIRApplicationVersionCompare({ 1, 1, 1 }, { 1, 1, 2 });
	// result = NSOrderedAscending
 
	result = SPIRApplicationVersionCompare({ 1, 1, 1 }, { 1, 1, 1 });
	// result = NSOrderedSame
	 
 */
NSComparisonResult SPIRApplicationVersionCompare(SPIRApplicationVersion version1, SPIRApplicationVersion version2);

const SPIRApplicationVersion SPIRApplicationVersionZero;

/*!
 Cette classe décrit une application telle que renvoyée par les WS du store.
 
 ...
 */
@interface SPIRApplication : NSObject 
{
	NSString						*name;
	NSString						*bundleIdentifier;		// com.company.appname
	NSString						*bundleVersion;			// numéro de version, ex : 1.0
	NSString						*bundleShortVersion;	// numéro de version avec build, ex : 1.0 (116) 
	NSString						*bundleBuildNumber;		// numéro de build seul, ex : 116
	SPIRApplicationVersion			 version;				// struct normée avec le numéro de version complet (major, minor, fixes, build)
	NSURL							*manifest;
	NSDate							*date;
	NSURL							*logoURL;
	UIImage							*logo;
	NSString						*company;
	NSString						*changelog;
	NSString						*descriptionText;
    NSString                        *storeId;
	SPIRApplicationStatus			 status;
	NSInteger						 filesize;
	NSURL							*urlScheme;
	SPIRApplicationUpdateType		 updateType;
	
	NSInteger						 indexOfLayerInCarousel;
	
@private
//    ASIHTTPRequest					*imageRequest;
	id <SPIRApplicationDelegate>	 delegate;
}

@property (nonatomic, copy) NSString						*name;
@property (nonatomic, copy) NSString						*bundleIdentifier;

@property (nonatomic, copy) NSString						*bundleVersion;
@property (nonatomic, copy) NSString						*bundleBuildNumber;
@property (nonatomic, copy) NSString						*bundleShortVersion;
@property (nonatomic, readonly) SPIRApplicationVersion		 version;

@property (nonatomic, copy) NSURL							*manifest;
@property (nonatomic, copy) NSDate							*date;
@property (nonatomic, copy) NSURL							*logoURL;
@property (nonatomic, copy) UIImage							*logo;
@property (nonatomic, copy) NSString						*company;
@property (nonatomic, copy) NSString						*changelog;
@property (nonatomic, copy) NSString						*descriptionText;
@property (nonatomic, copy) NSString						*storeId;
@property (nonatomic, assign) SPIRApplicationStatus			 status;
@property (nonatomic, assign) NSInteger						 filesize;
@property (nonatomic, assign) NSInteger						 indexOfLayerInCarousel;
@property (nonatomic, copy) NSURL							*urlScheme;
@property (nonatomic, assign) SPIRApplicationUpdateType		 updateType;

//- (void)startDownloadWithDelegate:(id <SPIRApplicationDelegate>)delegate;
//- (void)cancelDownload;
- (id)initWithDictionary:(NSDictionary *)dict;

@end

@protocol SPIRApplicationDelegate

- (void)applicationLogoDidLoad:(SPIRApplication *)application;

@end