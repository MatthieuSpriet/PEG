//
//  PEG_ListePointTourneeViewController.m
//  PEG
//
//  Created by HorsMedia1 on 27/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListePointTourneeViewController.h"
#import "PEG_ListePointTourneeCell.h"
#import "BeanLieuPassage.h"
#import "PEG_FMobilitePegase.h"
#import "BeanPresentoir.h"
#import "PEG_BeanPointDsgn.h"
#import "PEG_DtlLieuxViewController.h"
#import "Peg_EnuActionMobilite.h"
#import "PEG_BeanPresentoirParution.h"
#import "BeanEdition.h"
#import "PEG_FTechnical.h"
#import "NSNotification+KeyboardAdditions.h"

@interface PEG_ListePointTourneeViewController ()
//liste de PEG_BeanLieuPassage
@property (strong, nonatomic) IBOutlet UILabel *LibelleMagazineUILabel;
@property (nonatomic,strong) NSMutableArray* ListBeanPointDsgn;
@property (strong, nonatomic) IBOutlet UITableView *ListePointUITableView;
@property (strong, nonatomic) NSString *QuantiteUITextFieldOldValue;
@property (strong, nonatomic) BeanTournee* _BeanTournee;
@property (strong, nonatomic) UITextField *QteUITextField;
@end

@implementation PEG_ListePointTourneeViewController

// UIMenuController : en charge de copy / paste etc.

-(void)processit:(id)sender
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO];
    [menu performSelector:@selector(setMenuVisible:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.15];
}

- (void)viewDidLoad
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self._BeanTournee = [[PEG_FMobilitePegase CreateTournee] GetTourneeByIdTournee:self.IdTournee];
    self.navigationItem.title = self._BeanTournee.liTournee;
    self.LibelleMagazineUILabel.text = [[PEG_FMobilitePegase CreateTournee] GetLibelleMagazinesForDesignByTournee:self._BeanTournee andNbCarTrunc:15 andEntete:true];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processit:) name:UIMenuControllerWillShowMenuNotification object:nil];
    
    //UIBarButtonItem * v_RefreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(RefreshIButtonClick)];
    //self.navigationItem.rightBarButtonItem = v_RefreshButton;
}


/*
- (void)RefreshIButtonClick{
    self.LibelleMagazineUILabel.text = [[PEG_FMobilitePegase CreateTournee] GetLibelleMagazinesForDesignByTournee:self._BeanTournee andNbCarTrunc:15 andEntete:true];
}
*/
static CGRect savedFrame;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setDetailItem:self.IdTournee];
    [self.ListePointUITableView reloadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    savedFrame = self.ListePointUITableView.frame;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark - Keyboard Notificiation


- (void)keyboardWillShow:(NSNotification*)notification {
    float keyboardTop = [notification keyboardFrameInView:self.ListePointUITableView].origin.y;
    
    CGRect frame = self.ListePointUITableView.frame;
//    savedFrame = frame;
    frame.size.height = keyboardTop;
    self.ListePointUITableView.frame = frame;
    [self.ListePointUITableView scrollRectToVisible:frame animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:[notification keyboardAnimationDuration]];
    self.ListePointUITableView.frame = savedFrame;
    
    [UIView commitAnimations];
}


#pragma mark Gestion de la table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.ListBeanPointDsgn != nil){
        return [self.ListBeanPointDsgn count];
    }
    else return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // DLog (@"cellForRowAtIndexPath %d / %d", indexPath.row, [self.ListBeanPointDsgn count]);
    static NSString * cellIdentifier = @"cellListePointTournee";
    PEG_ListePointTourneeCell* cellDtl = (PEG_ListePointTourneeCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cellDtl.QuantiteDistribueeUITextField.delegate=self;
    cellDtl.QuantiteRetourUITextField.delegate=self;
    cellDtl.QuantiteDistribueeUITextField.tag=0;
    cellDtl.QuantiteRetourUITextField.tag=1;
    [self initClavier:cellDtl.QuantiteDistribueeUITextField];
    [self initClavier:cellDtl.QuantiteRetourUITextField];
    PEG_BeanPointDsgn* v_BeanPointDsgn = [self.ListBeanPointDsgn objectAtIndex:indexPath.item];
    NSString* v_NumeroPoint = v_BeanPointDsgn.NumeroPoint;
    NSString* v_NomPoint = v_BeanPointDsgn.NomPoint;
    NSNumber* v_NombreTache = v_BeanPointDsgn.NombreTache;
    NSString* v_TypePresentoir = v_BeanPointDsgn.TypePresentoir;
    NSString* v_Commune = v_BeanPointDsgn.Commune;
    NSString* v_Parution = v_BeanPointDsgn.Parution;
    NSNumber* v_QuantitePreparee=v_BeanPointDsgn.QuantitePreparee;
    NSNumber* v_QuantiteDistribuee=v_BeanPointDsgn.QuantiteDistribuee;
    NSNumber* v_QuantiteRetour=v_BeanPointDsgn.QuantiteRetour;
    
    [cellDtl initDataWithNumPoint:v_NumeroPoint andNomPoint:v_NomPoint andTypePresentoir:v_TypePresentoir andCommune:v_Commune andParution:v_Parution andQtePrepa:v_QuantitePreparee andQteDistri:v_QuantiteDistribuee andQteRetour:v_QuantiteRetour andNbTache:v_NombreTache andIdPresentoir:v_BeanPointDsgn.IdPresentoir andIdParution:v_BeanPointDsgn.IdParution andIdLieuPassage:v_BeanPointDsgn.IdLieuPassage];
    
    if(v_BeanPointDsgn.IdParution == nil)
    {
        cellDtl.QuantiteDistribueeUITextField.enabled = false;
        cellDtl.QuantiteRetourUITextField.enabled = false;
        cellDtl.BtnCopierPreviUIButton.enabled = false;
    }
    else
    {
        cellDtl.QuantiteDistribueeUITextField.enabled = true;
        if(v_BeanPointDsgn.IdParutionPrec != nil)
        {
            cellDtl.QuantiteRetourUITextField.enabled = true;
        }
        else
        {
            cellDtl.QuantiteRetourUITextField.enabled = false;
        }
        cellDtl.BtnCopierPreviUIButton.enabled = true;
    }
    cellDtl.BtnCopierPreviUIButton.tag = indexPath.row;
    
    return cellDtl;
}

