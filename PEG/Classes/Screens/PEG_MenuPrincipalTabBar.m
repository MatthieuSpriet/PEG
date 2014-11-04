//
//  PEG_MenuPrincipalTabBar.m
//  PEG
//
//  Created by 10_200_11_120 on 27/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_MenuPrincipalTabBar.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_LieuServices.h"

@interface PEG_MenuPrincipalTabBar ()

@end

@implementation PEG_MenuPrincipalTabBar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    int nbtache= [[PEG_FMobilitePegase CreateLieu] GetNbTacheForAllLieu];
    if(nbtache > 0){
        UIViewController *requiredViewController = [self.viewControllers objectAtIndex:2];
        UITabBarItem *item = requiredViewController.tabBarItem;
        [item setBadgeValue:[NSString stringWithFormat:@"%d",nbtache ]];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
