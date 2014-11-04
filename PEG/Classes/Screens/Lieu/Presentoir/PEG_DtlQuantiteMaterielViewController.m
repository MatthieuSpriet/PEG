//
//  PEG_DtlQuantiteMaterielViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 14/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_DtlQuantiteMaterielViewController.h"
#import "PEG_DetailQteCell.h"
#import "PEG_FMobilitePegase.h"
//#import "PEG_BeanPresentoir.h"
#import "PEG_QuantiteACeJourViewController.h"
#import "BeanEdition.h"
#import "PEG_FTechnical.h"

@interface PEG_DtlQuantiteMaterielViewController ()

@property (strong, nonatomic) IBOutlet UITableView *MyTableViewUITableView;
@property (strong, nonatomic) NSArray* _ListeChoix;
@property (strong, nonatomic) BeanPresentoir* _BeanPresentoir;
@property (strong, nonatomic) BeanParution* _BeanParution;
@end

@implementation PEG_DtlQuantiteMaterielViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       

         }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(AjouterJournalClicked)];
//    self.navigationItem.rightBarButtonItem = bookmarkButton;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return self._ListeChoix.count;
    }
    if (section == 2)
    {
        return 1; //Pour le scroll
    }

    return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    if(indexPath.section==0){
        
        cellIdentifier=@"cellTitrePresentoir";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_DetailQteCell* cellDtl = (PEG_DetailQteCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_DetailQteCell" bundle:nil];
            cellDtl = (PEG_DetailQteCell*) c.view;
        }
        
        [cellDtl.AddEditionButton addTarget:self action:@selector(JournalClicked) forControlEvents:UIControlEventTouchUpInside];
        
        cellDtl.NomLieuLabel.text=[[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:self._BeanPresentoir.idLieu].liNomLieu;
        
        cellDtl.TypePresentoirUILabel.text=[NSString stringWithFormat:@"%@ - %@ - %@",self._BeanPresentoir.tYPE,self._BeanPresentoir.emplacement,self._BeanPresentoir.localisation];
        
        
        BeanParution* v_BeanParution= [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:self._BeanParution.id];
        cellDtl.LibellePresentoiUILabel.text= v_BeanParution.libelleEdition;
        
        //cellDtl.QteDistribueLabel.text =
        NSNumber* v_QteDistribuePrec= [[PEG_FMobilitePegase CreateLieu] GetHistoQteDistribueeByIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:v_BeanParution.idParutionPrec] ;
        NSNumber* v_QteRetourPrec= [[PEG_FMobilitePegase CreateLieu] GetHistoQteRetourByIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:v_BeanParution.idParutionPrec] ;
        
        NSNumber* v_QteHistoDistribue= [[PEG_FMobilitePegase CreateLieu] GetHistoQteDistribueeByIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:v_BeanParution.id] ;
        NSNumber* v_QteDistri= [[PEG_FMobilitePegase CreateLieu] GetQteDistribueeByIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:v_BeanParution.id] ;
        NSNumber* v_QteRetourBonEtat = [[PEG_FMobilitePegase CreateLieu] GetQteRetourBonEtatByIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:v_BeanParution.id] ;
        NSNumber* v_QteRetour= [[PEG_FMobilitePegase CreateLieu] GetQteRetourByIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:v_BeanParution.idParutionPrec] ;
        NSNumber* v_QtePrevi = [[PEG_FMobilitePegase CreateLieu] GetQtePrevueByPresentoir:self._BeanPresentoir.idPointDistribution andParution:v_BeanParution.id];
        
        cellDtl.QteACeJourLabel.text = [v_QteHistoDistribue stringValue];
        cellDtl.HistoriqueLabel.text = [NSString stringWithFormat:@"%d - %d = %d",[v_QteDistribuePrec intValue],[v_QteRetourPrec intValue],[v_QteDistribuePrec intValue] - [v_QteRetourPrec intValue]];
        cellDtl.QteReassortPreviTextField.text = [v_QtePrevi stringValue];
        cellDtl.QteReassortTextField.text = [v_QteDistri intValue]== 0 ? @"":[v_QteDistri stringValue];
        cellDtl.RetourTextField.text = [v_QteRetour intValue] == 0 ? @"":[v_QteRetour stringValue];
        cellDtl.RetourBonEtatUITextField.text = [v_QteRetourBonEtat intValue] == 0 ? @"":[v_QteRetourBonEtat stringValue];
        cellDtl.IdParution = [v_BeanParution.id intValue];
        
        cellDtl.QteReassortTextField.delegate = self;
        cellDtl.RetourTextField.delegate = self;
        cellDtl.RetourBonEtatUITextField.delegate = self;
        
        if(self._BeanParution.id != nil)
        {
            cellDtl.QteReassortTextField.enabled = true;
            if(v_BeanParution.idParutionPrec != nil)
            {
                cellDtl.RetourTextField.enabled = true;
            }
            else
            {
                cellDtl.RetourTextField.enabled = false;
            }
            cellDtl.RetourBonEtatUITextField.enabled = true;
            cellDtl.CopieQteReassortUIButton.enabled = true;
            cellDtl.QteACeJourUIButton.enabled = true;
            cellDtl.HistoriqueUIButton.enabled = true;
        }
        else
        {
            cellDtl.QteReassortTextField.enabled = false;
            cellDtl.RetourTextField.enabled = false;
            cellDtl.RetourBonEtatUITextField.enabled = false;
            cellDtl.CopieQteReassortUIButton.enabled = false;
            cellDtl.QteACeJourUIButton.enabled = false;
            cellDtl.HistoriqueUIButton.enabled = false;
        }
            
        cellDtl.IdLieu = [self._BeanPresentoir.idLieu intValue];
        cellDtl.IdPresentoirSelected = [self._BeanPresentoir.idPointDistribution intValue];
                
        [cellDtl initClavier];
        return cellDtl;
    }
    
    if(indexPath.section==1){
        
        cellIdentifier=@"cellMaterielPresentoir";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_DetailQteCell* cellDtl = (PEG_DetailQteCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_DetailQteCell" bundle:nil];
            cellDtl = (PEG_DetailQteCell*) c.view;
        }
        BeanChoix* v_beanchoix  = [self._ListeChoix objectAtIndex:indexPath.item];
        cellDtl.ActionUiLabel.text=v_beanchoix.libelle;
        
        
        if([[PEG_FMobilitePegase CreatePresentoir] IsTacheAFaireIsOnPresentoir:v_beanchoix.code andIdPresentoir:self._BeanPresentoir.id]){
            cellDtl.TachesSegControl.selectedSegmentIndex=0;
        }else if([[PEG_FMobilitePegase CreatePresentoir] IsTacheFaitIsOnPresentoir:v_beanchoix.code andIdPresentoir:self._BeanPresentoir.id]){
            cellDtl.TachesSegControl.selectedSegmentIndex=1;
        }else{
            cellDtl.TachesSegControl.selectedSegmentIndex=2;
        }
        
        cellDtl.TachesSegControl.tag= [v_beanchoix.idItemListChoix intValue];
        cellDtl.CodeMateriel = v_beanchoix.code;
        cellDtl.IdLieu = [self._BeanPresentoir.idLieu intValue];
        cellDtl.IdParution = [self._BeanParution.id intValue];
        cellDtl.IdPresentoirSelected = [self._BeanPresentoir.idPointDistribution intValue];
        return cellDtl;
    }
    if(indexPath.section==2){
        
        cellIdentifier=@"cellTitrePresentoirForScroll";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        UITableViewCell* cellDtl = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return cellDtl;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 235;
    }
    if(indexPath.section==1){
        return 45;
    }
    if(indexPath.section==2){
        return 200;
    }
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) setDetailItem:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber *)p_IdParution{
    
    self._BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
    if(p_IdParution != nil)
    {
        self._BeanParution= [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:p_IdParution];
    }
    self._ListeChoix= [[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixMaterielByTypePresentoir:self._BeanPresentoir.tYPE];  // zzzzz
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"PushQteCeJour"])
    {
        [((PEG_QuantiteACeJourViewController*)[segue destinationViewController]) setDetailItem:self._BeanPresentoir.idPointDistribution andIdParution:self._BeanParution.id];
        
    }
    if([[segue identifier] isEqualToString:@"PushQteHisto"])
    {
        //[((PEG_QuantiteACeJourViewController*)[segue destinationViewController]) setDetailItem:self._BeanPresentoir.idPointDistribution andIdParution:self._BeanParution.idParutionPrec];
        [((PEG_QuantiteACeJourViewController*)[segue destinationViewController]) setDetailItem:self._BeanPresentoir.idPointDistribution andIdEdition:self._BeanParution.idEdition];
        
    }
}

