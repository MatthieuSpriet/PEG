//
//  SPIRMobileInstallationProxy.h
//  SQLIStore
//
//  Created by Antoine Marcadet on 09/10/10.
//  Copyright 2010 SQLI Agency. All rights reserved.
//

/* pm 5 novembre 2014
 Ce code est sans doute en partie obsolete
 findAppForIdentifier en particulier faisait appel à un framework privé qui n'est plus accessible (erreur compilation) sous iOS8 (et sans doute avant !)
 */


int MobileInstallationBrowse(NSDictionary *options, int (*mibcallback)(NSDictionary *dict, NSString *bundleIdentifier), NSString *bundleIdentifier);
int MobileInstallationInstall(NSDictionary *options, id, int (*mibcallback)(NSDictionary *dict, NSString *packagePath), NSString *packagePath);

@protocol SQLIMobileInstallationDelegate;

/*!
 @abstract Classe utilitaire pour rechercher les applications installées.
 */
@interface SPIRMobileInstallationProxy : NSObject 
{
	id <SQLIMobileInstallationDelegate> __weak delegate;
}

@property (weak) id <SQLIMobileInstallationDelegate> delegate;

/*!
 @abstract Recherche si l'application spécifiée par son Bundle Identifier est présente dans le système.
 @discussion La fonctionnalité utilise le framework privé MobileInstallation pour la recherche d'application.
 @param bundleIdentifier L'identifiant de l'application à rechercher.
 @result Un dictionnaire contenant les informations de l'application.
 */
+ (NSDictionary *)findAppForIdentifier:(NSString *)bundleIdentifier;

+ (BOOL)install:(NSString *)packagePath;

@end



@protocol SQLIMobileInstallationDelegate

@optional


@end