//
//  SPIRMessage.m
//  Components
//
//  Created by Antoine Marcadet on 04/10/11.
//  Copyright 2011 SPIR Communications S.A. All rights reserved.
//

#import "SPIRMessage.h"

NSString* const SPIRMessageKey = @"SPIRMessageKey";

@implementation SPIRMessage

@synthesize type, text, level;

#pragma mark - Memory management


- (id)init
{
	if ((self = [super init]))
	{
		self.level = SPIRMessageLevelNone;
	}
	return self;
}

- (id)initWithText:(NSString *)_text andLevel:(SPIRMessageLevel)_level
{
	if ((self = [super init]))
	{
		self.text = _text;
		self.level = _level;
	}
	return self;
}

+ (id)messageWithText:(NSString *)_text andLevel:(SPIRMessageLevel)_level
{
	return [[[self class] alloc] initWithText:_text andLevel:_level];
}

// Copie dans une nouvelle instance les données
- (id)copyWithZone:(NSZone *)zone
{
	SPIRMessage *newObject = [[SPIRMessage allocWithZone:zone] init];
	
	[newObject setText:text];
	[newObject setLevel:level];
	
    return newObject;
}


#pragma mark - Utils

- (NSString *)description
{
	return [NSString stringWithFormat:@"<%@ %p> { text: %@, level: %d }", NSStringFromClass([self class]), self, text, level];
}


#pragma mark - Backward compatibility

- (void)setType:(NSString *)newType
{
	if ([newType isEqualToString:@"E"])
	{
		level = SPIRMessageLevelError;
	}
	else if ([newType isEqualToString:@"W"])
	{
		level = SPIRMessageLevelWarning;
	}
	else if ([newType isEqualToString:@"I"])
	{
		level = SPIRMessageLevelInfo;
	}
	else if ([newType isEqualToString:@"S"])
	{
		level = SPIRMessageLevelSuccess;
	}
	else
	{
		level = SPIRMessageLevelNone;
	}
}

- (NSString *)type
{
	switch (level)
	{
		case SPIRMessageLevelNone:
			return @"";
		case SPIRMessageLevelError:
			return @"E";
		case SPIRMessageLevelWarning:
			return @"W";
		case SPIRMessageLevelInfo:
			return @"I";
		case SPIRMessageLevelSuccess:
			return @"S";
	}
	return @"";
}

- (void)setMessage:(NSString *)newMessage
{
	self.text = newMessage;
}

- (NSString *)message
{
	return self.text;
}

- (NSString *)title
{
	switch (self.level)
	{
		case SPIRMessageLevelError:
			return @"Erreur";
			
		case SPIRMessageLevelWarning:
			return @"Avertissement";
			
		case SPIRMessageLevelInfo:
			return @"Information";
			
		case SPIRMessageLevelSuccess:
			return @"Confirmation";
			
		case SPIRMessageLevelNone:
			return nil;
	}
}

@end
