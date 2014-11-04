//
//  UIView+Responder.m
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 22/08/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "UIView+Responder.h"

@implementation UIView (Responder)

- (UIView *)findAndResignFirstResponder
{
	if (self.isFirstResponder) 
	{
		[self resignFirstResponder];
		return self;     
	}
	for (UIView *subView in self.subviews) 
	{
		if ([subView isKindOfClass:[UITextField class]]) 
		{
			DLog(@"subView %@", subView);
		}
		if ([subView findAndResignFirstResponder])
		{
			return subView;	
		}
	}
	return nil;
}

@end