// associer au dessus du clavier une barre avec un bouton "Apply"
- (void)initClavier:(UITextField *) p_TextField
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           //[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadQuantite)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadQuantite)],
                           nil];
    [numberToolbar sizeToFit];
    p_TextField.inputAccessoryView = numberToolbar;
    
}

//- (IBAction)QuantiteDistribueeUITextFieldEditingDidBegin:(UITextField*)sender {
//    self.QuantiteUITextFieldOldValue = sender.text;
//    self.QteUITextField=sender;
//    UITableViewCell *cell = (UITableViewCell*) [[sender superview] superview];
//    [self.ListePointUITableView scrollToRowAtIndexPath:[self.ListePointUITableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    self.IsKeyBoardOpen=YES;
//    [self.ListePointUITableView reloadData ];
//    [sender performSelector:@selector(selectAll:) withObject:sender afterDelay:0.f];
//
//}
//- (IBAction)QuantiteRetourUITextFieldEditingDidBegin:(UITextField*)sender {
//    self.QuantiteUITextFieldOldValue = sender.text;
//    self.QteUITextField=sender;
//    UITableViewCell *cell = (UITableViewCell*) [[sender superview] superview];
//    [self.ListePointUITableView scrollToRowAtIndexPath:[self.ListePointUITableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    self.IsKeyBoardOpen=YES;
//    [self.ListePointUITableView reloadData ];
//    [sender performSelector:@selector(selectAll:) withObject:sender afterDelay:0.f];
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //UITableViewCell *cell = (UITableViewCell*) [[textField superview] superview];
    UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:textField];
    
    self.QuantiteUITextFieldOldValue = textField.text;
    self.QteUITextField=textField;
    
    [self.ListePointUITableView scrollToRowAtIndexPath:[self.ListePointUITableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    // [self.ListePointUITableView reloadData ];
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
    if(v_Qte >= 0){
        
        //            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieuPassage:self.IdLieuPassage andIdPresentoir:self.IdPresentoir andIdParution:self.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
        
        //UITableViewCell *cell = (UITableViewCell*) [[self.QteUITextField superview] superview];
        UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:textField];
        
        PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:[self.ListePointUITableView indexPathForCell:cell].row];
        if( textField.tag==0){
            
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteDistribuee=[NSNumber numberWithInt:v_Qte];
        }else{
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourParutionPrecByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteRetour=[NSNumber numberWithInt:v_Qte];
        }
    }
    //[self.QteUITextField resignFirstResponder];
    [self.ListePointUITableView reloadData ];
}


/*-(void)cancelNumberPadQuantite{
    [self.QteUITextField resignFirstResponder];
    self.QteUITextField.text = self.QuantiteUITextFieldOldValue;
    [self.ListePointUITableView reloadData ];
}*/

