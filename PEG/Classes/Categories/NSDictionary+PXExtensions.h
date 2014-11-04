//
//  NSDictionary+PXExtensions.h
//  Phoenix
//
//  Created by Antoine Marcadet on 20/01/11.
//  Copyright 2011 SQLI Agency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PXExtensions)

/*!
 @abstract Fusionne deux NSDictionary, les valeurs du deuxième dictionnaire viennent écraser celles du premier.
 @availability Disponible dans Phoenix 1.2 et supérieur.
 @param dict1 Le dictionnaire devant être étendu.
 @param dict2 Le dictionnaire d'extension.
 @result Une instance de NSDictionary contenant les données fusionnées.
 */
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2;
/*!
 @abstract Fusionne un NSDictionary avec celui fournit en paramètre, les valeurs du deuxième dictionnaire viennent écraser celes de l'objet courant.
 @availability Disponible dans Phoenix 1.2 et supérieur.
 @param dict Le dictionnaire d'extension.
 @result Une instance de NSDictionary contenant les données fusionnées.
 */
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict;


- (int)integerForKey:(id)key;
- (float)floatForKey:(id)key;
- (BOOL)boolForKey:(id)key;

/*!
 @abstract Identique a objectForKey:, sauf que cette méthode retourne toujours une NSString ou nil s'il n'y a pas d'objet pour cette clef.
 @discussion Utilise la méthode description pour convertir en NSString, tout objet qui ne serait pas une NSString.
 @availability Disponible dans Phoenix 1.2 et supérieur.
 @param key La clef dont on veut la valeur.
 @result Un objet NSString contenant la valeur de la clef.
 */
- (NSString *)stringForKey:(id)key;

/*!
 @abstract Renvoie YES si l'objet traité comme une NSString n'est pas vide.
 @availability Disponible dans Phoenix 1.2 et supérieur.
 */
- (BOOL)containsSomethingForKey:(id)key;

@end
