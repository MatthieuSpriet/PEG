//
//  ADXSession.m
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 29/06/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "PEGSession.h"
#import "PEG_FTechnical.h"

@interface PEGSession ()
{
	NSString	*_matResp;
}
@property (nonatomic, strong) NSString *_matResp;

@end

@implementation PEGSession
@synthesize matResp, _matResp;

// SYNTHESIZE_SINGLETON_FOR_CLASS(PEGSession);	// ARC pm140218 removed SynthesizeSingleton.h
+ (PEGSession*)sharedPEGSession
{
	static PEGSession *instance = nil;
	@synchronized(self) {
		if (! instance) {
			instance = [[PEGSession alloc] init];
		}
		return instance;
	}
}



- (void)logout
{
}

#pragma mark - MatResp Handling bullshit

- (void)replaceMatResp:(NSString *)replacement
{
	if (self._matResp == nil)
	{
		self._matResp = self.matResp;
	}
	self.matResp = [PEG_FTechnical paddingLeftForValue:[replacement intValue] forDigits:8];;
}

- (void)resetMatResp
{
	if (self._matResp != nil)
	{
		self.matResp = self._matResp;
		self._matResp = nil;
	}	
}



- (void)clearSession
{
    [self resetMatResp];
}

@end
