//
//  PEG_DtlAdresseCell.h
//  PEG
//
//  Created by 10_200_11_120 on 10/09/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_DtlAdresseCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *AdresseUILabel;
@property (strong, nonatomic) IBOutlet UIButton *CoordUIButton;
@property (assign, nonatomic) int IdLieu;
@property (weak, nonatomic) UITableView *DtlLieuUITableView;      // pm_06 deadlock (was strong)
@property (strong, nonatomic) IBOutlet UILabel *DistanceUILabel;

@end
