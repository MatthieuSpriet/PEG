//
//  PEG_TestUnitaireViewController.h
//  PEG
//
//  Created by HorsMedia1 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_MobilitePegaseService.h"
#import "PEG_PickerViewController.h"
#import "PEG_ListeViewController.h"

@interface PEG_TestUnitaireViewController : UIViewController
<
UITableViewDelegate,
PEG_MobilitePegaseServiceDataSource,
PEGPickerDelegate,
PEGListeDelegate
>

#pragma mark interface PEG_BeanMobilitePegaseDataSource
-(void) fillFinishedBeanMobilitePegase;

@end
