//
//  PEG_ViewDtlAdministratifView2Controller.m
//  PEG
//
//  Created by 10_200_11_120 on 21/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ViewDtlAdministratifView2Controller.h"
#import "PEG_FMobilitePegase.h"
//#import "PEG_BeanLieu.h"
#import "PEG_DtlView2Cell.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEG_FTechnical.h"

@interface PEG_ViewDtlAdministratifView2Controller ()

@property (strong, nonatomic) IBOutlet UITableView *MyTableView;
@property (strong, nonatomic) BeanLieu* BeanLieu;
@property (assign, nonatomic) BOOL IsEditable;
@property (assign, nonatomic) BOOL IsKeyBoardOpen;
@property (strong, nonatomic) UITextField* UITextFieldSelected;
@end

@implementation PEG_ViewDtlAdministratifView2Controller


#pragma mark - Init
-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.IsKeyBoardOpen=NO;
    [super viewDidLoad];
    self.IsEditable=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 40;
    }
    if(indexPath.section==1){
        return 236;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"cellTitre";
        PEG_DtlView2Cell *cell = (PEG_DtlView2Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        cell.NomLieuUILabel.text = [NSString stringWithFormat:@"%@ - %@ ",[self.BeanLieu.idLieu stringValue],self.BeanLieu.liNomLieu];
       // cell.NomLieuUILabel.text=[self.BeanLieu.IdLieu stringValue];
        return cell;
        
    }else if (indexPath.section == 1)
    {
        
        
        NSString *CellIdentifier = @"cellFormulaire";
        PEG_DtlView2Cell *cell = (PEG_DtlView2Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        //On met se test pour ne pas rafraichir les valeur alors quelles ne sont pas encore enregistrées
        if(!self.IsEditable)
        {
            cell.TelephoneUITextField.text = self.BeanLieu.respTel;
            cell.TelephoneUITextField.delegate=self;
            cell.CiviliteUITextFiled.text =self.BeanLieu.respCivilite;
            cell.CiviliteUITextFiled.delegate=self;
            cell.NomUITextFiled.text =self.BeanLieu.respNom;
            cell.NomUITextFiled.delegate=self;
            cell.ActiviteUITextFiled.text = [[PEG_FMobilitePegase CreateListeChoix] GetLibelleActiviteByCode:self.BeanLieu.codeActivite];
            //TODO a corriger
            if(cell.ActiviteUITextFiled.text == nil)
            {
                cell.ActiviteUITextFiled.text = @"Actif";
            }
            cell.ActiviteUITextFiled.delegate=self;
            cell.EtatLieuUILabel.text = [[PEG_FMobilitePegase CreateListeChoix] GetLibelleEtatLieuByCode:self.BeanLieu.codeEtatLieu];
            cell.ProchainEtatUITextFiled.text = [[PEG_FMobilitePegase CreateListeChoix] GetLibelleEtatLieuByCode:self.BeanLieu.codeProchainEtatLieu];
            cell.ProchainEtatUITextFiled.delegate=self;
        [cell.ClientMagUISwitch setOn:[self.BeanLieu.vfClientMag boolValue]];
        [cell.ClientExclusifUISwitch setOn:[self.BeanLieu.vfExclusif boolValue]];
        }
        
        [cell.TelephoneUITextField setEnabled:self.IsEditable];
        [cell.CiviliteUITextFiled setEnabled:self.IsEditable];
        [cell.NomUITextFiled setEnabled:self.IsEditable];
        [cell.ActiviteUITextFiled setEnabled:self.IsEditable];
        [cell.ProchainEtatUITextFiled setEnabled:self.IsEditable];
        [cell.ClientMagUISwitch setEnabled:self.IsEditable];
        [cell.ClientExclusifUISwitch setEnabled:self.IsEditable];
        cell.TelephoneUITextField.tag =0;
        cell.CiviliteUITextFiled.tag =1;
        cell.NomUITextFiled.tag =2;
        cell.ActiviteUITextFiled.tag =3;
        cell.ProchainEtatUITextFiled.tag = 4;
    
        
        if(self.IsEditable){
             [cell.TelephoneUITextField setTextColor:[UIColor blueColor]];
             [cell.CiviliteUITextFiled setTextColor:[UIColor blueColor]];
             [cell.NomUITextFiled setTextColor:[UIColor blueColor]];
             [cell.ActiviteUITextFiled setTextColor:[UIColor blueColor]];
             [cell.ProchainEtatUITextFiled setTextColor:[UIColor blueColor]];
        }else{
            [cell.TelephoneUITextField setTextColor:[UIColor blackColor]];
            [cell.CiviliteUITextFiled setTextColor:[UIColor blackColor]];
            [cell.NomUITextFiled setTextColor:[UIColor blackColor]];
            [cell.ActiviteUITextFiled setTextColor:[UIColor blackColor]];
            [cell.ProchainEtatUITextFiled setTextColor:[UIColor blackColor]];
            
        }

        
        return cell;
    }
    return nil;
}

-(void) setTableViewEditable:(BOOL)p_ISEditable
{
    self.IsEditable=p_ISEditable;
    [self.MyTableView reloadData];
}
-(BOOL) isTableViewEditable{
    return self.IsEditable;
}

#pragma mark ScrollEcran
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch(textField.tag)
    {
        case 1:
        {
            [textField resignFirstResponder];
            break;
        }
        case 3:
        {
            [textField resignFirstResponder];
            break;
        }
        case 4:
        {
            [textField resignFirstResponder];
            break;
        }
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.IsKeyBoardOpen=YES;
    // [self.MyTableView reloadData];   pm 11/2014
    
    UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:textField];
    if(textField.tag<=4){
        [self.MyTableView scrollToRowAtIndexPath:[self.MyTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.MyTableView scrollToRowAtIndexPath:[self.MyTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    self.UITextFieldSelected = textField;
    switch(textField.tag)
    {
        case 1:
        {
            [textField resignFirstResponder];
            SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
            NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixCivilite];
            for (BeanChoix* v_RowChoix in  v_listeChoix){
                [values setValue:[NSString stringWithFormat:@"%@",v_RowChoix.libelle ] forKey:v_RowChoix.code];
            }
            /*[values setValue:@"M" forKey:@"M"];
            [values setValue:@"Mme" forKey:@"Mme"];
            [values setValue:@"Mlle" forKey:@"Mlle"];*/
            [self ShowPicker:values];
            break;
        }
        case 3:
        {
            [textField resignFirstResponder];
            SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
            NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixActivite];
            for (BeanChoix* v_RowChoix in  v_listeChoix){
                [values setValue:[NSString stringWithFormat:@"%@ - %@",v_RowChoix.code,v_RowChoix.libelle ] forKey:v_RowChoix.code];
            }
            [self ShowPicker:values];
            break;
        }
        case 4:
        {
            [textField resignFirstResponder];
            SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
            NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixEtatLieu];
            for (BeanChoix* v_RowChoix in  v_listeChoix){
                [values setValue:v_RowChoix.libelle forKey:v_RowChoix.code];
            }
            [self ShowPicker:values];
            break;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    self.IsKeyBoardOpen=NO;
    [self.MyTableView reloadData];
    return YES;
}

-(BOOL)Save {
    BOOL v_IsSave = false;
    self.IsKeyBoardOpen=NO;
    [self.MyTableView reloadData];
    
    PEG_DtlView2Cell* cell = (PEG_DtlView2Cell *) [self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if(cell.ActiviteUITextFiled.text == nil
       || [cell.ActiviteUITextFiled.text isEqualToString:@""]
       || cell.NomUITextFiled.text == nil
       || [cell.NomUITextFiled.text isEqualToString:@""])
    {
        UIAlertView *debugAlertView;
        debugAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Le responsable et l'activité sont obligatoires"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        
        debugAlertView.delegate = self;
        [debugAlertView show];
    }
    else
    {
        self.BeanLieu.RespTel=cell.TelephoneUITextField.text ;
        self.BeanLieu.RespCivilite=cell.CiviliteUITextFiled.text ;
        self.BeanLieu.RespNom=cell.NomUITextFiled.text ;
        self.BeanLieu.CodeActivite=[[PEG_FMobilitePegase CreateListeChoix] GetCodeActiviteByLibelle:cell.ActiviteUITextFiled.text];
        if(cell.ProchainEtatUITextFiled.text != nil && ![cell.ProchainEtatUITextFiled.text isEqualToString:@""])
        {
            self.BeanLieu.codeProchainEtatLieu = [[PEG_FMobilitePegase CreateListeChoix] GetCodeEtatLieuByLibelle:cell.ProchainEtatUITextFiled.text];
            self.BeanLieu.dateProchainEtatLieu = [NSDate date];
            
            self.BeanLieu.codeEtatLieu= [[PEG_FMobilitePegase CreateListeChoix] GetCodeEtatLieuByLibelle:cell.ProchainEtatUITextFiled.text];
        }
        
        self.BeanLieu.VfClientMag=[[NSNumber alloc] initWithBool:cell.ClientMagUISwitch.on];
        self.BeanLieu.VfExclusif=[[NSNumber alloc]initWithBool:cell.ClientExclusifUISwitch.on];
        [self.BeanLieu setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:self.BeanLieu.idLieu];
        
        v_IsSave= true;
    }
    return v_IsSave;
}

- (void)ShowPicker:(SPIROrderedDictionary*)p_List {
    [self hideKeyboard];
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

-(void) formPicker:(PEG_PickerViewController *)_formPicker didChoose:(NSMutableArray *)value
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
        int v_indexSelected=[((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]) intValue];
        
        NSString* v_Categorie=@"";
        if(self.UITextFieldSelected.tag ==1)
        {
            v_Categorie = @"Civilite";
        }
        else if(self.UITextFieldSelected.tag ==3)
        {
            v_Categorie = @"Activite";
        }
        else if(self.UITextFieldSelected.tag ==4)
        {
            v_Categorie = @"EtatLieu";
        }
        NSString* v_Libelle= [[PEG_FMobilitePegase CreateListeChoix] GetBeanChoixByCode:[v_dict keyAtIndex:v_indexSelected] andCategorie:v_Categorie].libelle;
        
        self.UITextFieldSelected.text = v_Libelle;
    }
    [self.MyTableView reloadData];
}


- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
