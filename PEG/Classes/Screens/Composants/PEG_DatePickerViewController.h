//
//  PEG_DatePickerViewController.h
//  PEG
//
//  Created by HorsMedia1 on 20/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PEGDatePickerDelegate;

@interface PEG_DatePickerViewController : PEG_BaseUIViewController
@property (nonatomic, weak) id<PEGDatePickerDelegate> delegate;
@property (nonatomic, strong) NSDate						*date;

@end

@protocol PEGDatePickerDelegate <NSObject>

@optional

- (void)formDatePicker:(PEG_DatePickerViewController *)_formDatePicker didChooseDate:(NSDate *)date;

@end

