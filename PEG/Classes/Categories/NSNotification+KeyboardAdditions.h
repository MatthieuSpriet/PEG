//
//  NSNotification+KeyboardAdditions.h
//
//  Created by Pierre Marty on 06/03/13.
//  Copyright (c) 2013 Pierre Marty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotification (KeyboardAdditions)

- (CGRect)keyboardFrame;
- (CGRect)keyboardFrameInView:(UIView*)view;
- (NSTimeInterval)keyboardAnimationDuration;
- (NSInteger)keyboardAnimationCurve;

@end
