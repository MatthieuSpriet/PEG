//
//  UIColor+Extensions.h
//  Phoenix
//
//  Copyright (c) 2010 SQLI. Tous droits réservés.
//  Développé par SQLI Agency.
//

/*!
 @header UIColor+Extensions.h
 @abstract Extensions UIColor de Phoenix
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 @abstract Extensions UIColor de Phoenix.
 @availability Disponible dans Phoenix 1.0 et supérieur.
 */
@interface UIColor (PXExtensions) 

/*!
 @abstract Crée un objet <code>UIColor</code> à l'aide du code héxadécimal de la couleur.
 @availability Disponible dans Phoenix 1.0 et supérieur.
 @param rgbValue La valeur HTML de la couleur au format entier long (ex : 0xFF0000 pour rouge).
 @result L'instance de l'objet <code>UIColor</code> initialisée (en autorelease).
 */
+ (UIColor *)colorFromRGBHex:(long)rgbValue DEPRECATED_ATTRIBUTE;


+ (UIColor *)colorFromHex:(long)hexValue;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
