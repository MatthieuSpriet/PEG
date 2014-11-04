//
//  PEG_ConcurrentCell.m
//  PEG
//
//  Created by 10_200_11_120 on 25/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ConcurrentCell.h"

@implementation PEG_ConcurrentCell

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

@end
