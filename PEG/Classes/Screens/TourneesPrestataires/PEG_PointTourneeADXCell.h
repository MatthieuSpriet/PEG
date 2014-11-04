//
//  PEG_PointTourneeADXCell.h
//  PEG
//
//  Created by Pierre Marty on 27/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PEG_BeanPointDsgn;

@interface PEG_PointTourneeADXCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextField *quantiteDistribueeTextField;
@property (strong, nonatomic) IBOutlet UITextField *quantiteRetourTextField;
@property (strong, nonatomic) IBOutlet UIButton *copierPreviButton;

- (void)initWithPointDsgn:(PEG_BeanPointDsgn*)v_BeanPointDsgn;



@end
