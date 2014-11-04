//
//  PEG_ListePointTourneeViewController.h
//  PEG
//
//  Created by HorsMedia1 on 27/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PEG_ListePointTourneeViewController : PEG_BaseUIViewController
<
UITableViewDelegate,
UITextFieldDelegate,
CLLocationManagerDelegate       // pm140526 it seems that CLLocationManagerDelegate is not implemented by PEG_ListePointTourneeViewController ?
>

@property (strong, nonatomic) NSNumber* IdTournee;

-(void) setDetailItem:(NSNumber*)p_IdTournee;

@end
