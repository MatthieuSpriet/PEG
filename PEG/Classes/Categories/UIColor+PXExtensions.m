//
//  UIColor+Extensions.m
//  Phoenix
//
//  Copyright (c) 2010 SQLI. Tous droits réservés.
//  Développé par SQLI Agency.
//

#import "UIColor+PXExtensions.h"

@implementation UIColor (PXExtensions) 

/*!
 @abstract Crée un objet <code>UIColor</code> à l'aide du code héxadécimal de la couleur.
 @availability Disponible dans Phoenix 1.0 et supérieur.
 @param rgbValue La valeur HTML de la couleur au format entier long (ex : 0xFF0000 pour rouge).
 @result L'instance de l'objet <code>UIColor</code> initialisée (en autorelease).
 */
+ (UIColor *)colorFromRGBHex:(long)rgbValue
{
	return [UIColor colorWithRed:((float)((rgbValue & 0x00FF0000) >> 16) / 255.0) 
						   green:((float)((rgbValue & 0x0000FF00) >> 8) / 255.0) 
							blue:((float)(rgbValue & 0x000000FF) / 255.0) 
						   alpha:1.0];
}


+ (UIColor *)colorFromHex:(long)hexValue
{
	return [UIColor colorWithRed:((float)((hexValue & 0x00FF0000) >> 16) / 255.0) 
						   green:((float)((hexValue & 0x0000FF00) >> 8) / 255.0) 
							blue:((float)(hexValue & 0x000000FF) / 255.0) 
						   alpha:1.0];
}


BOOL validChar(unichar c) 
{
	return (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F') || (c >= '0' && c <= '9');
}

NSInteger integerValue(unichar c) 
{
	if (c >= '0' && c <= '9') 
	{
		return c - '0';
	} 
	else if (c >= 'A' && c <= 'F') 
	{
		return (c - 'A') + 10;
	} 
	else 
	{
		return (c - 'a') + 10;
	}
}

NSInteger getColor(NSString* string, NSInteger start) 
{
	unichar c1 = [string characterAtIndex:start];
	unichar c2 = [string characterAtIndex:start + 1];
	
	if (validChar(c1) && validChar(c2)) 
	{
		return integerValue(c1) << 4 | integerValue(c2);
	}
	
	return -1;
}


+ (UIColor *)colorFromHexString:(NSString *)string
{
	if (string.length == 0) 
	{
		return nil;
	}
	
	if (![string hasPrefix:@"0x"] && ![string hasPrefix:@"0X"]) 
	{
		return nil;
	}
	
	string = [string substringFromIndex:2];
	if (string.length == 6) 
	{
		//rgb
		NSInteger red, green, blue;
		if ((red = getColor(string, 0)) == -1 || (green = getColor(string, 2)) == -1 || (blue = getColor(string, 4)) == -1) 
		{
			return nil;
		}
		return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
	} 
	else if (string.length == 8) 
	{
		//argb
		NSInteger red, green, blue, alpha;
		if ((alpha = getColor(string, 0)) == -1 || (red = getColor(string, 2)) == -1 || (green = getColor(string, 4)) == -1 || (blue = getColor(string, 6)) == -1) 
		{
			return nil;
		}
		return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
	} 
	else 
	{
		return nil;
	}
}

@end
