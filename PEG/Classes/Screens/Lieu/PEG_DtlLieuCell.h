//
//  PEGCellDtlPresentoir.h
//  Pegase
//
//  Created by HorsMedia1 on 30/05/13.
//  Copyright (c) 2013 HorsMedia1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_DtlLieuCell : UITableViewCell

// pm_06 weak IBOutlet à la place de strong pour être cohérent, mais à priori pas de conséquences.
@property (weak, nonatomic) IBOutlet UILabel *titreUILabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgUIImageView;
@property (weak, nonatomic) IBOutlet UILabel *NbTacheUILabel;
@property (weak, nonatomic) IBOutlet UIButton *actionsMinuteUIButton;
@property (weak, nonatomic) IBOutlet UIButton *NewPresentoirUIButton;
@property (weak, nonatomic) IBOutlet UIButton *AuditUIButton;
@property (weak, nonatomic) IBOutlet UIButton *ConcurrenceUIButton;
@property (weak, nonatomic) IBOutlet UIButton *RelationnelUIButton;

@end
