//
//  PEG_ImageViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 29/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_BeanImage.h"

@interface PEG_ImageViewController : PEG_BaseUIViewController <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *Imageview;
-(void)SetDetailItem:(PEG_BeanImage*)p_image ;
@end
