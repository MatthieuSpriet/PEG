//
//  PEG_ListePointTourneeCell.h
//  PEG
//
//  Created by HorsMedia1 on 27/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_ListePointTourneeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NumeroPointUILabel;
@property (strong, nonatomic) IBOutlet UILabel *NomPointUILabel;
@property (strong, nonatomic) IBOutlet UILabel *NombreTacheUILabel;
@property (strong, nonatomic) IBOutlet UILabel *TypePresentoirUILabel;
@property (strong, nonatomic) IBOutlet UILabel *CommuneUILabel;
@property (strong, nonatomic) IBOutlet UILabel *ParutionUILabel;
@property (strong, nonatomic) IBOutlet UILabel *QuantitePrepareeUILabel;
@property (strong, nonatomic) IBOutlet UITextField *QuantiteDistribueeUITextField;
//@property (retain, nonatomic) NSString *QuantiteDistribueeUITextFieldOldValue;
@property (strong, nonatomic) IBOutlet UITextField *QuantiteRetourUITextField;
//@property (retain, nonatomic) NSString *QuantiteRetourUITextFieldOldValue;
@property (strong, nonatomic) IBOutlet UIButton *BtnCopierPreviUIButton;

//-(void) initClavier;
-(void) initDataWithNumPoint:(NSString*) p_numPoint andNomPoint:(NSString*)p_nomPoint andTypePresentoir:(NSString*)p_typePresentoir andCommune:(NSString*)p_Commune andParution:(NSString*)p_Parution andQtePrepa:(NSNumber*)p_QtePrepa andQteDistri:(NSNumber*)p_QteDistri andQteRetour:(NSNumber*)p_QteRetour andNbTache:(NSNumber*)p_NbTache andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution andIdLieuPassage:(NSNumber*)p_IdLieuPassage;

@end
