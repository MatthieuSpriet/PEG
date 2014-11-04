//
//  SQLIAppFinder.m
//  SQLIStore
//
//  Created by Christophe BUGUET on 09/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPIRMobileInstallationProxy.h"

@implementation SPIRMobileInstallationProxy

@synthesize delegate;

static id foundEntry = nil;

#pragma mark -
#pragma mark Recherche d'applications

static int lookup_mibcallback(NSDictionary *dict, NSString *bundleIdentifier)
{
	NSArray *currentlist = [dict objectForKey:@"CurrentList"];
	if (currentlist) 
	{
		for (NSDictionary *appinfo in currentlist) 
		{
			if ([[appinfo objectForKey:@"CFBundleIdentifier"] isEqualToString:bundleIdentifier]) 
			{
				foundEntry = [appinfo copy];
				return 1;
			}
		}
	}
	return 0;
}

+ (NSDictionary *)findAppForIdentifier:(NSString *)bundleIdentifier
{
	DLog(@"Recherche de %@", bundleIdentifier);
	
	if (foundEntry != nil)
	{
		foundEntry = nil;
	}
	MobileInstallationBrowse([NSDictionary dictionaryWithObject:@"Any" forKey:@"ApplicationType"],
							 &lookup_mibcallback,
							 bundleIdentifier);
	return [foundEntry copy];
}



#pragma mark -
#pragma mark Installation

// dict contient le status de l'installation en cours et le pourcentage d'avancement de l'installation
// les status disponibles sont :
//	- TakingInstallLock
//  - CreatingStagingDirectory
//  - StagingPackage
//  - ExtractingPackage
//  - InspectingPackage
//  - PreflightingApplication
//  - InstallingEmbeddedProfile
//  - VerifyingApplication
//  - CreatingContainer
//  - InstallingApplication
//  - PostflightingApplication
//  - SandboxingApplication
//  - GeneratingApplicationMap
//  - Complete
static int install_mibcallback(NSDictionary *dict, NSString *packagePath)
{
	DLog(@"Dict : %@", dict);
	/* 
	output :
	{
	 PercentComplete = 0;
	 Status = TakingInstallLock;
	}
	*/
	
	DLog(@"PackagePath : %@", packagePath);
	
	/*if ([[dict objectForKey:@"Status"] isEqualToString:@"Complete"])
	{
		return 1;
	}*/
	
	return 1;
}

+ (BOOL)install:(NSString *)packagePath
{
	NSString *filePath = @"/var/mobile/Media/foobar.txt";
	NSString *contents = @"coucou";
	
	NSError *error = nil;
	[contents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
	if (error)
	{
		DLog(@"Erreur = %@", [error localizedDescription]);
		return NO;
	}
	
	BOOL readable = [[NSFileManager defaultManager] isReadableFileAtPath:filePath];
	if (readable)
	{
		DLog(@"readable");
	}
	else
	{
		DLog(@"not readable");
	}

	
	DLog(@"Installation de : %@", packagePath);
	
	//NSDictionary *options = [NSDictionary dictionaryWithObject:@"Customer" forKey:@"PackageType"];
	//MobileInstallationInstall(options, NULL, &install_mibcallback, packagePath);

	return YES;
}

@end