-(void)doneWithNumberPadQuantite{
    NSString *numberFromTheKeyboard = self.QteUITextField.text;
    int v_Qte = 0;
    if(numberFromTheKeyboard.length > 0)
    {
        v_Qte = [numberFromTheKeyboard intValue];
    }
    if(v_Qte >= 0){
        
        //            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieuPassage:self.IdLieuPassage andIdPresentoir:self.IdPresentoir andIdParution:self.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
        
        //UITableViewCell *cell = (UITableViewCell*) [[self.QteUITextField superview] superview];
        UITableViewCell *cell = [PEG_FTechnical getTableViewCellFromUI:self.QteUITextField];
        
        PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:[self.ListePointUITableView indexPathForCell:cell].row];
        if( self.QteUITextField.tag==0){
            
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteDistribuee=[NSNumber numberWithInt:v_Qte];
        }else{
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteRetourParutionPrecByIdLieu:v_PointDsgn.IdLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
            v_PointDsgn.QuantiteRetour=[NSNumber numberWithInt:v_Qte];
        }
    }
    [self.QteUITextField resignFirstResponder];
    [self.ListePointUITableView reloadData ];
}


-(void) setDetailItem:(NSNumber*)p_IdTournee
{
    PEG_BeanPointDsgn* v_NewBeanPoint = nil;
    
    self.IdTournee = p_IdTournee;
    self.ListBeanPointDsgn = [[NSMutableArray alloc] init];
    for (BeanLieuPassage* v_ItemLieuPassage in [[PEG_FMobilitePegase CreateTournee] GetListeLieuPassageByTournee:p_IdTournee])
    {
        BOOL v_IsFirstPresentoir = true;
        BeanLieu* v_ItemLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:v_ItemLieuPassage.idLieu];
        ///
        for(PEG_BeanPresentoirParution* v_BPP in [[PEG_FMobilitePegase CreateLieu] GetListPresentoirParutionByLieu:v_ItemLieu andIdTournee:p_IdTournee ]) {
            //for (BeanAction* v_Baction in v_ItemLieuPassage.listAction) {
            /*if([v_Baction.codeAction isEqualToString:PEG_EnuActionMobilite_Previ]
             || [v_Baction.codeAction isEqualToString:PEG_EnuActionMobilite_Distri]
             || [v_Baction.codeAction isEqualToString:PEG_EnuActionMobilite_Retour])
             {*/
            //BeanPresentoir* v_ItemPresentoir = [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:v_Baction.idPresentoir];
            BeanPresentoir* v_ItemPresentoir = v_BPP.Presentoir;
            BeanParution* v_BeanParution = nil;
            if(v_BPP.Parution != nil)
            {
                //v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_BPP.Parution.id];
                v_BeanParution = v_BPP.Parution;
            }
            v_NewBeanPoint = [[PEG_BeanPointDsgn alloc] init];
            v_NewBeanPoint.IdLieu = v_ItemLieuPassage.idLieu;
            v_NewBeanPoint.IdLieuPassage = v_ItemLieuPassage.idLieuPassage;
            v_NewBeanPoint.IdPresentoir = v_ItemPresentoir.id;
            if(v_IsFirstPresentoir)
            {
                v_NewBeanPoint.NumeroPoint = [v_ItemLieuPassage.nbOrdrePassage stringValue];
                v_NewBeanPoint.NombreTache = [[NSNumber alloc] initWithInt:[[PEG_FMobilitePegase CreateLieu] GetNbAllTacheForLieu:v_ItemLieu]];//[[NSNumber alloc] initWithInt:v_ItemPresentoir.listTache.count];
                v_NewBeanPoint.NomPoint = v_ItemLieu.liNomLieu;
                v_IsFirstPresentoir = false;
            }
            v_NewBeanPoint.TypePresentoir = v_ItemPresentoir.tYPE;
            v_NewBeanPoint.Commune = v_ItemLieu.ville;
            NSNumber* v_qteDist = 0;
            NSNumber* v_qtePrevi = 0;
            NSNumber* v_qteRetour = 0;
            if(v_BeanParution != nil)
            {
                v_NewBeanPoint.IdParution = v_BeanParution.id;
                v_NewBeanPoint.Parution = v_BeanParution.libelleEdition;
                v_NewBeanPoint.IdParutionPrec = v_BeanParution.idParutionPrec;
                
                v_qteDist = [[PEG_FMobilitePegase CreateLieu] GetQteDistriByPresentoir:v_ItemPresentoir.idPointDistribution andParution:v_BeanParution.id andBeanLieuPassage:v_ItemLieuPassage];
                v_qtePrevi = [[PEG_FMobilitePegase CreateLieu] GetQtePrevueByPresentoir:v_ItemPresentoir.idPointDistribution andParution:v_BeanParution.id andBeanLieuPassage:v_ItemLieuPassage];
                v_qteRetour = [[PEG_FMobilitePegase CreateLieu] GetQteRetourByPresentoir:v_ItemPresentoir.idPointDistribution andParution:v_BeanParution.idParutionPrec andBeanLieuPassage:v_ItemLieuPassage];
            }
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
            //}
        }
        ///
        
        //        for(BeanPresentoir* v_ItemPresentoir in v_ItemLieu.listPresentoir)
        //        {
        //            BeanParution* v_BeanParution = nil;
        //            if(v_ItemPresentoir.idParution != nil)
        //            {
        //                v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_ItemPresentoir.idParution];
        //            }
        //            else{
        //                v_BeanParution = [[PEG_FMobilitePegase CreatePresentoir] GetParutionEnCoursByPresentoir:v_ItemPresentoir];
        //            }
        //            v_NewBeanPoint = [[PEG_BeanPointDsgn alloc] init];
        //            v_NewBeanPoint.IdLieu = v_ItemLieu.idLieu;
        //            v_NewBeanPoint.IdLieuPassage = v_ItemLieuPassage.idLieuPassage;
        //            v_NewBeanPoint.IdPresentoir = v_ItemPresentoir.id;
        //            if(v_IsFirstPresentoir)
        //            {
        //                v_NewBeanPoint.NumeroPoint = [v_ItemLieuPassage.nbOrdrePassage stringValue];
        //                v_NewBeanPoint.NombreTache = [[NSNumber alloc] initWithInt:v_ItemPresentoir.listTache.count];
        //                v_NewBeanPoint.NomPoint = v_ItemLieu.liNomLieu;
        //                v_IsFirstPresentoir = false;
        //            }
        //            v_NewBeanPoint.TypePresentoir = v_ItemPresentoir.tYPE;
        //            v_NewBeanPoint.Commune = v_ItemLieu.ville;
        //            if(v_BeanParution != nil)
        //            {
        //                v_NewBeanPoint.IdParution = v_BeanParution.id;
        //                v_NewBeanPoint.Parution = v_BeanParution.libelleEdition;
        //            }
        //            NSNumber* v_qteDist = [[PEG_FMobilitePegase CreateLieu] GetQteDistriByPresentoir:v_ItemPresentoir.id andParution:v_ItemPresentoir.idParution andBeanLieuPassage:v_ItemLieuPassage];
        //            if(![v_qteDist isEqualToNumber:[[NSNumber alloc]initWithInt:0]])
        //            {
        //                v_NewBeanPoint.QuantiteDistribuee = v_qteDist;
        //            }
        //            v_NewBeanPoint.QuantitePreparee = [[PEG_FMobilitePegase CreateLieu] GetQtePrevueByPresentoir:v_ItemPresentoir.id andParution:v_ItemPresentoir.idParution andBeanLieuPassage:v_ItemLieuPassage];
        //            NSNumber* v_qteRetour = [[PEG_FMobilitePegase CreateLieu] GetQteRetourByPresentoir:v_ItemPresentoir.id andParution:v_ItemPresentoir.idParution andBeanLieuPassage:v_ItemLieuPassage];
        //            if(![v_qteRetour isEqualToNumber:[[NSNumber alloc]initWithInt:0]])
        //            {
        //                v_NewBeanPoint.QuantiteRetour = [[PEG_FMobilitePegase CreateLieu] GetQteRetourByPresentoir:v_ItemPresentoir.id andParution:v_ItemPresentoir.idParution andBeanLieuPassage:v_ItemLieuPassage];
        //            }
        //            [self.ListBeanPointDsgn addObject:v_NewBeanPoint];
        //        }
    }
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
            BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageById:v_PointDsgn.IdLieuPassage];
            [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_LP.idLieu andIdPresentoir:v_PointDsgn.IdPresentoir andIdParution:v_PointDsgn.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
        }
    }
    
    [self.ListePointUITableView reloadData ];
}


#pragma mark Segue
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushListePointToDetailLieu" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pushListePointToDetailLieu"])
    {
        NSIndexPath* v_index = [self.ListePointUITableView indexPathForSelectedRow];
        PEG_BeanPointDsgn* v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:v_index.row];
        [((PEG_DtlLieuxViewController*)[segue destinationViewController]) setDetailItem:v_PointDsgn.IdLieu];
    }
}


@end
