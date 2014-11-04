//
//  PEG_DtlAdminViewCell.m
//  PEG
//
//  Created by 10_200_11_120 on 18/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_DtlAdminViewCell.h"

@interface PEG_DtlAdminViewCell ()

@end
@implementation PEG_DtlAdminViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(self.LieuUILabel == nil) self.LieuUILabel = [[UILabel alloc] init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
