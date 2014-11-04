//
//  PEG_GoogleAnalyticsServices.m
//  PEG
//
//  Created by Pierre Marty on 28/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_GoogleAnalyticsServices.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@implementation PEG_GoogleAnalyticsServices


- (void) signInWithUser:(NSString *)p_User
{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // You only need to set User ID on a tracker once. By setting it on the tracker, the ID will be
    // sent with all subsequent hits.
    [tracker set:@"&uid" value:p_User];
    
    // This hit will be sent with the User ID value and be visible in User-ID-enabled views (profiles).
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"            // Event category (required)
                                                          action:@"User Sign In"  // Event action (required)
                                                           label:nil              // Event label
                                                           value:nil] build]];    // Event value
}

- (void)setCustomValue:(NSString*)value forDimension:(NSUInteger)dimension
{
    id tracker = [[GAI sharedInstance] defaultTracker];

    // Set the custom dimension value on the tracker using its index.
    NSString * dimensionName = [GAIFields customDimensionForIndex:dimension];
    // DLog (@"dimensionName: %@", dimensionName);
    [tracker set:dimensionName value:value];
}

- (void) SendException:(NSString *)p_Description
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createExceptionWithDescription:p_Description withFatal:NO] build]];  // isFatal (required). NO indicates non-fatal exception.
     
}

-(void)sendEventWithCategory:(NSString*)p_Category andAction:(NSString*)p_Action
{
    @try {
        
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:p_Category     // Event category (required)
                                                          action:p_Action  // Event action (required)
                                                           label:nil          // Event label
                                                           value:nil] build]];    // Event value
    }
    @catch (NSException *exception) {
        
    }
}

- (void)setCustomValue:(NSString*)value forMetric:(NSUInteger)metricIndex
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *metricName = [GAIFields customMetricForIndex:metricIndex];
    // DLog (@"metricName: %@", metricName);
    [tracker set:metricName value:value];
}

// we should call it when application resigns
- (void)dispatch
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker dispatch];
}

@end
