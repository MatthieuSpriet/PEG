//
//  PEG_MenuPrincipalViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 18/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PEG_MenuPrincipalViewController : NSObject
<UIApplicationDelegate,
CLLocationManagerDelegate>
{
    UITabBarController *tabBarController;
}

@end
