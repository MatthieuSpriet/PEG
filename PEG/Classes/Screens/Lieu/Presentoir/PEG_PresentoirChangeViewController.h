//
//  PEG_PresentoirChangeViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 29/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_PickerViewController.h"

@interface PEG_PresentoirChangeViewController : PEG_BaseUIViewController<PEGPickerDelegate>

-(void) setDetailItem:(NSNumber*)p_IdPresentoir;

@end
