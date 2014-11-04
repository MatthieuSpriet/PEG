//
//  PEG_ViewDtlAdministratifView2Controller.h
//  PEG
//
//  Created by 10_200_11_120 on 21/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_PickerViewController.h"

@interface PEG_ViewDtlAdministratifView2Controller : PEG_BaseUIViewController
<UITextFieldDelegate,
PEGPickerDelegate>

-(void) setDetailItem:(NSNumber*)p_IdLieu;

-(void) setTableViewEditable:(BOOL)p_ISEditable;
-(BOOL) isTableViewEditable;

-(BOOL) Save;


@end
