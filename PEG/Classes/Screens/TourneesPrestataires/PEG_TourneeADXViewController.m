//
//  PEG_TourneeADXViewController.m
//  PEG
//
//  Created by Pierre Marty on 26/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_TourneeADXViewController.h"

#import "PEG_FTechnical.h"
#import "PEG_BeanPointDsgn.h"
#import "BeanLieuPassageADX.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_PointTourneeADXCell.h"
#import "PEG_PointTourneeADXViewController.h"
#import "PEG_BeanPresentoirParutionADX.h"


@interface PEG_TourneeADXViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSNumber* IdTournee;
@property (strong, nonatomic) IBOutlet UILabel *LibelleMagazineUILabel;
@property (nonatomic,strong) NSMutableArray* ListBeanPointDsgn;
@property (strong, nonatomic) IBOutlet UITableView *ListePointUITableView;
@property (strong, nonatomic) NSString *QuantiteUITextFieldOldValue;
@property (strong, nonatomic) UITextField *QteUITextField;

@end

@implementation PEG_TourneeADXViewController
{
 
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    BeanTourneeADX * tournee = [[PEG_FMobilitePegase CreateTourneeADX] GetTourneeByIdTournee:self.IdTournee];       // pm: TODO: GetTourneeByIdTournee
    self.navigationItem.title = tournee.liTournee;
    self.LibelleMagazineUILabel.text = [[PEG_FMobilitePegase CreateTourneeADX] GetLibelleMagazinesForDesignByTournee:tournee andNbCarTrunc:15 andEntete:true];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [super viewWillDisappear:animated];
}


#pragma mark - Keyboard Notification

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.ListePointUITableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.ListePointUITableView.contentInset = contentInsets;
    self.ListePointUITableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.ListePointUITableView.contentInset.top, 0.0, 0.0, 0.0);
    self.ListePointUITableView.contentInset = contentInsets;
    self.ListePointUITableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}



// called before the segue is performed to present this view
-(void)setDetailItem:(NSNumber*)p_IdTournee
{
    PEG_BeanPointDsgn* v_NewBeanPoint = nil;
    
    self.IdTournee = p_IdTournee;
    self.ListBeanPointDsgn = [[NSMutableArray alloc] init];
    NSArray * lieuPassages = [[PEG_FMobilitePegase CreateTourneeADX] GetListeLieuPassageByTournee:p_IdTournee];
    // DLog (@"lieuPassages: %d\n%@", lieuPassages.count, lieuPassages);
    for (BeanLieuPassageADX* v_ItemLieuPassage in lieuPassages)
    {
        BOOL v_IsFirstPresentoir = true;
        //BeanLieu* v_ItemLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:v_ItemLieuPassage.idLieu];
        ///
        
        // tel Matthieu 28/05 : ne pas
        // => GetListPresentoirParutionByLieuPassageADX
        
        for(PEG_BeanPresentoirParutionADX* v_BPP in [[PEG_FMobilitePegase CreateTourneeADX] GetListPresentoirParutionByLieuPassageADX:v_ItemLieuPassage]) {
            
            v_NewBeanPoint = [[PEG_BeanPointDsgn alloc] init];
            v_NewBeanPoint.IdLieu = v_BPP.idLieu;
            v_NewBeanPoint.IdLieuPassage = v_ItemLieuPassage.idLieuPassage;
            v_NewBeanPoint.IdPresentoir = v_BPP.IdPresentoir;
            if(v_IsFirstPresentoir)
            {
                v_NewBeanPoint.NumeroPoint = [v_ItemLieuPassage.nbOrdrePassage stringValue];
                //v_NewBeanPoint.NombreTache = [[NSNumber alloc] initWithInt:[[PEG_FMobilitePegase CreateLieu] GetNbAllTacheForLieu:v_ItemLieu]];//[[NSNumber alloc] initWithInt:v_ItemPresentoir.listTache.count];
                v_NewBeanPoint.NomPoint = v_ItemLieuPassage.nomLieu;
                v_IsFirstPresentoir = false;
            }
            v_NewBeanPoint.TypePresentoir = v_BPP.codeTypePresentoir;
            v_NewBeanPoint.Commune = v_ItemLieuPassage.commune;
            NSNumber* v_qteDist = 0;
            NSNumber* v_qtePrevi = 0;
            NSNumber* v_qteRetour = 0;
            v_NewBeanPoint.IdParution = v_BPP.idParution;
            v_NewBeanPoint.IdParutionRef = v_BPP.idParutionRef;
            v_NewBeanPoint.IdParutionPrec = v_BPP.idParutionPrec;
            v_NewBeanPoint.IdParutionPrecRef = v_BPP.idParutionRefPrec;
            v_NewBeanPoint.IdEditionRef = v_BPP.idEditionRef;
            v_NewBeanPoint.Parution = v_BPP.libParution;
                v_qteDist = [[PEG_FMobilitePegase CreateTourneeADX] GetQteDistriByPresentoir:v_BPP.IdPresentoir andParutionRef:v_BPP.idParutionRef andBeanLieuPassage:v_ItemLieuPassage];
                v_qtePrevi = [[PEG_FMobilitePegase CreateTourneeADX] GetQtePrevueByPresentoir:v_BPP.IdPresentoir andParutionRef:v_BPP.idParutionRef andBeanLieuPassage:v_ItemLieuPassage];
                v_qteRetour = [[PEG_FMobilitePegase CreateTourneeADX] GetQteRetourByPresentoir:v_BPP.IdPresentoir andParutionRef:v_BPP.idParutionRefPrec andBeanLieuPassage:v_ItemLieuPassage];

            if([v_qteDist intValue] != 0)
            {
                v_NewBeanPoint.QuantiteDistribuee = v_qteDist;
            }
            if([v_qtePrevi intValue] != 0)
            {
                v_NewBeanPoint.QuantitePreparee = v_qtePrevi;
            }
            if([v_qteRetour intValue] != 0)
            {
                v_NewBeanPoint.QuantiteRetour = v_qteRetour;
            }
            [self.ListBeanPointDsgn addObject:v_NewBeanPoint];
        }
    }
    
}



