//
//  PEG_ListeLieuCell.h
//  PEG
//
//  Created by 10_200_11_120 on 13/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEG_BeanPointDsgn.h"

@interface PEG_ListeLieuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NomLieuUILabel;
@property (strong, nonatomic) IBOutlet UILabel *DistanceTempsUILabel;
@property (strong, nonatomic) IBOutlet UILabel *NbTacheUILabel;

@property (strong, nonatomic) IBOutlet UILabel *TypePres1UILabel;
@property (strong, nonatomic) IBOutlet UILabel *EditionPres1UILabel;
@property (strong, nonatomic) IBOutlet UILabel *QteDistribueePres1UILabel;
@property (strong, nonatomic) IBOutlet UILabel *QteRetourPres1UILabel;

@property (strong, nonatomic) IBOutlet UILabel *TypePres2UILabel;
@property (strong, nonatomic) IBOutlet UILabel *EditionPres2UILabel;
@property (strong, nonatomic) IBOutlet UILabel *QteDistribueePres2UILabel;
@property (strong, nonatomic) IBOutlet UILabel *QteRetourPres2UILabel;

@property (strong, nonatomic) IBOutlet UILabel *PresentoirSuivantUILabel;

@property (strong, nonatomic) IBOutlet UILabel *AdresseUILabel;
@property (strong, nonatomic) IBOutlet UILabel *ListCodePresentoirUILabel;

-(void) initDataWithPointDsg:(PEG_BeanPointDsgn*) p_PointDsg;
@end
