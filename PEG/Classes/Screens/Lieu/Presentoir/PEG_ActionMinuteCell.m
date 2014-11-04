//
//  PEG_ActionMinuteCell.m
//  PEG
//
//  Created by 10_200_11_120 on 29/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ActionMinuteCell.h"
#import "BeanPresentoir.h"
#import "PEG_FMobilitePegase.h"

@interface PEG_ActionMinuteCell ()
@property (strong, nonatomic) IBOutlet UISwitch *ReplaceSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *NettoyeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *ControlVisuelSwitch;
@end

@implementation PEG_ActionMinuteCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)SetValue
{
        [self.ControlVisuelSwitch setOn:self.IsControlVisuel];
        [self.NettoyeSwitch setOn:self.IsNettoye];
        [self.ReplaceSwitch setOn:self.IsReplace];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