#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.ListBeanPointDsgn != nil)
    {
        return [self.ListBeanPointDsgn count]+5;    // pm: I assume it is to allow scrolling past last cell when the kbd is visible ?
    }
    else return 0;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //On active ou desactive le bouton back si la tournee est debutée ou terminée
    if([[PEG_FMobilitePegase CreateTourneeADX] IsCompteRenduTourneeDebuteeByIdTournee:self.IdTournee])
    {
        self.navigationItem.hidesBackButton = YES;
    }
    if([[PEG_FMobilitePegase CreateTourneeADX] IsCompteRenduTourneeTermineeByIdTournee:self.IdTournee])
    {
        self.navigationItem.hidesBackButton = NO;
    }
    
    PEG_PointTourneeADXCell* cell = nil;
    NSString * cellIdentifier = @"cellPointTournee";
    cell = (PEG_PointTourneeADXCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row < [self.ListBeanPointDsgn count])
    {
        cell.quantiteDistribueeTextField.delegate=self;
        cell.quantiteRetourTextField.delegate=self;

        [self initClavier:cell.quantiteDistribueeTextField];
        [self initClavier:cell.quantiteRetourTextField];
        
        PEG_BeanPointDsgn* v_BeanPointDsgn = [self.ListBeanPointDsgn objectAtIndex:indexPath.item];
        [cell initWithPointDsgn:v_BeanPointDsgn];
    
        // v_BeanPointDsgn.IdParution = @9999;     // zzz test pm, mais on crash plus loin !
        
        /*if (v_BeanPointDsgn.IdParution == nil)
        {
            cell.quantiteDistribueeTextField.enabled = false;
            cell.quantiteRetourTextField.enabled = false;
            cell.copierPreviButton.enabled = false;
        }
        else
        {
            cell.quantiteDistribueeTextField.enabled = true;
            cell.quantiteRetourTextField.enabled = true;
            cell.copierPreviButton.enabled = true;
        }*/
        cell.copierPreviButton.tag = indexPath.row;
    }
    else
    {
        // pm: as far as I understand, there are 5 invisible cells used to allow scrolling past last actual cell, so there is no need to initialize anything here !
        [cell setHidden:YES];
    }

    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"actionsADX" sender:self];
}


// initialize inputAccessoryView for a textField
- (void)initClavier:(UITextField *) p_TextField
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadQuantite)],
                           nil];
    [numberToolbar sizeToFit];
    p_TextField.inputAccessoryView = numberToolbar;
    
}


