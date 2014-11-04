//
//  PEG_PresentoirVoleViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 29/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_PresentoirVoleViewController.h"
#import "PEG_FMobilitePegase.h"
#import "BeanPresentoir.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEG_PresentoirSupprimeCell.h"
#import "PEG_PickerViewController.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_ActionReplaceViewController.h"
#import "PEG_EnumActionTache.h"

@interface PEG_PresentoirVoleViewController ()
@property (strong, nonatomic) BeanPresentoir* _BeanPresentoir;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL IsLieuInactif;
@property (assign, nonatomic) BOOL IsSupprime;
@property (assign, nonatomic) BOOL  IsNouveauPresentoir;
@property (assign, nonatomic) BOOL  IsApporterPresentoir;
@end

@implementation PEG_PresentoirVoleViewController


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
    self.IsNouveauPresentoir=NO;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setDetailItem:(NSNumber*)p_IdPresentoir{
    self._BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
    self.IsApporterPresentoir=[[PEG_FMobilitePegase CreatePresentoir] IsTacheAFaireIsOnPresentoir:PEG_EnumActionTache_AppporterPresentoir andIdPresentoir:p_IdPresentoir];
    
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    //if([self._BeanPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
    if([[PEG_FMobilitePegase CreateLieu] GetNbPresentoir:self._BeanPresentoir.parentLieu]<=1 && self.IsSupprime)
    {
        return 1;
        
    }else if (self.IsNouveauPresentoir){
        return 1;
    }else if (self.IsApporterPresentoir){
        return 1;
    }
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  v_section=section;
    
    if(self.IsNouveauPresentoir){
        v_section =1;
    }
    if(self.IsApporterPresentoir){
        v_section =2;
    }
    
    if(v_section==0){
        //if([self._BeanPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted] && [[PEG_FMobilitePegase CreateLieu] GetNbPresentoir:self._BeanPresentoir.parentLieu]==0)
        if([[PEG_FMobilitePegase CreateLieu] GetNbPresentoir:self._BeanPresentoir.parentLieu]<=1 && self.IsSupprime)
        {
            return 2;
        }else{
            return 1;
        }
    }
    else if(v_section==1){
        return 1;
    }
    else if(v_section==2){
        if(self.IsApporterPresentoir)
        {
        return 1;
        }
        else{
            return 1;
        }
    }
    return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    
    NSInteger  v_section=indexPath.section;
    NSInteger  v_row=indexPath.row;
    
    if(self.IsNouveauPresentoir){
        v_section =1;
    }
    if(self.IsApporterPresentoir){
        v_section =2;
    }
    
    if(v_section ==0){
        if(v_row ==0){
            cellIdentifier=@"CellVoleSupprime";
            PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if([self._BeanPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
            {
                [cellDtl.SupprimeUISwitch setOn:YES];
            }
            
            return cellDtl;
        }
        if(v_row ==1){
            
            //if dernier lieu
            cellIdentifier=@"CellVolePresentoirLieuInactif";
            PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            return cellDtl;
            
        }
    }else if(v_section ==1){
        if(v_row ==0){
            cellIdentifier=@"CellVoleNewPres";
            PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(self.IsNouveauPresentoir){
                [cellDtl.NewPresUISwitch setHidden:YES];
            }
            else{
                [cellDtl.NewPresUISwitch setOn:NO];
                [cellDtl.NewPresUISwitch setHidden:NO];
            }
            return cellDtl;
        }
        if(v_row ==1){
            cellIdentifier=@"CellVoleValueNewPres";
            PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            return cellDtl;
        }
    }else if(v_section ==2){
        if(v_row ==0){
            cellIdentifier=@"CellVoleAppPres";
            PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(self.IsApporterPresentoir){
                [cellDtl.AppPresUISwitch setOn:YES];
            }
            else
            {
                [cellDtl.AppPresUISwitch setOn:NO];
            }
            return cellDtl;
        }
        if(v_row ==1){
            cellIdentifier=@"CellVoleNewPres";
            PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            return cellDtl;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}
- (IBAction)supprimerChanged:(id)sender {
    UISwitch* v_switch=(UISwitch*)sender;
    
    self.IsSupprime = v_switch.isOn;
    /*if(v_switch.isOn){
        self.IsSupprime = true;
        [[PEG_FMobilitePegase CreatePresentoir] SetPresentoirDeleted:self._BeanPresentoir];
         if(![[PEG_FMobilitePegase CreateLieu] GetNbPresentoir:self._BeanPresentoir.parentLieu]==0){
         [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.IsSupprime = false;
        self._BeanPresentoir.flagMAJ =PEG_EnumFlagMAJ_Unchanged;
    }*/
    [self.tableView reloadData];
}

- (IBAction)LieuInactifChanged:(id)sender {
    UISwitch* v_switch=(UISwitch*)sender;
    self.IsLieuInactif = v_switch.isOn;
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)NouveaupresentoirChanged:(id)sender {
    UISwitch* v_switch=(UISwitch*)sender;
    self.IsNouveauPresentoir=v_switch.isOn;
    [self.tableView reloadData];
    if(self.IsNouveauPresentoir)
    {
        [self showPickerNewPresentoir];
    }
}
- (IBAction)ApporterPresentoirChanged:(id)sender {
    UISwitch* v_switch=(UISwitch*)sender;
    self.IsApporterPresentoir=v_switch.isOn;
    [self.tableView reloadData];
    if(self.IsApporterPresentoir)
    {
        [self showPickerNewPresentoir];
    }
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void) Save
{
    if(self.IsSupprime)
    {
        [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirSupprimeByIdPresentoir:self._BeanPresentoir.idPointDistribution];
        [[PEG_FMobilitePegase CreatePresentoir] SetPresentoirDeleted:self._BeanPresentoir];
        if(self.IsLieuInactif)
        {
            [[PEG_FMobilitePegase CreateLieu] SetLieuInactif:self._BeanPresentoir.idLieu];
        }
    }
    if(self.IsSupprime || self.IsApporterPresentoir)
    {
        [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirVoleByIdPresentoir:self._BeanPresentoir.idPointDistribution];
    }
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)showPickerNewPresentoir
{
    
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    
    SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
    NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixFamillePresentoir];
    for (BeanChoix* v_RowChoix in  v_listeChoix){
        [values setValue:v_RowChoix.libelle forKey:v_RowChoix.code];
    }
    SPIROrderedDictionary *values2 = [[SPIROrderedDictionary alloc] init];
    //v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixTypePresentoirByCodeFamille:[values keyAtIndex:0]];
    v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixTypePresentoir];
    for (BeanChoix* v_RowChoix in  v_listeChoix){
        [values2 setValue:v_RowChoix.libelle forKey:v_RowChoix.code];
    }
    
    NSArray* v_array = [[NSArray alloc] initWithObjects:values2, nil];
    NSArray* v_arrayValueSelected = [[NSArray alloc]initWithObjects:[values2 keyAtIndex:0],nil];
    
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
        
        NSString* v_Code= (NSString*)[v_dict keyAtIndex:[v_indexSelected intValue]];
        
                 if(self.IsApporterPresentoir || self.IsNouveauPresentoir)
        {
            [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirVoleByIdPresentoir:self._BeanPresentoir.idPointDistribution];
            
            BeanPresentoir* v_BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] RemplacerBeanPresentoirOnLieu:self._BeanPresentoir.parentLieu andBeanPresentoirOrigine:self._BeanPresentoir andType:v_Code];
            
            if(self.IsApporterPresentoir){
                [[PEG_FMobilitePegase CreateLieu] UpdateTachePresentoirByLieu:v_BeanPresentoir.parentLieu andTache:PEG_EnumActionTache_AppporterPresentoir andFait:false andAFaire:self.IsApporterPresentoir];
                
            }

            
           [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else{
        if(self.IsNouveauPresentoir)
        {
            self.IsNouveauPresentoir = false;
            [self.tableView reloadData];
        }
        else if(self.IsApporterPresentoir){
            self.IsApporterPresentoir = false;
            [self.tableView reloadData];
        }
    }
    
}

@end
