//
//  PEG_DtlView2Cell.h
//  PEG
//
//  Created by 10_200_11_120 on 21/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_DtlView2Cell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *NomLieuUILabel;

@property (strong, nonatomic) IBOutlet UITextField *TelephoneUITextField;
@property (strong, nonatomic) IBOutlet UITextField *CiviliteUITextFiled;
@property (strong, nonatomic) IBOutlet UITextField *NomUITextFiled;
@property (strong, nonatomic) IBOutlet UITextField *ActiviteUITextFiled;
@property (strong, nonatomic) NSString* CodeActivite;
@property (strong, nonatomic) IBOutlet UILabel *EtatLieuUILabel;
@property (strong, nonatomic) IBOutlet UITextField *ProchainEtatUITextFiled;
@property (strong, nonatomic) IBOutlet UISwitch *ClientMagUISwitch;
@property (strong, nonatomic) IBOutlet UISwitch *ClientExclusifUISwitch;

@end
