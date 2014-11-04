//
//  PEG_SaisieCadeauxCell.h
//  PEG
//
//  Created by 10_200_11_120 on 28/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_SaisieCadeauxCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISwitch *LieuExclusifSwitch;
@property (strong, nonatomic) IBOutlet UILabel *NomResponsableLabel;
@property (strong, nonatomic) IBOutlet UILabel *CadeauLabel;
@property (strong, nonatomic) IBOutlet UILabel *NombreCadeauLabel;

@end
