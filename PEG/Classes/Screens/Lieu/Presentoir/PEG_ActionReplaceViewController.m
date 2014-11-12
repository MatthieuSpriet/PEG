//
//  PEG_ActionReplaceViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 17/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ActionReplaceViewController.h"
#import "PEG_ActionReplaceCell.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_ActionReplaceViewController.h"
#import "BeanPresentoir.h"
#import "SPIROrderedDictionary.h"
#import "BeanEdition.h"


@interface PEG_ActionReplaceViewController ()
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;
@property (strong, nonatomic) BeanPresentoir* _BeanPresentoir;
@property (assign, nonatomic) BOOL IsKeyBoardOpen;
@property (assign, nonatomic) BOOL IsEmplacementModify;
@property (assign, nonatomic) BOOL IsCreationPresentoir;
@property (assign, nonatomic) BOOL IsFromVole;
@end

@implementation PEG_ActionReplaceViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.IsKeyBoardOpen=NO;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(BackClicked)];
    self.IsEmplacementModify=NO;
    self.navigationItem.leftBarButtonItem = backButton;
    
    //UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(AjouterJournalClicked)];
    //self.navigationItem.rightBarButtonItem = bookmarkButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    
    return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    if(indexPath.section==0){
        
        cellIdentifier=@"CellPresentoirEntete";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_ActionReplaceCell* cellDtl = (PEG_ActionReplaceCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEGActionRepaceCell" bundle:nil];
            cellDtl = (PEG_ActionReplaceCell*) c.view;
        }
        cellDtl.NomLieuLabel.text=[[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:self._BeanPresentoir.idLieu].liNomLieu;
        
        cellDtl.TypeLieuLabel.text=[NSString stringWithFormat:@"%@ - %@ - %@",self._BeanPresentoir.tYPE,self._BeanPresentoir.emplacement,self._BeanPresentoir.localisation];
        
        cellDtl._BeanPresentoir = self._BeanPresentoir;
        
        return cellDtl;
    }
    
    if(indexPath.section==1){
        
        cellIdentifier=@"CellPresentoirCorps";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_ActionReplaceCell* cellDtl = (PEG_ActionReplaceCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEGActionRepaceCell" bundle:nil];
            cellDtl = (PEG_ActionReplaceCell*) c.view;
            
        }
        if([self._BeanPresentoir.emplacement isEqualToString:@"INT"]){
            [cellDtl.EmplacementSegControl setSelectedSegmentIndex:0];
        }
        if([self._BeanPresentoir.emplacement isEqualToString:@"EXT"]){
            [cellDtl.EmplacementSegControl setSelectedSegmentIndex:1];
        }
        if([self._BeanPresentoir.emplacement isEqualToString:@"VP"]){
            [cellDtl.EmplacementSegControl setSelectedSegmentIndex:2];
        }
        cellDtl.EmplacementSegControl.tag=[self._BeanPresentoir.idPointDistribution integerValue];
        
        cellDtl.LocalisationTextFlied.text=self._BeanPresentoir.localisation;
        cellDtl.LocalisationTextFlied.delegate=self;
        cellDtl._BeanPresentoir = self._BeanPresentoir;
        return cellDtl;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 70;
    }
    if(indexPath.section==1){
        /*if(! self.IsKeyBoardOpen){
            return 240;
        }else{
            return 500;
        }*/
        return 500;
    }
    return 0;
}



-(void) setDetailItem:(NSNumber*)p_IdPresentoir{
    
    // on initialise la liste des choix
    self._BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
    self.IsCreationPresentoir = false;
    self.IsFromVole=false;
    if(self._BeanPresentoir.emplacement ==nil || [self._BeanPresentoir.emplacement isEqualToString:@""]){
        [[PEG_FMobilitePegase CreatePresentoir] UpdatePresentoirEmplacementByPresentoir:self._BeanPresentoir andEmplacement:@"INT"];
    }
}

-(void) setDetailItemForCreation:(NSNumber*)p_IdPresentoir IsFromVole:(BOOL)p_FromVole{
    [self setDetailItem:p_IdPresentoir];
    self.IsCreationPresentoir = true;
    self.IsFromVole=p_FromVole;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.IsKeyBoardOpen=YES;
    //[self.MyTableView reloadData];
    //UITableViewCell *cell = (UITableViewCell*) [[textView superview] superview];
//    [self.MyTableView scrollToRowAtIndexPath:[self.MyTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self scrollToCursorForTextView:textView];
    
    return YES;
}


#pragma mark ScrollEcran
//http://stackoverflow.com/questions/18368567/uitableviewcell-with-uitextview-height-in-ios-7
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self scrollToCursorForTextView:textView];
}

- (void)scrollToCursorForTextView: (UITextView*)textView {
    
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    cursorRect = [self.self.MyTableView convertRect:cursorRect fromView:textView];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.self.MyTableView scrollRectToVisible:cursorRect animated:YES];
    }
}
- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.MyTableView.contentOffset;
    visibleRect.origin.y += self.MyTableView.contentInset.top;
    visibleRect.size = self.MyTableView.bounds.size;
    visibleRect.size.height -= self.MyTableView.contentInset.top + self.MyTableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.MyTableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.MyTableView.contentInset = contentInsets;
    self.MyTableView.scrollIndicatorInsets = contentInsets;
}
- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.MyTableView.contentInset.top, 0.0, 0.0, 0.0);
    self.MyTableView.contentInset = contentInsets;
    self.MyTableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}
