//
//  PEG_GoogleAnalyticsServices.h
//  PEG
//
//  Created by Pierre Marty on 28/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"

@interface PEG_GoogleAnalyticsServices : NSObject

- (void) signInWithUser:(NSString *)p_User;
-(void)sendEventWithCategory:(NSString*)p_Category andAction:(NSString*)p_Action;
- (void)setCustomValue:(NSString*)value forDimension:(NSUInteger)dimension;
- (void)setCustomValue:(NSString*)value forMetric:(NSUInteger)metricIndex;
- (void) SendException:(NSString *)p_Description;
- (void)dispatch;

@end