- (void)JournalClicked{
    NSArray* v_list=[[PEG_FMobilitePegase CreateParution]GetListBeanParutionCouranteByCP:self._BeanPresentoir.parentLieu.codePostal];
    SPIROrderedDictionary* v_SPIROrderedDictionary =[[SPIROrderedDictionary alloc]init];
    for (BeanParution* v_BeanParution in v_list) {
        [v_SPIROrderedDictionary setObject:v_BeanParution.libelleEdition forKey:[v_BeanParution.idEdition stringValue]];
    }
    if(v_SPIROrderedDictionary.count > 0)
    {
        [self ShowPicker:v_SPIROrderedDictionary];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Pas de journal"
                              message:@"Aucun journal n'est défini pour ce code postal."
                              delegate:self
                              cancelButtonTitle:@"Quitter"
                              otherButtonTitles:nil];
        
        [alert show];
    }
    
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
    

    if(value.count>0){
        
        SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:0];
        NSNumber* v_indexSelected=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]);
        
        NSNumber* v_IdJournal= (NSNumber*)[v_dict keyAtIndex:[v_indexSelected intValue]];
        
        self._BeanParution= [[PEG_FMobilitePegase CreateParution] GetBeanParutionCouranteByIdEdition:v_IdJournal];
        [[PEG_FMobilitePegase CreatePresentoir] AjouterJournalToPresentoir:self._BeanParution.id andIdPresentoir:self._BeanPresentoir.idPointDistribution andLieu:self._BeanPresentoir.idLieu];
        //  self.UITextFieldSelected.text = v_Libelle;
        [self.MyTableViewUITableView reloadData];
    }
    //[self.TableView reloadData];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *numberFromTheKeyboard = textField.text;
    int v_Qte = 0;
    if(numberFromTheKeyboard.length > 0)
    {
        v_Qte = [numberFromTheKeyboard intValue];
    }
    if(v_Qte >= 0){
        
        if( textField.tag==0){
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:self._BeanPresentoir.idLieu andIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:self._BeanParution.id andQte:[[NSNumber alloc] initWithInt:[numberFromTheKeyboard integerValue]]];
        }else if( textField.tag==1){
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourParutionPrecByIdLieu:self._BeanPresentoir.idLieu andIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:self._BeanParution.id andQte:[[NSNumber alloc] initWithInt:[numberFromTheKeyboard integerValue]]];
        }
        else if( textField.tag==2){
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourBonEtatByIdLieu:self._BeanPresentoir.idLieu andIdPresentoir:self._BeanPresentoir.idPointDistribution andIdParution:self._BeanParution.id andQte:[[NSNumber alloc] initWithInt:[numberFromTheKeyboard integerValue]]];
        }
    }
    [self.MyTableViewUITableView reloadData ];
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
    
    cursorRect = [self.self.MyTableViewUITableView convertRect:cursorRect fromView:textView];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.self.MyTableViewUITableView scrollRectToVisible:cursorRect animated:YES];
    }
}
- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.MyTableViewUITableView.contentOffset;
    visibleRect.origin.y += self.MyTableViewUITableView.contentInset.top;
    visibleRect.size = self.MyTableViewUITableView.bounds.size;
    visibleRect.size.height -= self.MyTableViewUITableView.contentInset.top + self.MyTableViewUITableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.MyTableViewUITableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.MyTableViewUITableView.contentInset = contentInsets;
    self.MyTableViewUITableView.scrollIndicatorInsets = contentInsets;
}
- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.MyTableViewUITableView.contentInset.top, 0.0, 0.0, 0.0);
    self.MyTableViewUITableView.contentInset = contentInsets;
    self.MyTableViewUITableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}
#pragma mark Fin ScrollEcran


- (void)viewDidUnload {
    [self setMyTableViewUITableView:nil];
    [super viewDidUnload];
}
@end
