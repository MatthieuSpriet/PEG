//
//  PEG_DtlLieuxViewController.h
//  Pegase
//
//  Created by HorsMedia1 on 30/05/13.
//  Copyright (c) 2013 HorsMedia1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PEG_PickerViewController.h"
#import "PEG_BeanImage.h"
#import "PEG_ActionMinuteViewController.h"
#import "PEG_ListRelationnelViewController.h"

@interface PEG_DtlLieuxViewController : PEG_BaseUIViewController
<
UITableViewDelegate
,PEGPickerDelegate
,PEG_BeanImageDataSource
,PEGActionMinuteDelegate
,PEGListRelationnelDelegate
,UINavigationControllerDelegate
,UIImagePickerControllerDelegate
,UIGestureRecognizerDelegate,
CLLocationManagerDelegate
>
-(void) setDetailItem:(NSNumber*)p_IdLieu;

@end
