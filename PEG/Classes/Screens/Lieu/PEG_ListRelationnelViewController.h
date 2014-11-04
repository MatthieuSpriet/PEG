//
//  PEG_ListRelationnelViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 24/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanLieu.h"
@protocol PEGListRelationnelDelegate;

@interface PEG_ListRelationnelViewController : PEG_BaseUIViewController
@property (nonatomic, weak) id<PEGListRelationnelDelegate> delegate;
@property (nonatomic,strong) BeanLieu* BeanLieu;

@end

@protocol PEGListRelationnelDelegate <NSObject>
@optional

- (void)formListRelationnelFinished:(PEG_ListRelationnelViewController *)_formListRelationnel;

@end
