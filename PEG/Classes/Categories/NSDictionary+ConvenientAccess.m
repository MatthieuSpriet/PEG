//
//  NSDictionary+ConvenientAccess.m
//  Components
//
//  Created by Antoine Marcadet on 29/06/11.
//  Copyright 2011 SPIR Communications S.A. All rights reserved.
//

#import "NSDictionary+ConvenientAccess.h"

@implementation NSDictionary (ConvenientAccess)

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

- (int)integerForKeyPath:(id)keyPath
{
    NSString *value = [self stringForKeyPath:keyPath];
    
    if (value != nil)
	{
		return [value intValue];
	}
    else
	{
		return 0;
	}
}

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

- (float)floatForKeyPath:(id)keyPath
{
    NSString *value = [self stringForKeyPath:keyPath];
    
    if (value != nil)
	{
        return [value floatValue];
	}
    else
	{
        return 0.0;
	}
}

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

- (BOOL)boolForKeyPath:(id)keyPath
{
    NSString *value = [self stringForKeyPath:keyPath];
    
    if (value != nil)
	{
        return ([value intValue] || [[value lowercaseString] isEqualToString:@"yes"]);
	}
    else
	{
        return NO;
	}
}

- (NSString *)stringForKey:(id)key
{
	NSString *res = [[self objectForKey:key] description];
	if (res == nil)
	{
		return @"";
	}
	else if ([res isEqualToString:@"(null)"])
	{
		return @"";
	}
	else if ([res isEqualToString:@"<null>"])
	{
		return @"";
	}
	else if ([res isEqualToString:@"null"])
	{
		return @"";
	}
    return res;
}

- (NSString *)trimmedStringForKey:(id)key
{
	NSString *res = [self stringForKey:key];
	
	if ([res length] > 0)
	{
		return [res stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	return res;
}

- (NSString *)stringForKey:(id)key trimmingCharactersInSet:(NSCharacterSet *)characterSet
{
	NSString *res = [self stringForKey:key];
	
	if ([res length] > 0)
	{
		return [res stringByTrimmingCharactersInSet:characterSet];
	}
	
	return res;
}

- (NSString *)stringForKeyPath:(id)keyPath
{
	NSString *res = [[self valueForKeyPath:keyPath] description];
	if (res == nil)
	{
		return @"";
	}
	else if ([res isEqualToString:@"(null)"])
	{
		return @"";
	}
	else if ([res isEqualToString:@"<null>"])
	{
		return @"";
	}
	else if ([res isEqualToString:@"null"])
	{
		return @"";
	}
    return res;
}

- (NSString *)trimmedStringForKeyPath:(id)keyPath
{
	NSString *res = [self stringForKeyPath:keyPath];
	
	if ([res length] > 0)
	{
		return [res stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}
	
	return res;
}

- (NSString *)stringForKeyPath:(id)keyPath trimmingCharactersInSet:(NSCharacterSet *)characterSet
{
	NSString *res = [self stringForKeyPath:keyPath];
	
	if ([res length] > 0)
	{
		return [res stringByTrimmingCharactersInSet:characterSet];
	}
	
	return res;
}

- (NSURL *)URLForKey:(id)key
{
	return [NSURL URLWithString:[self stringForKey:key]];
}

- (NSURL *)trimmedURLForKey:(id)key
{
	return [NSURL URLWithString:[self trimmedStringForKey:key]];
}

- (NSURL *)URLForKeyPath:(id)keyPath
{
	return [NSURL URLWithString:[self stringForKeyPath:keyPath]];
}

- (NSURL *)trimmedURLForKeyPath:(id)keyPath;
{
	return [NSURL URLWithString:[self trimmedStringForKeyPath:keyPath]];
}

- (NSDate *)dateForKey:(id)key usingFormat:(NSString *)format
{
	NSDate *date = [self objectForKey:key];
	if (date != nil)
	{
		if ([date isKindOfClass:[NSString class]])
		{
			NSString *dateString = (NSString *)date;
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:format];
			
			date = [dateFormatter dateFromString:dateString];
			
		}
		else
		{
			[NSException raise:@"MismatchDataType" format:@"Object of class '%@' can't be converted to 'NSDate'", NSStringFromClass([date class])];
		}
	}
	return date;
}

- (NSDate *)dateForKeyPath:(id)keyPath usingFormat:(NSString *)format
{
	NSDate *date = [self valueForKeyPath:keyPath];
	if (date != nil)
	{
		if ([date isKindOfClass:[NSString class]])
		{
			NSString *dateString = (NSString *)date;
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:format];
			
			date = [dateFormatter dateFromString:dateString];
			
		}
		else
		{
			[NSException raise:@"MismatchDataType" format:@"Object of class '%@' can't be converted to 'NSDate'", NSStringFromClass([date class])];
		}
	}
	return date;
}

- (NSArray *)arrayForKey:(id)key
{
	NSArray *array = [self objectForKey:key];
	if (array != nil && ![array isKindOfClass:[NSArray class]])
	{
		array = [NSArray arrayWithObject:array];
	}
	return array;
}

- (NSArray *)arrayForKeyPath:(id)keyPath
{
	NSArray *array = [self valueForKeyPath:keyPath];
	if (array != nil && ![array isKindOfClass:[NSArray class]])
	{
		array = [NSArray arrayWithObject:array];
	}
	return array;
}

// Renvoie YES si l'objet traité comme une NSString n'est pas vide.
- (BOOL)containsSomethingForKey:(id)key
{
    return ([[self stringForKey:key] length] > 0);
}

- (BOOL)containsSomethingForKeyPath:(id)keyPath
{
    return ([[self stringForKeyPath:keyPath] length] > 0);
}

@end
