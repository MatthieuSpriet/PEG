//
//  ADXRequestFormatter.m
//  ADX
//
//  Created by Antoine Marcadet on 06/06/12.
//  Copyright (c) 2012 SQLI Agency. All rights reserved.
//

#import "PEGRequestFormatter.h"
#import "GRMustacheTemplate.h"

@implementation PEGRequestFormatter

@synthesize templateNumberFormatterStack;
@synthesize templateDateFormatterStack;

/**
 This method is called right before the template start rendering.
 */
- (void)templateWillRender:(GRMustacheTemplate *)template
{
    /**
     Prepare a stack of NSNumberFormatter objects.
	 
     Each time we'll enter a section that is attached to a NSNumberFormatter,
     we'll enqueue this NSNumberFormatter in the stack. This is done in
     [template:willRenderReturnValueOfInvocation:]
     */
    self.templateNumberFormatterStack = [NSMutableArray array];
	
	self.templateDateFormatterStack = [NSMutableArray array];
}

/**
 This method is called when the template is about to render a tag.
 */
- (void)template:(GRMustacheTemplate *)template willRenderReturnValueOfInvocation:(GRMustacheInvocation *)invocation
{
    /**
     The invocation object tells us which object is about to be rendered.
     */
    if ([invocation.returnValue isKindOfClass:[NSNumberFormatter class]])
    {
        /**
         If it is a NSNumberFormatter, enqueue it in templateNumberFormatterStack.
         */
        [self.templateNumberFormatterStack addObject:invocation.returnValue];
    }
	if ([invocation.returnValue isKindOfClass:[NSDateFormatter class]])
	{
		[self.templateDateFormatterStack addObject:invocation.returnValue];
	}
    else if (self.templateNumberFormatterStack.count > 0 && [invocation.returnValue isKindOfClass:[NSNumber class]])
    {
        /**
         If it is a NSNumber, and if our templateNumberFormatterStack is not
         empty, use the top NSNumberFormatter to format the number.
		 
         Set the invocation's returnValue: this is the object that will be rendered.
         */
        NSNumberFormatter *numberFormatter = self.templateNumberFormatterStack.lastObject;
        NSNumber *number = invocation.returnValue;
        invocation.returnValue = [numberFormatter stringFromNumber:number];
    }
	else if (self.templateDateFormatterStack.count > 0 && [invocation.returnValue isKindOfClass:[NSDate class]])
	{
		NSDateFormatter *dateFormatter = self.templateDateFormatterStack.lastObject;
		NSDate *date = invocation.returnValue;
		invocation.returnValue = [dateFormatter stringFromDate:date];
	}
}

/**
 This method is called right after the template has rendered a tag.
 */
- (void)template:(GRMustacheTemplate *)template didRenderReturnValueOfInvocation:(GRMustacheInvocation *)invocation
{
    /**
     Make sure we dequeue NSNumberFormatters when we leave their scope.
     */
    if ([invocation.returnValue isKindOfClass:[NSNumberFormatter class]])
    {
        [self.templateNumberFormatterStack removeLastObject];
    }
	else if ([invocation.returnValue isKindOfClass:[NSDateFormatter class]])
	{
		[self.templateDateFormatterStack removeLastObject];
	}
}

/**
 This method is called right after the template has finished rendering.
 */
- (void)templateDidRender:(GRMustacheTemplate *)template
{
    /**
     Final cleanup: release the stack created in templateWillRender:
     */
    self.templateNumberFormatterStack = nil;
	self.templateDateFormatterStack = nil;
}

@end
