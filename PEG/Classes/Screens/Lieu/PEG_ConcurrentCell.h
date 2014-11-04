//
//  PEG_ConcurrentCell.h
//  PEG
//
//  Created by 10_200_11_120 on 25/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_ConcurrentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ConcurrentUILabel;
@property (strong, nonatomic) IBOutlet UISwitch *SansConcurrentSwitch;

@end
