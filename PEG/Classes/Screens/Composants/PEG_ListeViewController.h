//
//  PEG_ListeViewController.h
//  PEG
//
//  Created by HorsMedia1 on 21/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPIROrderedDictionary.h"
@protocol PEGListeDelegate;

@interface PEG_ListeViewController : PEG_BaseUIViewController
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, weak) id<PEGListeDelegate> delegate;
@property (nonatomic,strong) SPIROrderedDictionary *listValues;
@property (nonatomic,strong) NSString*              valueSelected;
@property (nonatomic,strong) NSIndexPath*           indexSelectedRow;

@end

@protocol PEGListeDelegate <NSObject>

@optional

- (void)formListePicker:(PEG_ListeViewController *)_formListePicker didChoose:(NSString *)value;

@end

