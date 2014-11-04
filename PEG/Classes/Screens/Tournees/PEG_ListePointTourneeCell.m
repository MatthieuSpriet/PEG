//
//  PEG_ListePointTourneeCell.m
//  PEG
//
//  Created by HorsMedia1 on 27/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListePointTourneeCell.h"
#import "PEG_FMobilitePegase.h"

@interface PEG_ListePointTourneeCell ()
@property (nonatomic,strong) NSNumber* IdPresentoir;    // pm140527 are these 3 properties actualy used ?
@property (nonatomic,strong) NSNumber* IdParution;
@property (nonatomic,strong) NSNumber* IdLieuPassage;

@end

@implementation PEG_ListePointTourneeCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)BtnCopieQtePreviTouchUpInsiade:(id)sender {
    /*self.QuantiteDistribueeUITextField.text = self.QuantitePrepareeUILabel.text;
    if(self.QuantiteDistribueeUITextField.text.length > 0)
    {
        int v_Qte = [self.QuantiteDistribueeUITextField.text intValue];
        if(v_Qte > 0){
            BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageById:self.IdLieuPassage];
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_LP.idLieu andIdPresentoir:self.IdPresentoir andIdParution:self.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
        }
    }*/
    
}

                            
-(void) initDataWithNumPoint:(NSString*) p_numPoint andNomPoint:(NSString*)p_nomPoint andTypePresentoir:(NSString*)p_typePresentoir andCommune:(NSString*)p_Commune andParution:(NSString*)p_Parution andQtePrepa:(NSNumber*)p_QtePrepa andQteDistri:(NSNumber*)p_QteDistri andQteRetour:(NSNumber*)p_QteRetour andNbTache:(NSNumber*)p_NbTache andIdPresentoir:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution andIdLieuPassage:(NSNumber*)p_IdLieuPassage
{
    self.NumeroPointUILabel.text = p_numPoint;
    self.NomPointUILabel.text = p_nomPoint;
    self.TypePresentoirUILabel.text = p_typePresentoir;
    if([p_NbTache intValue] == 0)
    {
        self.NombreTacheUILabel.hidden = true;
    }
    else
    {
        self.NombreTacheUILabel.hidden = false;
    }
    self.NombreTacheUILabel.text = [p_NbTache stringValue];
    self.CommuneUILabel.text = p_Commune;
    self.ParutionUILabel.text = p_Parution;
    self.QuantitePrepareeUILabel.text = [p_QtePrepa stringValue];
    self.QuantiteDistribueeUITextField.text = [p_QteDistri stringValue];
    self.QuantiteRetourUITextField.text = [p_QteRetour stringValue];
    self.IdPresentoir = p_IdPresentoir;
    self.IdParution = p_IdParution;
    self.IdLieuPassage = p_IdLieuPassage;

    /*self.NomTourneeUILabel.text=p_nomTournees;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString* v_dateStr = [formatter stringFromDate:p_dateTournee];
    
    self.DateTourneeUILabel.text= v_dateStr;
    
    self.NbTacheUILabel.text= [p_nbTache stringValue];
    self.NbLieuUILabel.text = [p_nbLieux stringValue];
    self.LibelleMagazineUILabel.text= p_libMagazine;*/
}

#pragma mark Gestion du clavier
//-(void) initClavier
//{
//    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
//    numberToolbar.items = [NSArray arrayWithObjects:
//                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadQuantiteDistribuee)],
//                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadQuantiteDistribuee)],
//                           nil];
//    [numberToolbar sizeToFit];
//    self.QuantiteDistribueeUITextField.inputAccessoryView = numberToolbar;
//    
//    UIToolbar* numberToolbar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    numberToolbar2.barStyle = UIBarStyleBlackTranslucent;
//    numberToolbar2.items = [NSArray arrayWithObjects:
//                            [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadQuantiteRetour)],
//                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
//                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadQuantiteRetour)],
//                            nil];
//    [numberToolbar2 sizeToFit];
//    self.QuantiteRetourUITextField.inputAccessoryView = numberToolbar2;
//}

//- (IBAction)QuantiteDistribueeUITextFieldEditingDidBegin:(UITextField*)sender {
//    self.QuantiteDistribueeUITextFieldOldValue = self.QuantiteDistribueeUITextField.text;
//    [sender performSelector:@selector(selectAll:) withObject:sender afterDelay:0.f];
////     [[[[sender superview] superview] superview] scrollToRowAtIndexPath:[[[[sender superview] superview] superview] indexPathForCell:(UITableViewCell*)[[sender superview] superview]] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//}
//- (IBAction)QuantiteRetourUITextFieldEditingDidBegin:(UITextField*)sender {
//    self.QuantiteRetourUITextFieldOldValue = self.QuantiteRetourUITextField.text;
//    [sender performSelector:@selector(selectAll:) withObject:sender afterDelay:0.f];
//}
//
//-(void)cancelNumberPadQuantiteDistribuee{
//    [self.QuantiteDistribueeUITextField resignFirstResponder];
//    self.QuantiteDistribueeUITextField.text = self.QuantiteDistribueeUITextFieldOldValue;
//}
//
//-(void)doneWithNumberPadQuantiteDistribuee{
//    NSString *numberFromTheKeyboard = self.QuantiteDistribueeUITextField.text;
//    if(numberFromTheKeyboard.length > 0)
//    {
//        int v_Qte = [numberFromTheKeyboard intValue];
//        if(v_Qte > 0){
//        [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieuPassage:self.IdLieuPassage andIdPresentoir:self.IdPresentoir andIdParution:self.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
//        }
//    }
//    [self.QuantiteDistribueeUITextField resignFirstResponder];
//}
//-(void)cancelNumberPadQuantiteRetour{
//    [self.QuantiteRetourUITextField resignFirstResponder];
//    self.QuantiteRetourUITextField.text =self.QuantiteRetourUITextFieldOldValue;
//}
//
//-(void)doneWithNumberPadQuantiteRetour{
//    NSString *numberFromTheKeyboard = self.QuantiteRetourUITextField.text;
//    if(numberFromTheKeyboard.length > 0)
//    {
//        int v_Qte = [numberFromTheKeyboard intValue];
//        if(v_Qte > 0){
//            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourByIdLieuPassage:self.IdLieuPassage andIdPresentoir:self.IdPresentoir andIdParution:self.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
//        }
//    }
//    [self.QuantiteRetourUITextField resignFirstResponder];
//}

@end
