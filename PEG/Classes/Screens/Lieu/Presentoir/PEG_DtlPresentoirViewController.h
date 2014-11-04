//
//  PEG_DtlPresentoirViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_DtlPresentoirViewController : UITabBarController 

@property (retain, nonatomic) IBOutlet UITabBar *TabBar;

@property (nonatomic, strong) IBOutlet UITabBarController* tabBarController;


-(void) setDetailItem:(NSNumber*)p_IdPresentoir;
@end
