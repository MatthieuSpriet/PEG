//
//  PEG_PointTourneeADXViewController.h
//  PEG
//
//  Created by Pierre Marty on 27/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

// L'écran avec les actions possible pour un point de la tournée ADX (IP09)


#import <UIKit/UIKit.h>

@class PEG_BeanPointDsgn;

@interface PEG_PointTourneeADXViewController : PEG_BaseUIViewController

//-(void) setDetailItem:(NSNumber*)p_IdLieu;
-(void)setDetailItem:(PEG_BeanPointDsgn*)p_BeanPointDsg;

@end
