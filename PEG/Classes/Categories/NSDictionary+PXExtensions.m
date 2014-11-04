//
//  NSDictionary+PXExtensions.m
//  Phoenix
//
//  Created by Antoine Marcadet on 20/01/11.
//  Copyright 2011 SQLI Agency. All rights reserved.
//

#import "NSDictionary+PXExtensions.h"

@implementation NSDictionary (PXExtensions)

// source : http://stackoverflow.com/questions/4011781/deep-combine-nsdictionaries
// source : http://www.dejal.com/files/DSDictionaryCategories.m

// Fusionne deux NSDictionary, les valeurs du deuxième dictionnaire viennent écraser celles du premier.
+ (NSDictionary *)dictionaryByMerging:(NSDictionary *)dict1 with:(NSDictionary *)dict2
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithDictionary:dict1 copyItems:NO];
	
    [dict2 enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSDictionary class]] && [result containsSomethingForKey:key]) 
		{
            NSDictionary *newVal = [[result objectForKey:key] dictionaryByMergingWith:(NSDictionary *)obj];
            [result setObject:newVal forKey:key];
        } 
		else 
		{
		    [result setObject:obj forKey:key];
		}
    }];
	
    return (NSDictionary *)result;
}

// Fusionne un NSDictionary avec celui fournit en paramètre, les valeurs du deuxième dictionnaire viennent écraser celes de l'objet courant.
- (NSDictionary *)dictionaryByMergingWith:(NSDictionary *)dict 
{
    return [[self class] dictionaryByMerging:self with:dict];
}



/*
 integerForKey:
 
 Invokes stringForKey: with the key.  Returns 0 if no string is returned.  Otherwise, the resulting string is sent an intValue message, which provides this method's return value.
 
 Written by DJS 2005-02.
 */
- (int)integerForKey:(id)key
{
    NSString *value = [self stringForKey:key];
    
    if (value != nil)
	{
		return [value intValue];
	}
    else
	{
		return 0;
	}
}


/*
 floatForKey:
 
 Invokes stringForKey: with the key.  Returns 0.0 if no string is returned.  Otherwise, the resulting string is sent a floatValue message, which provides this method's return value.
 
 Written by DJS 2005-02.
 */
- (float)floatForKey:(id)key
{
    NSString *value = [self stringForKey:key];
    
    if (value != nil)
	{
        return [value floatValue];
	}
    else
	{
        return 0.0;
	}
}

/*
 boolForKey:
 
 Returns YES if the value for this key is a string containing "yes" (case insensitive), or a number with a non-zero value.  Otherwise returns NO.
 
 Written by DJS 2005-02.
 */
- (BOOL)boolForKey:(id)key
{
    NSString *value = [self stringForKey:key];
    
    if (value != nil)
	{
        return ([value intValue] || [[value lowercaseString] isEqualToString:@"yes"]);
	}
    else
	{
        return NO;
	}
}


// Identique a objectForKey:, sauf que cette méthode retourne toujours une NSString ou nil s'il n'y a pas d'objet pour cette clef.
- (NSString *)stringForKey:(id)key
{
    return [[self objectForKey:key] description];
}

// Renvoie YES si l'objet traité comme une NSString n'est pas vide.
- (BOOL)containsSomethingForKey:(id)key
{
    return ([[self stringForKey:key] length] > 0);
}

@end
