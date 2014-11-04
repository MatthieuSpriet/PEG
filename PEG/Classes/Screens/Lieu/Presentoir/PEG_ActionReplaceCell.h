//
//  PEG_ActionReplaceCell.h
//  PEG
//
//  Created by 10_200_11_120 on 17/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanPresentoir.h"

@interface PEG_ActionReplaceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UISegmentedControl *EmplacementSegControl;
@property (strong, nonatomic) IBOutlet UITextView *LocalisationTextFlied;
@property (strong, nonatomic) IBOutlet UILabel *NomLieuLabel;
@property (strong, nonatomic) IBOutlet UILabel *TypeLieuLabel;


@property (strong, nonatomic) BeanPresentoir * _BeanPresentoir;
@end
