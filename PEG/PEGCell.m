//
//  PEGCell.m
//  PEG
//
//  Created by 10_200_11_120 on 23/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGCell.h"

@implementation PEGCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textKmUITextField.text = [[NSString alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
