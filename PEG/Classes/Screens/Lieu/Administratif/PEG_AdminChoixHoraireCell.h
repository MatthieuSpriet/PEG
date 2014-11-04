//
//  PEG_AdminChoixHoraireCell.h
//  PEG
//
//  Created by 10_200_11_120 on 18/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_AdminChoixHoraireCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *DtDebutLabel;
@property (strong, nonatomic) IBOutlet UILabel *DtFinLabel;
@property (strong, nonatomic) IBOutlet UILabel *DtDebutComplLabel;
@property (strong, nonatomic) IBOutlet UILabel *DtFinComplLabel;
@property (strong, nonatomic) IBOutlet UISwitch *OuvertSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *DemiJourneeSwitch;

@end
