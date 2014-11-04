//
//  PEG_ActionReplaceViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 17/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_PickerViewController.h"

@interface PEG_ActionReplaceViewController : PEG_BaseUIViewController<UITextViewDelegate,PEGPickerDelegate>

-(void) setDetailItem:(NSNumber*)p_IdPresentoir;
-(void) setDetailItemForCreation:(NSNumber*)p_IdPresentoir IsFromVole:(BOOL)p_FromVole;
@end
