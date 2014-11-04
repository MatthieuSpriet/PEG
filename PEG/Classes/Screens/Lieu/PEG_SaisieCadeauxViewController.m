//
//  PEG_SaisieCadeauxViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 28/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_SaisieCadeauxViewController.h"
#import "PEG_SaisieCadeauxCell.h"
//#import "PEG_BeanMobilitePegase.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_PickerViewController.h"


@interface PEG_SaisieCadeauxViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *CadeauxPickerView;
//@property (nonatomic, retain) NSArray*                  listAllValues;
@property (nonatomic,strong) BeanLieu* BeanLieu;
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;

@end

@implementation PEG_SaisieCadeauxViewController


#pragma mark - Init
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
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(BackClicked)];
    self.navigationItem.leftBarButtonItem = backButton;
    
	// Do any additional setup after loading the view.
    self.navigationItem.title=@"Saisir un Cadeau";
   
    
    
    
}
// try to avaoid crash when a cell is showing "delete" button and whe tap the back button
// from http://stackoverflow.com/questions/19230446/tableviewcaneditrowatindexpath-crash-when-popping-viewcontroller
- (void)viewWillDisappear:(BOOL)animated
{
    [self.MyTableView setEditing:NO];
    [super viewWillDisappear:animated];
}

-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
}
- (IBAction)LieuExclusifChanged:(id)sender {
    [[PEG_FMobilitePegase CreateLieu] UpdateLieuExclusifByLieu:self.BeanLieu andExclusif:((UISwitch *)sender).isOn];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[PEG_FMobilitePegase CreateActionPresentoir] GetBeanActionListCadeauByIdLieu:self.BeanLieu.idLieu].count>0)
        return 2;
    else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 2;
    else if(section==1)
        return [[[PEG_FMobilitePegase CreateActionPresentoir] GetBeanActionListCadeauByIdLieu:self.BeanLieu.idLieu] count];
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEG_SaisieCadeauxCell *cell=nil;
    
    if(indexPath.section==0){
        if(indexPath.row==0){
            
            NSString *CellIdentifier = @"cellNom";
            cell =(PEG_SaisieCadeauxCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.NomResponsableLabel.text=[NSString stringWithFormat:@"%@ %@",self.BeanLieu.respCivilite, self.BeanLieu.respNom];
        }
        if(indexPath.row==1){
            NSString *CellIdentifier = @"cellLieuExclusif";
            cell =(PEG_SaisieCadeauxCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell.LieuExclusifSwitch setOn: [self.BeanLieu.vfExclusif boolValue]];
        }
    }
    if(indexPath.section==1){
        NSString *CellIdentifier = @"cellCadeau";
        cell =(PEG_SaisieCadeauxCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.CadeauLabel.text=
        [[PEG_FMobilitePegase CreateListeChoix] GetLibelleCadeauxByCode:((BeanAction*)[[[PEG_FMobilitePegase CreateActionPresentoir] GetBeanActionListCadeauByIdLieu:self.BeanLieu.idLieu] objectAtIndex:indexPath.row]).valeurTexte];
        cell.NombreCadeauLabel.text=[((BeanAction*)[[[PEG_FMobilitePegase CreateActionPresentoir] GetBeanActionListCadeauByIdLieu:self.BeanLieu.idLieu] objectAtIndex:indexPath.row]).valeurInt stringValue];
    }
    
    
    return cell;
}


#pragma mark UIPickerViewDelegate





#pragma mark -
#pragma mark UIPickerViewDatasource


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString* v_CodeCadeau=     ((BeanAction*)[[[PEG_FMobilitePegase CreateActionPresentoir] GetBeanActionListCadeauByIdLieu:self.BeanLieu.idLieu] objectAtIndex:indexPath.row]).valeurTexte;
        [[PEG_FMobilitePegase CreateActionPresentoir] DeleteCadeauByIdLieu:self.BeanLieu.idLieu andCodeCadeau:v_CodeCadeau];

        [_MyTableView reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==1
       && [[[PEG_FMobilitePegase CreateActionPresentoir] GetBeanActionListCadeauByIdLieu:self.BeanLieu.idLieu] count] > 0){
        return YES;
    }else return NO;
    
}
- (IBAction)AddClicked:(id)sender {
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    
    NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixCadeau];
     
    SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
    
    for (BeanChoix* v_RowChoix in v_listeChoix)
    {
        [values setValue:v_RowChoix.libelle forKey:v_RowChoix.code ];
    }
    
    
    SPIROrderedDictionary *values2 = [[SPIROrderedDictionary alloc] init];
    for (int i = 1; i <= 100; i++)
    {
        [values2 setValue:[NSString stringWithFormat:@"%d", i] forKey:[NSString stringWithFormat:@"%d", i]];
    }
    //On ajoute les milier pour les sacs à pain
    for (int i = 1000; i < 10000; i=i+1000)
    {
        [values2 setValue:[NSString stringWithFormat:@"%d", i] forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    
    NSArray* v_array = [[NSArray alloc] initWithObjects:values,values2, nil];
    NSArray* v_arrayValueSelected = [[NSArray alloc]initWithObjects:[values keyAtIndex:0],[values2 keyAtIndex:0],nil];
    
    [pickerController initWithListValue:v_array andListValueSelected:v_arrayValueSelected andNbColonnesToSee:2];
    pickerController.listLargueurColonne = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt: 240],[[NSNumber alloc] initWithInt: 70], nil];
    
    
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
            
        SPIROrderedDictionary* v_dictQte = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:1];
        NSNumber* v_indexSelectedQte=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:1]);
        int v_Qte= [(NSNumber*)[v_dictQte keyAtIndex:[v_indexSelectedQte intValue]] intValue];
        
        
        SPIROrderedDictionary* v_dictCadeau = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:0];
        NSNumber* v_indexSelectedCadeau=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]);
        NSString* v_CodeCadeau = (NSString*)[v_dictCadeau keyAtIndex:[v_indexSelectedCadeau intValue]];
        
        [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdateCadeauByIdLieu:self.BeanLieu.idLieu andCodeCadeau:v_CodeCadeau andQte:[[NSNumber alloc]initWithInt:v_Qte]];
        
        [self.MyTableView reloadData];
        
    }
}

- (void)BackClicked
{

    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}
@end
