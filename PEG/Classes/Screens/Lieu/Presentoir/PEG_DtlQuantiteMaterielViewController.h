//
//  PEG_DtlQuantiteMaterielViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 14/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_PickerViewController.h"

@interface PEG_DtlQuantiteMaterielViewController : PEG_BaseUIViewController
<PEGPickerDelegate,
UITextFieldDelegate>

-(void) setDetailItem:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber *)p_IdParution;
@end