-( void)doneWithNumberPadQuantite
{
    NSString *numberFromTheKeyboard = self.QteUITextField.text;
    int v_Qte = 0;
    if (numberFromTheKeyboard.length > 0)
    {
        v_Qte = [numberFromTheKeyboard intValue];
    }
    if (v_Qte >= 0)
    {
        UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:self.QteUITextField];
        
        PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:[self.ListePointUITableView indexPathForCell:cell].row];
        if (self.QteUITextField.tag==0)
        {
            //[[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            [[PEG_FMobilitePegase CreateActionPresentoirADX] AddOrUpdateQteDistribueByIdLieuPassageADX:v_PointDsgn.IdLieuPassage andIdPresentoir:v_PointDsgn.IdPresentoir  andIdParutionRef:v_PointDsgn.IdParutionRef andIdEditionRef:v_PointDsgn.IdEditionRef andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteDistribuee=[NSNumber numberWithInt:v_Qte];
        }
        else
        {
            //[[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourParutionPrecByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            [[PEG_FMobilitePegase CreateActionPresentoirADX] AddOrUpdateQteRetourByIdLieuPassageADX:v_PointDsgn.IdLieuPassage andIdPresentoir:v_PointDsgn.IdPresentoir  andIdParutionPrecRef:v_PointDsgn.IdParutionPrecRef andIdEditionRef:v_PointDsgn.IdEditionRef andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteRetour=[NSNumber numberWithInt:v_Qte];
        }
    }
    [self.QteUITextField resignFirstResponder];
    [self.ListePointUITableView reloadData ];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:textField];
    
    self.QuantiteUITextFieldOldValue = textField.text;
    self.QteUITextField=textField;
    
    [self.ListePointUITableView scrollToRowAtIndexPath:[self.ListePointUITableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    [textField performSelector:@selector(selectAll:) withObject:textField afterDelay:0.f];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *numberFromTheKeyboard = textField.text;
    int v_Qte = 0;
    if(numberFromTheKeyboard.length > 0)
    {
        v_Qte = [numberFromTheKeyboard intValue];
    }
    if(v_Qte >= 0)
    {
        UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:textField];
        NSLog (@"textFieldDidEndEditing: %@", cell);
        
        // TODO: pm check next lines

        PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:[self.ListePointUITableView indexPathForCell:cell].row];
        if( textField.tag==0)
        {
            //[[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            [[PEG_FMobilitePegase CreateActionPresentoirADX] AddOrUpdateQteDistribueByIdLieuPassageADX:v_PointDsgn.IdLieuPassage andIdPresentoir:v_PointDsgn.IdPresentoir  andIdParutionRef:v_PointDsgn.IdParutionRef andIdEditionRef:v_PointDsgn.IdEditionRef andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteDistribuee=[NSNumber numberWithInt:v_Qte];
        }
        else
        {
            //[[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourParutionPrecByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            [[PEG_FMobilitePegase CreateActionPresentoirADX] AddOrUpdateQteRetourByIdLieuPassageADX:v_PointDsgn.IdLieuPassage andIdPresentoir:v_PointDsgn.IdPresentoir  andIdParutionPrecRef:v_PointDsgn.IdParutionPrecRef andIdEditionRef:v_PointDsgn.IdEditionRef andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteRetour=[NSNumber numberWithInt:v_Qte];
        }
 
    }
    [self.ListePointUITableView reloadData ];
}

- (IBAction)btnCopiePreviTouchUpInside:(id)sender {
    
    int v_row = ((UIButton*)sender).tag;
    //PEG_ListePointTourneeCell *cell = (PEG_ListePointTourneeCell*)[PEG_FTechnical getTableViewCellFromUI:self.QteUITextField];
    
    //PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:[self.ListePointUITableView indexPathForCell:cell].row];
    
    PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:v_row];
    
    if(v_PointDsgn.QuantitePreparee > 0)
    {
        v_PointDsgn.QuantiteDistribuee = v_PointDsgn.QuantitePreparee;
        int v_Qte = [v_PointDsgn.QuantiteDistribuee intValue];
        if(v_Qte > 0){
            //BeanLieuPassageADX* v_LP = [[PEG_FMobilitePegase CreateTourneeADX] GetBeanLieuPassageADXById:v_PointDsgn.IdLieuPassage];
            [[PEG_FMobilitePegase CreateActionPresentoirADX] AddOrUpdateQteDistribueByIdLieuPassageADX:v_PointDsgn.IdLieuPassage andIdPresentoir:v_PointDsgn.IdPresentoir andIdParutionRef:v_PointDsgn.IdParutionRef andIdEditionRef:v_PointDsgn.IdEditionRef andQte:[[NSNumber alloc] initWithInt:v_Qte]];
        }
    }
    
    [self.ListePointUITableView reloadData ];
}


#pragma mark Segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"actionsADX"])
    {
        NSIndexPath* v_index = [self.ListePointUITableView indexPathForSelectedRow];
        PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:v_index.row];
        [((PEG_PointTourneeADXViewController*)[segue destinationViewController]) setDetailItem:v_PointDsgn];
    }
   
}


@end
