//
//  NSDictionary+SPIRExtensions.h
//  Components
//
//  Created by Antoine Marcadet on 29/06/11.
//  Copyright 2011 SPIR Communications S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Cette catégorie fourni un ensemble de méthodes pour accéder plus simplement à des valeurs.
 
 Elle assurer la caste des valeurs renvoyées afin de minimiser les erreurs.
 
 Exemple d'utilisation :
 
 NSDictionary *myDictionary = [NSDictionary dictionary];
 // affectation de valeurs dans le dictionnaire
 
 // pour récupérer un entier il est possible de faire
 NSInteger anInteger = [myDictionary integerForKey:@"myIntegerKey"];
 // ou bien
 NSInteger anInteger = [myDictionary integerForKeyPath:@"myIntegerKey.path"];
 
 // pour récupérer un tableau à coup sûr afin de pouvoir boucler dessus
 NSArray *anArray = [myDictionary arrayForKey:@"anArray"];
 
 */
@interface NSDictionary (ConvenientAccess)

/*! @name Gestion des nombres */

/*!
 Renvoie l'entier se trouvant à la key précisée.
 @see integerForKeyPath:
 @param key La key pour laquelle on souhaite récupérer la valeur.
 @return L'entier se trouvant à la key précisée.
 */
- (int)integerForKey:(id)key;

/*!
 Renvoie l'entier se trouvant au keypath précisé.
 @see integerForKey:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param keyPath Un keypath de la forme _relationship.property_ pour lequel on souhaite récupérer la valeur.
 @return L'entier se trouvant au keypath précisé.
 */
- (int)integerForKeyPath:(id)keyPath;

/*!
 Renvoie le flottant se trouvant à la key précisée.
 @see floatForKeyPath:
 @param key La key pour laquelle on souhaite récupérer la valeur.
 @return Le flottant se trouvant à la key précisée.
 */
- (float)floatForKey:(id)key;

/*!
 Renvoie le flottant se trouvant au keypath précisé.
 @see floatForKey:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param keyPath Un keypath de la forme _relationship.property_ pour lequel on souhaite récupérer la valeur.
 @return Le flottant se trouvant au keypath précisé.
 */
- (float)floatForKeyPath:(id)keyPath;

/*!
 Renvoie le booléen se trouvant à la key précisée.
 @see boolForKeyPath:
 @param key La key pour laquelle on souhaite récupérer la valeur.
 @return Le booléen se trouvant à la key précisée.
 */
- (BOOL)boolForKey:(id)key;

/*!
 Renvoie le booléen se trouvant au keypath précisé.
 @see boolForKey:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param keyPath Un keypath de la forme _relationship.property_ pour lequel on souhaite récupérer la valeur.
 @return Le booléen se trouvant au keypath précisé.
 */
- (BOOL)boolForKeyPath:(id)keyPath;


/*! @name Gestion des chaînes de caractères */

/*!
 Renvoie la chaîne de caractère se trouvant à la key précisée.
 
 Si la valeur contenue dans le NSDictionary est <code>nil</code>, "<code>null</code>", "<code>(null)</code>" ou "<code>&lt;null&gt;</code>" alors une chaine vide sera renvoyée.
 @see stringForKeyPath:
 @param key La key pour laquelle on souhaite récupérer la valeur.
 @return La chaîne de caractère se trouvant à la key précisée.
 */
- (NSString *)stringForKey:(id)key;
- (NSString *)trimmedStringForKey:(id)key;
- (NSString *)stringForKey:(id)key trimmingCharactersInSet:(NSCharacterSet *)characterSet;

/*!
 Renvoie la chaîne de caractère se trouvant au keypath précisé.
 
 Si la valeur contenue dans le NSDictionary est <code>nil</code>, "<code>null</code>", "<code>(null)</code>" ou "<code>&lt;null&gt;</code>" alors une chaine vide sera renvoyée.
 @see stringForKey:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param keyPath Un keypath de la forme _relationship.property_ pour lequel on souhaite récupérer la valeur.
 @return La chaîne de caractère se trouvant au keypath précisé.
 */
