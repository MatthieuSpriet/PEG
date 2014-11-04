//
//  PEG_ActionMinuteCell.h
//  PEG
//
//  Created by 10_200_11_120 on 29/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_ActionMinuteCell : UITableViewCell
@property (assign, nonatomic) BOOL IsReplace;
@property (assign, nonatomic) BOOL IsNettoye;
@property (assign, nonatomic) BOOL IsControlVisuel;

@property (assign, nonatomic) int IdPresentoir;

- (void)SetValue;
@end
