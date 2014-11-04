//
//  PEG_RelationnelCell.h
//  PEG
//
//  Created by Horsmedia3 on 21/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_RelationnelCell : UITableViewCell

@property (nonatomic, assign) int idLieu;

@property (assign, nonatomic) BOOL IsRelationnel;

- (void)SetValue;

@end
