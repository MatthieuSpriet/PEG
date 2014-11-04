//
//  PEG_ActionMinuteViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 16/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol PEGActionMinuteDelegate;

@interface PEG_ActionMinuteViewController : PEG_BaseUIViewController
<CLLocationManagerDelegate>
@property (nonatomic, weak) id<PEGActionMinuteDelegate> delegate;
@property (strong, nonatomic) NSNumber* _IdPresentoir;
@end


@protocol PEGActionMinuteDelegate <NSObject>

@optional

- (void)formActionMinuteFinished:(PEG_ActionMinuteViewController *)_formActionMinute;

@end
