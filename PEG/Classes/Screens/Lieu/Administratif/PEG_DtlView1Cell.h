//
//  PEG_DtlView1Cell.h
//  PEG
//
//  Created by 10_200_11_120 on 21/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_DtlView1Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *NomLieuUILabel;


@property (strong, nonatomic) IBOutlet UITextField *NomEtablissementUITextField;
@property (strong, nonatomic) IBOutlet UITextField *NumVoieUITextFiled;
@property (strong, nonatomic) IBOutlet UITextField *BisTerUITextField;
@property (strong, nonatomic) IBOutlet UITextField *VoieUITextField;
@property (strong, nonatomic) IBOutlet UITextField *LiaisonUITextField;
@property (strong, nonatomic) IBOutlet UITextField *Adresse1UITextField;
@property (strong, nonatomic) IBOutlet UITextField *Adresse2UITextField;
@property (strong, nonatomic) IBOutlet UITextField *CPUITextField;
@property (strong, nonatomic) IBOutlet UITextField *VilleUITextField;

@end