- (NSString *)stringForKeyPath:(id)keyPath;
- (NSString *)trimmedStringForKeyPath:(id)keyPath;
- (NSString *)stringForKeyPath:(id)keyPath trimmingCharactersInSet:(NSCharacterSet *)characterSet;


/** @name Gestion des URL */

/*!
 Renvoie l'URL se trouvant à la key précisée.
 @see URLForKeyPath:
 @param key La key pour laquelle on souhaite récupérer la valeur.
 @return L'URL se trouvant à la key précisée.
 */
- (NSURL *)URLForKey:(id)key;
- (NSURL *)trimmedURLForKey:(id)key;

/*!
 Renvoie l'URL se trouvant au keypath précisé.
 @see URLForKey:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param keyPath Un keypath de la forme _relationship.property_ pour lequel on souhaite récupérer la valeur.
 @return L'URL se trouvant au keypath précisé.
 */
- (NSURL *)URLForKeyPath:(id)keyPath;
- (NSURL *)trimmedURLForKeyPath:(id)keyPath;


/*! @name Gestion des dates */

- (NSDate *)dateForKey:(id)key usingFormat:(NSString *)format;
- (NSDate *)dateForKeyPath:(id)keyPath usingFormat:(NSString *)format;


/*! @name Gestion des tableaux */

/*!
 Renvoie le tableau se trouvant à la key précisée.
 
 Si l'objet se trouvant au keypath indiqué n'est pas de la classe NSArray, alors un NSArray contenant uniquement cet objet sera renvoyé.
 
 Cette fonction trouve par exemple son utilité lorsque l'on doit boucler sur un tableau, que le WS ne renvoie qu'un seul objet et que la librairie responsable du parsing (XMLReader ou JSONKit) génère un NSDictionary.
 @see arrayForKeyPath:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param key La key pour laquelle on souhaite récupérer la valeur.
 @return Le tableau se trouvant à la key précisée.
 */
- (NSArray *)arrayForKey:(id)key;

/*!
 Renvoie le tableau se trouvant au keypath précisé.
 
 Si l'objet se trouvant au keypath indiqué n'est pas de la classe NSArray, alors un NSArray contenant uniquement cet objet sera renvoyé.
 
 Cette fonction trouve par exemple son utilité lorsque l'on doit boucler sur un tableau, que le WS ne renvoie qu'un seul objet et que la librairie responsable du parsing (XMLReader ou JSONKit) génère un NSDictionary.
 @see arrayForKey:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param keyPath Un keypath de la forme _relationship.property_ pour lequel on souhaite récupérer la valeur.
 @return Le tableau se trouvant au keypath précisé.
 */
- (NSArray *)arrayForKeyPath:(id)keyPath;


/** @name Vérification sur les données */

/*!
 Vérifie si une key du dictionnaire contient une valeur.
 @see containsSomethingForKeyPath:
 @param key La key pour laquelle on souhaite vérifier la présence d'une valeur.
 @return <code>YES</code> si une valeur existe pour la key précisée.
 */
- (BOOL)containsSomethingForKey:(id)key;

/*!
 Vérifie si un keypath du dictionnaire contient une valeur.
 @see containsSomethingForKey:
 @warning *Remarque:* Voir le [Key-Value Coding Programming Guide](https://developer.apple.com/library/ios/#documentation/cocoa/conceptual/KeyValueCoding/Articles/KeyValueCoding.html) pour plus d'information sur le fonctionnement du keypath.
 @param keyPath Un keypath de la forme _relationship.property_ pour lequel on souhaite vérifier la présence d'une valeur.
 @return <code>YES</code> si une valeur existe pour le keypath précisé.
 */
- (BOOL)containsSomethingForKeyPath:(id)keyPath;

@end
