//
//  SPIRSession.h
//  SPIR
//
//  Created by Antoine Marcadet on 07/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

/*!
 Classe offrant la gestion des données utilisateur dans le Keychain (nom d'utilisateur et mot de passe).
 */
extern NSString* const PEGLoginSucceedNotification;
extern NSString* const PEGLoginFailedNotification;
extern NSString* const PEGLogoutNotification;
extern NSString* const PEGLogoutForcedNotification;
@interface SPIRSession : NSObject

/*!
 Permet de vérifier si l'utilisateur est connecté.
 @see hasSessionInKeychain
 @return YES si l'utilisateur est connecté.
 */
+ (BOOL)isLogged;

/*!
 Permet de vérifier si l'utilisateur s'est déjà connecté et dispose d'une session dans le keychain.
 @see isLogged
 @return YES si l'utilisateur s'est déjà connecté et dispose d'une session dans le keychain.
 */
+ (BOOL)hasSessionInKeychain;

/*!
 Le nom d'utilisateur (matricule) de l'utilisateur connecté.
 @see password
 @return Renvoie le matricule de l'utilisateur connecté.
 */
+ (NSString *)username;

/*!
 Le mot de passe de l'utilisateur connecté.
 @see username
 @return Renvoie le mot de passe de l'utilisateur connecté.
 */
+ (NSString *)password;



+ (BOOL)saveUsername:(NSString *)username andPassword:(NSString *)password;
+ (void)logout;
+ (void)setLogged:(BOOL)yesOrNo;


@end
