//
//  PEG_ListeTachesCell.h
//  PEG
//
//  Created by 10_200_11_120 on 24/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_ListeTachesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ToutesTacheUILabel;
@property (strong, nonatomic) IBOutlet UILabel *TachePhotosUILabel;
@property (strong, nonatomic) IBOutlet UILabel *TacheMaterielUILabel;

@property (strong, nonatomic) IBOutlet UILabel *NomEtablissementUILabel;
@property (strong, nonatomic) IBOutlet UILabel *VilleUILabel;

@property (weak, nonatomic) IBOutlet UILabel *MaterielUILabel;
@property (weak, nonatomic) IBOutlet UILabel *PhotoUILabel;
@property (weak, nonatomic) IBOutlet UILabel *PresentoirUILabel;

@end
