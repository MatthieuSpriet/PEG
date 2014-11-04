//
//  PEG_PointTourneeADXActionCell.h
//  PEG
//
//  Created by Pierre Marty on 28/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BeanPresentoir;

@interface PEG_PointTourneeADXActionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *actionUILabel;
@property (strong, nonatomic) NSString* CodeMateriel;
@property (assign, nonatomic) int IdLieuPassage;
@property (assign, nonatomic) int IdLieu;
@property (assign, nonatomic) int IdPresentoir;
@property (assign, nonatomic) bool IsActionPresentoir;
@property (weak, nonatomic) IBOutlet UISegmentedControl *TachesSegControl;

- (void)setDetailItem:(BeanPresentoir*) presentoir;

@end
