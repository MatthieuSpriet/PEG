//
//  PEG_DetailQteCell.m
//  PEG
//
//  Created by 10_200_11_120 on 14/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_DetailQteCell.h"
#import "PEG_FMobilitePegase.h"
@interface PEG_DetailQteCell ()

@end

@implementation PEG_DetailQteCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.NomLieuLabel = [[UILabel alloc]init];
        self.TypePresentoirUILabel = [[UILabel alloc]init];
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark Gestion du clavier
- (IBAction)ReassortTouchUp:(id)sender {
    self.QteReassortTextField.text=self.QteReassortPreviTextField.text;
    BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:[[NSNumber alloc] initWithInt:self.IdLieu ]];
    [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_LP.idLieu andIdPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected ] andIdParution:[[NSNumber alloc] initWithInt:self.IdParution ] andQte:[[NSNumber alloc] initWithInt:[self.QteReassortPreviTextField.text integerValue]]];
}

- (IBAction)TachesSagControlChanged:(id)sender {
    
    UISegmentedControl* v_UISegmentedControl= ((UISegmentedControl*) sender);
    //int v_id=v_UISegmentedControl.tag;
    //BeanChoix* v_beanChoix= [[PEG_FMobilitePegase CreateListeChoix] GetBeanChoixByIdChoix: [NSNumber numberWithInt:v_id]];
    BeanPresentoir* v_BeanPresentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected]];
    // pm201402 superview] superview ne rend pas le bon object sur iOS7 ! (-> un UITableViewCellScrollView, pas un PEG_DetailQteCell comme avec iOS6
	// pourquoi ce mécanisme, on peut utiliser self ? (TODO: vérifier ça !)
	//NSString* v_CodeMatos = ((PEG_DetailQteCell*)[[v_UISegmentedControl superview] superview]).CodeMateriel;
    NSString* v_CodeMatos = self.CodeMateriel;
    if(v_UISegmentedControl.selectedSegmentIndex==0){
        [[PEG_FMobilitePegase CreateActionPresentoir] UpdatePresentoirTacheByPresentoir:v_BeanPresentoir andTache:v_CodeMatos andFait:false andAFaire:true];
        //[[PEG_FMobilitePegase CreatePresentoir] AddOrUpdateTacheAFaireOnPresentoir:v_beanChoix andIdPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected ]];
    }
    if(v_UISegmentedControl.selectedSegmentIndex==1){
        [[PEG_FMobilitePegase CreateActionPresentoir] UpdatePresentoirTacheByPresentoir:v_BeanPresentoir andTache:v_CodeMatos andFait:true andAFaire:false];
        //[[PEG_FMobilitePegase CreatePresentoir] AddOrUpdateTacheFaitOnPresentoir:v_beanChoix andIdPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected ]];
    }
    if(v_UISegmentedControl.selectedSegmentIndex==2){
        [[PEG_FMobilitePegase CreateActionPresentoir] UpdatePresentoirTacheByPresentoir:v_BeanPresentoir andTache:v_CodeMatos andFait:false andAFaire:false];
        //[[PEG_FMobilitePegase CreatePresentoir] RemoveTacheOnPresentoir:v_beanChoix andIdPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected ]];
    }
    
}

-(void) initClavier
{
    UIToolbar* numberToolbar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar1.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar1.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadDistance)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneForReassortTextField)],
                           nil];
    [numberToolbar1 sizeToFit];
    self.QteReassortTextField.inputAccessoryView = numberToolbar1;
    
    UIToolbar* numberToolbar2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar2.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar2.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadDistance)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneForRetourTextField)],
                           nil];
    [numberToolbar2 sizeToFit];
    self.RetourTextField.inputAccessoryView = numberToolbar2;
    
    UIToolbar* numberToolbar3 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar3.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar3.items = [NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadDistance)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneForRetourBonEtatTextField)],
                            nil];
    [numberToolbar3 sizeToFit];
    self.RetourBonEtatUITextField.inputAccessoryView = numberToolbar3;
}

-(void)cancelNumberPadDistance{
    [self.QteReassortTextField resignFirstResponder];
    [self.RetourTextField resignFirstResponder];
    [self.RetourBonEtatUITextField resignFirstResponder];
}

-(void)doneForReassortTextField{
    NSString *numberFromTheKeyboard = self.QteReassortTextField.text;
    
    //BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:[[NSNumber alloc] initWithInt:self.IdLieu ]];
    
    [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:[[NSNumber alloc]initWithInt:self.IdLieu] andIdPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected ] andIdParution:[[NSNumber alloc] initWithInt:self.IdParution ] andQte:[[NSNumber alloc] initWithInt:[numberFromTheKeyboard integerValue]]];

    [self.QteReassortTextField resignFirstResponder];
    
}

-(void)doneForRetourTextField{
    NSString *numberFromTheKeyboard = self.RetourTextField.text;
    
    //BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:[[NSNumber alloc] initWithInt:self.IdLieu ]];
    
    [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourParutionPrecByIdLieu:[[NSNumber alloc]initWithInt:self.IdLieu] andIdPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected ] andIdParution:[[NSNumber alloc] initWithInt:self.IdParution ] andQte:[[NSNumber alloc] initWithInt:[numberFromTheKeyboard integerValue]]];

    [self.RetourTextField resignFirstResponder];
    
}

-(void)doneForRetourBonEtatTextField{
    NSString *numberFromTheKeyboard = self.RetourBonEtatUITextField.text;
    
    //BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetOrCreateBeanLieuPassageOnTourneeMerchByIdLieu:[[NSNumber alloc] initWithInt:self.IdLieu ]];
    
    [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourBonEtatByIdLieu:[[NSNumber alloc]initWithInt:self.IdLieu] andIdPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoirSelected ] andIdParution:[[NSNumber alloc] initWithInt:self.IdParution ] andQte:[[NSNumber alloc] initWithInt:[numberFromTheKeyboard integerValue]]];
    
    [self.RetourBonEtatUITextField resignFirstResponder];
    
}
- (IBAction)ReassortBeginEdit:(id)sender {
}

- (IBAction)RetourBeginEdit:(id)sender {
}
@end
