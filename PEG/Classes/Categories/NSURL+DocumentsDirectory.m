//
//  NSURL+DocumentsDirectory.m
//  Components
//
//  Created by Antoine Marcadet on 10/11/11.
//  Copyright (c) 2011 SPIR Communications S.A. All rights reserved.
//

#import "NSURL+DocumentsDirectory.h"

@implementation NSURL (DocumentsDirectory)

+ (NSURL *)applicationDocumentsDirectory
{
	NSFileManager *defaultManager = [NSFileManager defaultManager];
	if ([defaultManager respondsToSelector:@selector(URLsForDirectory:inDomains:)])
	{
		// iOS >= 4.0
		return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
	}
	else
	{
		// iOS < 4.0
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		return [NSURL URLWithString:[paths objectAtIndex:0]];
	}
}

@end
