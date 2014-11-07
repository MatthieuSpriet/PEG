//
//  NSNotification+KeyboardAdditions.m
//
//  Created by Pierre Marty on 06/03/13.
//  Copyright (c) 2013 Pierre Marty. All rights reserved.
//

#import "NSNotification+KeyboardAdditions.h"

@implementation NSNotification (KeyboardAdditions)


- (CGRect)keyboardFrame
{
	NSValue * value = [self.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect frame = [value CGRectValue];		// cf UIGeometry.h
	return frame;
}


- (CGRect)keyboardFrameInView:(UIView*)view
{
	CGRect keyboardFrame = [self keyboardFrame];
	keyboardFrame = [view convertRect:keyboardFrame fromView:nil];
	return keyboardFrame;
}


- (NSTimeInterval)keyboardAnimationDuration
{
	NSValue * animationDurationValue = [self.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSTimeInterval animationDuration;
	[animationDurationValue getValue:&animationDuration];
	return animationDuration;
}


- (NSInteger)keyboardAnimationCurve
{
	NSValue * value = [self.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	NSInteger animationCurve;
	[value getValue:&animationCurve];
	return animationCurve;
}


@end
