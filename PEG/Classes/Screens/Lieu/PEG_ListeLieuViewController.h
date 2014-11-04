//
//  PEG_ListeLieuViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 13/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PEG_ListeLieuViewController : PEG_BaseUIViewController
<
UITableViewDelegate,
CLLocationManagerDelegate
>
{

}
-(void)setContextPointParCriteredeRecherche;
-(void)setContextPointAlerte;
-(void)setContextProspection;
@end
