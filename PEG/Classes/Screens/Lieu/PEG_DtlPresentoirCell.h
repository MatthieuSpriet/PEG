//
//  PEG_DtlPresentoirCell.h
//  PEG
//
//  Created by 10_200_11_120 on 18/09/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_DtlPresentoirCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *TypePresentoirUILabel;
@property (strong, nonatomic) IBOutlet UILabel *NomPresentoirUILabel;
@property (strong, nonatomic) IBOutlet UILabel *EmplacementPresentoirUILabel;
@property (strong, nonatomic) IBOutlet UILabel *DatePhotoUILabel;
@property (strong, nonatomic) IBOutlet UIButton *BtnCheckUIButton;

@property (assign, nonatomic) int IdPtLivraison;

@property (weak, nonatomic) IBOutlet UILabel *LabelDatePhotoUILabel;

@end