#pragma mark Fin ScrollEcran

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [[PEG_FMobilitePegase CreatePresentoir] UpdatePresentoirLocalisationByPresentoir:self._BeanPresentoir andLocalisation:textView.text];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        self.IsKeyBoardOpen=NO;
        [self.MyTableView reloadData];
        
        return NO;
    }
    
    return YES;
}

- (IBAction)EmplacementChanged:(id)sender {
    
    UISegmentedControl* v_segcontrol=(UISegmentedControl*)sender;
    NSString* v_value=nil;
    
    if(v_segcontrol.selectedSegmentIndex ==0){
        v_value=@"INT";
    }
    if(v_segcontrol.selectedSegmentIndex ==1){
        v_value=@"EXT";
    }
    if(v_segcontrol.selectedSegmentIndex ==2){
        v_value=@"VP";
    }
    
    [[PEG_FMobilitePegase CreatePresentoir] UpdatePresentoirEmplacementByPresentoir:self._BeanPresentoir andEmplacement:v_value];
    
    [self.MyTableView reloadData];
    self.IsEmplacementModify=YES;
    
}

- (void)BackClicked
{
    PEG_ActionReplaceCell* cell = (PEG_ActionReplaceCell *) [self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //if(self.IsEmplacementModify||(![cell.LocalisationTextFlied.text isEqualToString:self._BeanPresentoir.localisation])){
        [[PEG_FMobilitePegase CreatePresentoir] UpdatePresentoirLocalisationByPresentoir:self._BeanPresentoir andLocalisation:cell.LocalisationTextFlied.text];
        
        if(!self.IsCreationPresentoir)
        {
            [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirDeplaceByIdPresentoir:self._BeanPresentoir.id andFait:YES];
        }
        else{
            NSString* v_emplacement=nil;
            if(cell.EmplacementSegControl.selectedSegmentIndex ==0){
                v_emplacement=@"INT";
            }
            if(cell.EmplacementSegControl.selectedSegmentIndex ==1){
                v_emplacement=@"EXT";
            }
            if(cell.EmplacementSegControl.selectedSegmentIndex ==2){
                v_emplacement=@"VP";
            }
            
            [[PEG_FMobilitePegase CreateActionPresentoir] UpdatePresentoirCreationByIdPresentoir:self._BeanPresentoir.id andEmplacement:v_emplacement andLocalisation:cell.LocalisationTextFlied.text];
        }
    //}
    
    if( self.IsFromVole)
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:4] animated:YES];
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)AjouterJournalClicked{
    NSArray* v_list=[[PEG_FMobilitePegase CreateParution]GetListBeanParutionCouranteByCP:self._BeanPresentoir.parentLieu.codePostal];
    SPIROrderedDictionary* v_SPIROrderedDictionary =[[SPIROrderedDictionary alloc]init];
    for (BeanParution* v_BeanParution in v_list) {
        [v_SPIROrderedDictionary setObject:v_BeanParution.libelleEdition forKey:[v_BeanParution.idEdition stringValue]];
    }
    [self ShowPicker:v_SPIROrderedDictionary];
    
}

- (void)ShowPicker:(SPIROrderedDictionary*)p_List {
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    
    NSArray* v_array = [[NSArray alloc] initWithObjects:p_List, nil];
    NSArray* v_arrayValueSelected = [[NSArray alloc]initWithObjects:[p_List keyAtIndex:0],nil];
    
    [pickerController initWithListValue:v_array andListValueSelected:v_arrayValueSelected andNbColonnesToSee:1];
    pickerController.listLargueurColonne = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt: 250], nil];
    
    [pickerController setDelegate:self];
    
    [self addChildViewController:pickerController];
    
    CGRect frame = pickerController.view.frame;
    
    frame.origin = CGPointMake(.0, self.view.frame.size.height);
    
    pickerController.view.frame = frame;
    
    [self.view addSubview:pickerController.view];
    
    [pickerController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         pickerController.view.frame = CGRectMake(.0, .0, pickerController.view.frame.size.width, self.view.frame.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         
                         //                             [pickerController.view removeFromSuperview];
                         //
                         //                             [pickerController willMoveToParentViewController:self];
                         //
                         //                             [pickerController removeFromParentViewController];
                         
                         
                     }
     
     ];
    
    
}

- (void)formPicker:(PEG_PickerViewController *)_formPicker didChoose:(NSMutableArray *)value
{
    PEG_PickerViewController *pickerController = [self.childViewControllers objectAtIndex:0];
    [UIView animateWithDuration:.3
                          delay:.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         pickerController.view.frame = CGRectMake(.0, self.view.frame.size.height, pickerController.view.frame.size.width, pickerController.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [pickerController.view removeFromSuperview];
                         [pickerController willMoveToParentViewController:self];
                         [pickerController removeFromParentViewController];
                     }];
    
    self.IsKeyBoardOpen=NO;
    if(value.count>0){
        
        SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:0];
        NSNumber* v_indexSelected=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]);
        
        NSNumber* v_IdJournal= (NSNumber*)[v_dict keyAtIndex:[v_indexSelected intValue]];
        [[PEG_FMobilitePegase CreatePresentoir] AjouterJournalToPresentoir:v_IdJournal andIdPresentoir:self._BeanPresentoir.idPointDistribution andLieu:self._BeanPresentoir.idLieu];
      //  self.UITextFieldSelected.text = v_Libelle;
    }
    [self.MyTableView reloadData];
}



@end
