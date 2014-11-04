//
//  PEG_RelationnelCell.m
//  PEG
//
//  Created by Horsmedia3 on 21/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_RelationnelCell.h"
#import "PEG_FMobilitePegase.h"

@interface PEG_RelationnelCell ()
@property (strong, nonatomic) IBOutlet UISwitch *RelationnelSwitch;
@end

@implementation PEG_RelationnelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)RelationnelChange:(id)sender {
    [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdateLieuRelationnelByIdLieu:[[NSNumber alloc]initWithInt:self.idLieu ] andFait:self.RelationnelSwitch.isOn];
}

- (void)SetValue
{
    [self.RelationnelSwitch setOn:self.IsRelationnel];
}

@end
