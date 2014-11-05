//
//  PEG_ViewDtlAdministratifView1Controller.m
//  PEG
//
//  Created by 10_200_11_120 on 21/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ViewDtlAdministratifView1Controller.h"
#import "PEG_FMobilitePegase.h"
//#import "PEG_BeanLieu.h"
#import "PEG_DtlView1Cell.h"
#import "PEG_EnumFlagMAJ.h"
#import "SPIROrderedDictionary.h"
#import "BeanCPCommune.h"
#import "PEG_FTechnical.h"

@interface PEG_ViewDtlAdministratifView1Controller ()

@property (strong, nonatomic) IBOutlet UITableView *MyTableView;
@property (strong, nonatomic) BeanLieu* BeanLieu;
@property (assign, nonatomic) BOOL IsEditable;
@property (assign, nonatomic) BOOL IsKeyBoardOpen;


@property (strong, nonatomic) UITextField* UITextFieldSelected;

@end

@implementation PEG_ViewDtlAdministratifView1Controller


#pragma mark - Init
-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
}


- (void)viewDidLoad
{
    self.IsKeyBoardOpen=NO;
    [super viewDidLoad];
    self.IsEditable=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
        return 240;
        // pm 11/2014 il y avait une hauteur de cellule différente en fct du clavier ici
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        NSString *CellIdentifier = @"cellTitre";
        PEG_DtlView1Cell *cell = (PEG_DtlView1Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
        cell.NomLieuUILabel.text = [NSString stringWithFormat:@"%@ - %@ ",[self.BeanLieu.idLieu stringValue],self.BeanLieu.liNomLieu];
        
        return cell;
        
    }
    else if (indexPath.section == 1)
    {
        NSString *CellIdentifier = @"cellFormulaire";
        PEG_DtlView1Cell *cell = (PEG_DtlView1Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        //On met se test pour ne pas rafraichir les valeur alors quelles ne sont pas encore enregistrées
        if (!self.IsEditable)
        {
            cell.NomEtablissementUITextField.text = self.BeanLieu.liNomLieu;
            cell.NomEtablissementUITextField.delegate=self;
            cell.NumVoieUITextFiled.text =[self.BeanLieu.noVoie stringValue];
            cell.NumVoieUITextFiled.delegate=self;
            cell.BisTerUITextField.text = self.BeanLieu.noVoieComplement;
            cell.BisTerUITextField.delegate=self;
            //cell.VoieUITextField.text = self.BeanLieu.typeVoie;
            cell.VoieUITextField.text = [[PEG_FMobilitePegase CreateListeChoix] GetLibelleTypeVoieByCode:self.BeanLieu.typeVoie];
            cell.VoieUITextField.delegate=self;
            //cell.LiaisonUITextField.text = self.BeanLieu.liaisonVoie;
            cell.LiaisonUITextField.text = [[PEG_FMobilitePegase CreateListeChoix] GetLibelleLiaisonByCode:self.BeanLieu.liaisonVoie];
            cell.LiaisonUITextField.delegate=self;
            cell.Adresse1UITextField.text = self.BeanLieu.nomVoie;
            cell.Adresse1UITextField.delegate=self;
            cell.Adresse2UITextField.text = self.BeanLieu.complement;
            cell.Adresse2UITextField.delegate=self;
            cell.CPUITextField.text = self.BeanLieu.codePostal;
            cell.CPUITextField.delegate=self;
            cell.VilleUITextField.text = self.BeanLieu.ville;
            cell.VilleUITextField.delegate=self;
            
            cell.NomEtablissementUITextField.tag=0;
            cell.NumVoieUITextFiled.tag=1;
            cell.BisTerUITextField.tag=2;
            cell.VoieUITextField.tag=3;
            cell.LiaisonUITextField.tag=4;
            cell.Adresse1UITextField.tag=5;
            cell.Adresse2UITextField.tag=6;
            cell.CPUITextField.tag=7;
            cell.VilleUITextField.tag=8;
        }
        
        if (self.IsEditable != cell.NomEtablissementUITextField.enabled)
        {
            [cell.NomEtablissementUITextField setEnabled:self.IsEditable];
            [cell.NumVoieUITextFiled setEnabled:self.IsEditable];
            [cell.BisTerUITextField setEnabled:self.IsEditable];
            [cell.VoieUITextField setEnabled:self.IsEditable];
            [cell.LiaisonUITextField setEnabled:self.IsEditable];
            [cell.Adresse1UITextField setEnabled:self.IsEditable];
            [cell.Adresse2UITextField setEnabled:self.IsEditable];
            
            if ([self.BeanLieu.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Added]){
                [cell.CPUITextField setEnabled:self.IsEditable];
                [cell.VilleUITextField setEnabled:self.IsEditable];
            }else{
                [cell.CPUITextField setEnabled:false];
                [cell.VilleUITextField setEnabled:false];
            }
            
            if(self.IsEditable){
                [cell.NomEtablissementUITextField setTextColor:[UIColor blueColor]];
                [cell.NumVoieUITextFiled setTextColor:[UIColor blueColor]];
                [cell.BisTerUITextField setTextColor:[UIColor blueColor]];
                [cell.VoieUITextField setTextColor:[UIColor blueColor]];
                [cell.LiaisonUITextField setTextColor:[UIColor blueColor]];
                [cell.Adresse1UITextField setTextColor:[UIColor blueColor]];
                [cell.Adresse2UITextField setTextColor:[UIColor blueColor]];
                if ([self.BeanLieu.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Added]){
                    [cell.CPUITextField setTextColor:[UIColor blueColor]];
                    [cell.VilleUITextField setTextColor:[UIColor blueColor]];
                }else{
                    [cell.CPUITextField setTextColor:[UIColor blackColor]];
                    [cell.VilleUITextField setTextColor:[UIColor blackColor]];
                }
            }else{
                [cell.NomEtablissementUITextField setTextColor:[UIColor blackColor]];
                [cell.NumVoieUITextFiled setTextColor:[UIColor blackColor]];
                [cell.BisTerUITextField setTextColor:[UIColor blackColor]];
                [cell.VoieUITextField setTextColor:[UIColor blackColor]];
                [cell.LiaisonUITextField setTextColor:[UIColor blackColor]];
                [cell.Adresse1UITextField setTextColor:[UIColor blackColor]];
                [cell.Adresse2UITextField setTextColor:[UIColor blackColor]];
                [cell.CPUITextField setTextColor:[UIColor blackColor]];
                [cell.VilleUITextField setTextColor:[UIColor blackColor]];
                
            }
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
//http://stackoverflow.com/questions/18368567/uitableviewcell-with-uitextview-height-in-ios-7
// Penser à ajouter ces deux lignes dans viewDidLoad
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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


-(BOOL) Save{
    BOOL v_IsSave = false;
    self.IsKeyBoardOpen=NO;
    [self.MyTableView reloadData];
    
    PEG_DtlView1Cell* cellDtlComplement = (PEG_DtlView1Cell *) [self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    if(cellDtlComplement.NomEtablissementUITextField.text == nil
       || [cellDtlComplement.NomEtablissementUITextField.text isEqualToString:@""]
       || cellDtlComplement.Adresse1UITextField.text == nil
       || [cellDtlComplement.Adresse1UITextField.text isEqualToString:@""]
       || cellDtlComplement.CPUITextField.text == nil
       || [cellDtlComplement.CPUITextField.text isEqualToString:@""]
       || cellDtlComplement.VilleUITextField.text == nil
       || [cellDtlComplement.VilleUITextField.text isEqualToString:@""])
    {
        UIAlertView *debugAlertView;
        debugAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Le Nom Etablissement, l'adresse, le code postal et la commune sont obligatoires"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        
        debugAlertView.delegate = self;
        [debugAlertView show];
    }
    else
    {
        self.BeanLieu.LiNomLieu=cellDtlComplement.NomEtablissementUITextField.text ;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        self.BeanLieu.noVoie = [f numberFromString:cellDtlComplement.NumVoieUITextFiled.text] ;
        self.BeanLieu.noVoieComplement=cellDtlComplement.BisTerUITextField.text;
        //self.BeanLieu.typeVoie=cellDtlComplement.VoieUITextField.text ;
        self.BeanLieu.typeVoie=[[PEG_FMobilitePegase CreateListeChoix] GetCodeTypeVoieByLibelle:cellDtlComplement.VoieUITextField.text];
        //self.BeanLieu.liaisonVoie=cellDtlComplement.LiaisonUITextField.text  ;
        self.BeanLieu.liaisonVoie=[[PEG_FMobilitePegase CreateListeChoix] GetCodeLiaisonByLibelle:cellDtlComplement.LiaisonUITextField.text];
        self.BeanLieu.nomVoie=cellDtlComplement.Adresse1UITextField.text;
        self.BeanLieu.complement=cellDtlComplement.Adresse2UITextField.text;
        self.BeanLieu.codePostal=cellDtlComplement.CPUITextField.text ;
        self.BeanLieu.ville=cellDtlComplement.VilleUITextField.text ;
        [self.BeanLieu setFlagMAJ:PEG_EnumFlagMAJ_Modified];
        [[PEG_FMobilitePegase CreateCoreData] Save];
        
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:self.BeanLieu.idLieu];
        
        v_IsSave= true;
    }
return v_IsSave;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch(textField.tag)
    {
            //        case 2:
            //        {
            //            [textField resignFirstResponder];
            //            break;
            //        }
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
        case 7:
        case 8:
        {
            [textField resignFirstResponder];
            break;
        }
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.IsKeyBoardOpen=YES;
    
    //[self.MyTableView reloadData];      // << pm 11/2014 là on détruit et recrée la cell, donc pas d'édition possible !
    
    UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:textField];
    if(textField.tag<=6){
        [self.MyTableView scrollToRowAtIndexPath:[self.MyTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        [self.MyTableView scrollToRowAtIndexPath:[self.MyTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    self.UITextFieldSelected = textField;
    switch(textField.tag)
    {
            //        case 2:
            //        {
            //            [textField resignFirstResponder];
            //            SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
            //            NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixNoVoieBisTer];
            //            for (BeanChoix* v_RowChoix in  v_listeChoix){
            //                [values setValue:v_RowChoix.libelle forKey:v_RowChoix.code];
            //            }
            //            [self ShowPicker:values];
            //            break;
            //        }
        case 3:
        {
            [textField resignFirstResponder];
            SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
            NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixTypeVoie];
            [values setValue:@"" forKey:@""];
            for (BeanChoix* v_RowChoix in  v_listeChoix){
                [values setValue:v_RowChoix.libelle forKey:v_RowChoix.code];
            }
            [self ShowPicker:values];
            break;
        }
        case 4:
        {
            [textField resignFirstResponder];
            SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
            NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixLiaison];
            [values setValue:@"" forKey:@""];
            for (BeanChoix* v_RowChoix in  v_listeChoix){
                [values setValue:v_RowChoix.libelle forKey:v_RowChoix.code];
            }
            [self ShowPicker:values];
            break;
        }
        case 7:
        case 8:
        {
            [textField resignFirstResponder];
            SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
            NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanCPCommune];
            for (BeanCPCommune* v_RowChoix in  v_listeChoix){
                
                [values setValue:[NSString stringWithFormat:@"%@ - %@ ",v_RowChoix.cP,v_RowChoix.commune] forKey:[NSString stringWithFormat:@"%@%@ ",v_RowChoix.cP,v_RowChoix.commune]];
            }
            [self ShowPickerCommune:values];
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
        if(self.UITextFieldSelected.tag ==7 ||self.UITextFieldSelected.tag ==8 ){
            SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:0];
            NSNumber* v_indexSelected=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]);
            
            NSString* v_CPcommune= (NSString*)[v_dict keyAtIndex:[v_indexSelected intValue]];
            
            //NSString* v_Libelle= (NSString*)[v_dict objectAtIndex:[v_indexSelected intValue]];
            
            //BeanCPCommune* v_BeanCPCommune=[[PEG_FMobilitePegase CreateListeChoix]GetBeanCPCommuneByLibelleCommune:v_commune];
            
            
            //self.UITextFieldSelected.text = v_Libelle;
            PEG_DtlView1Cell* cellDtlComplement = (PEG_DtlView1Cell *) [self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            cellDtlComplement.CPUITextField.text= [v_CPcommune substringToIndex:5];//v_BeanCPCommune.cP;
            cellDtlComplement.VilleUITextField.text=[v_CPcommune substringFromIndex:5];//v_BeanCPCommune.commune ;
        }else{
            SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:0];
            NSNumber* v_indexSelected=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]);
            
            NSString* v_Libelle= (NSString*)[v_dict objectAtIndex:[v_indexSelected intValue]];
            
            self.UITextFieldSelected.text = v_Libelle;
        }
        
    }
    [self.MyTableView reloadData];
}

- (void)ShowPickerCommune:(SPIROrderedDictionary*)p_List {
    [self hideKeyboard];
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    pickerController.title=@"Commune";
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

- (void)hideKeyboard
{
    // pm I was trying to call resignFirstResponder , but the simplest solution is to call endEditing on self.view !
    // cf http://stackoverflow.com/questions/1823317/get-the-current-first-responder-without-using-a-private-api
    [self.view endEditing:YES];
}


@end
