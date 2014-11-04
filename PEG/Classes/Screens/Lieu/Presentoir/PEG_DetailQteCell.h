//
//  PEG_DetailQteCell.h
//  PEG
//
//  Created by 10_200_11_120 on 14/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_DetailQteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NomLieuLabel;
@property (strong, nonatomic) IBOutlet UILabel *TypePresentoirUILabel;
@property (strong, nonatomic) IBOutlet UIButton *AddEditionButton;
@property (strong, nonatomic) IBOutlet UIButton *CopieQteReassortUIButton;
@property (strong, nonatomic) IBOutlet UILabel *LibellePresentoiUILabel;
@property (strong, nonatomic) IBOutlet UILabel *QteReassortPreviTextField;
@property (strong, nonatomic) IBOutlet UITextField *QteReassortTextField;
@property (strong, nonatomic) IBOutlet UITextField *RetourTextField;
@property (strong, nonatomic) IBOutlet UITextField *RetourBonEtatUITextField;
@property (strong, nonatomic) IBOutlet UILabel *ActionUiLabel;
@property (strong, nonatomic) IBOutlet UILabel *HistoriqueLabel;
@property (strong, nonatomic) IBOutlet UILabel *QteACeJourLabel;
@property (strong, nonatomic) IBOutlet UIButton *QteACeJourUIButton;
@property (strong, nonatomic) IBOutlet UIButton *HistoriqueUIButton;
@property (assign, nonatomic) int IdPresentoirSelected;
@property (assign, nonatomic) int IdLieu;
@property (assign, nonatomic) int IdParution;
@property (weak, nonatomic) NSString* CodeMateriel;
- (IBAction)ReassortBeginEdit:(id)sender;
- (IBAction)RetourBeginEdit:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *TachesSegControl;
- (IBAction)ReassortTouchUp:(id)sender;
- (IBAction)TachesSagControlChanged:(id)sender;

-(void) initClavier;
@end
