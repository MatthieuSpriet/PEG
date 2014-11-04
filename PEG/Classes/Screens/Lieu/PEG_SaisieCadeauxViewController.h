//
//  PEG_SaisieCadeauxViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 28/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPIROrderedDictionary.h"
#import "PEG_PickerViewController.h"

@interface PEG_SaisieCadeauxViewController : PEG_BaseUIViewController
<
PEGPickerDelegate
>
-(void) setDetailItem:(NSNumber*)p_IdLieu;
@end
