//
//  PEG_SynchroViewController.h
//  PEG
//
//  Created by HorsMedia1 on 17/06/13.
//  Copyright (c) 2013 spir. All rights reserved.

#import <UIKit/UIKit.h>
#import "PEG_MobilitePegaseService.h"
#import "PEG_BeanImage.h"
#import "PEG_BaseUIViewController.h"

@interface PEG_SynchroViewController : PEG_BaseUIViewController
<
PEG_MobilitePegaseServiceDataSource,
UIAlertViewDelegate,
PEG_BeanImageDataSource
>
@end
