//
//  SPIROrderedDictionary.h
//  SPIRCRM
//
//  Created by Christophe Buguet on 09/11/10.
//  Copyright 2010 SPIR Communications S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 SPIROrderedDictionary est un remplacement du NSDictionary lorsque l'on souhaite conserver l'ordre d'ajout des objets dans le dictionnaire.
 
 Cette fonction s'avère utile lorsque l'on doit par exemple traiter des paramètres dans une URL dans un ordre précis.
 */
@interface SPIROrderedDictionary : NSMutableDictionary
{
	NSMutableDictionary *dictionary;
	NSMutableArray *array;
}

/** @name Modification des éléments du dictionnaire */

/*!
 Insère un objet dans le dictionnaire.
 @param object L'objet à insérer.
 @param key La clé associée à l'objet.
 @param index L'index auquel on ajoute l'objet.
 */
- (void)insertObject:(id)object forKey:(id)key atIndex:(NSUInteger)index;

/*!
 Supprime l'objet se trouvant à l'index fourni en paramètre.
 @param index L'index de l'objet à supprimer.
 */
- (void)removeObjectAtIndex:(NSInteger)index;


/** @name Récupération de valeurs */

/*!
 Renvoie la key dans le dictionnaire se trouvant à l'index fourni en paramètre.
 @param index L'index auquel on ajoute l'objet.
 @return La key dans le dictionnaire se trouvant à l'index fourni en paramètre.
 */
- (id)keyAtIndex:(NSUInteger)index;

/*!
 Renvoie l'objet se trouvant à l'index fourni en paramètre.
 @param index L'index de l'objet recherché.
 @return L'objet se trouvant à l'index fourni en paramètre.
 */
- (id)objectAtIndex:(NSInteger)index;

/*!
 Renvoie l'index de la clef fournie en paramètre.
 @param key La clef dont on cherche l'index.
 @return L'index de la clef.
 */
- (NSInteger)indexOfKey:(NSString*)key;

/*!
 Renvoie un énumérateur de clés du dictionnaire avec l'ordre inversé.
 @return Une instance de <code>NSEnumerator</code> avec l'ordre des clés inversée.
 */
- (NSEnumerator *)reverseKeyEnumerator;

@end