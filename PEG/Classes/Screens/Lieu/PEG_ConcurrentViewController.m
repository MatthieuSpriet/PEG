//
//  PEG_ConcurrentViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 25/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ConcurrentViewController.h"
#import "BeanConcurentLieu.h"
#import "PEG_ConcurrentCell.h"
//#import "PEG_BeanConcurentLieu.h"
#import "PEG_FMobilitePegase.h"
#import "BeanConcurents.h"
#import "PEG_PickerViewController.h"
//#import "PEG_BeanChoix.h"
#import "PEGAppDelegate.h"

@interface PEG_ConcurrentViewController ()
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;
@property (nonatomic,strong) NSNumber* IdLieu;
@property (nonatomic,strong) BeanLieu* BeanLieu;
@end

@implementation PEG_ConcurrentViewController

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
    
}

// pm201402 try to avaoid crash when a cell is showing "delete" button and whe tap the back button
// from http://stackoverflow.com/questions/19230446/tableviewcaneditrowatindexpath-crash-when-popping-viewcontroller
- (void)viewWillDisappear:(BOOL)animated
{
    [self.MyTableView setEditing:NO];
    [super viewWillDisappear:animated];
}

-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.IdLieu=p_IdLieu;
    self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SansConcurrentSwitchCahnged:(id)sender {
    [[PEG_FMobilitePegase CreateConcurrent] UpdateSansConcurrentByBeanLieu:self.BeanLieu andSansConcurent:((UISwitch*)sender).isOn];
}

- (IBAction)AddClicked:(id)sender {
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    
    SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
    
//    NSArray *array = [[PEG_FMobilitePegase CreateConcurrent]GetBeanConcurentLieuByLieu:self.BeanLieu];
//    BeanConcurentLieu* v_BeanConcurentLieu = ((BeanConcurentLieu*)[array objectAtIndex:[self.MyTableView indexPathForSelectedRow].row ]
    

    
    for (BeanConcurents* v_RowConcurrent in [[PEG_FMobilitePegase CreateConcurrent]GetAllBeanConcurents])
    {
        [values setValue:v_RowConcurrent.libelleConcurent forKey:[v_RowConcurrent.idConcurentRef stringValue]];
    }
    
    SPIROrderedDictionary *values2 = [[SPIROrderedDictionary alloc] init];
    
    NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixFamillePresentoir];
    for (BeanChoix* v_RowChoix in  v_listeChoix){
        [values2 setValue:v_RowChoix.code forKey:v_RowChoix.code];
    }
    
    SPIROrderedDictionary *values3 = [[SPIROrderedDictionary alloc] init];
    
    [values3 setValue:@"INT" forKey:@"INT"];
    [values3 setValue:@"EXT" forKey:@"EXT"];
    [values3 setValue:@"VP" forKey:@"VP"];
    
    
    NSArray* v_array = [[NSArray alloc] initWithObjects:values,values2,values3, nil];
    NSArray* v_arrayValueSelected = [[NSArray alloc]initWithObjects:[values keyAtIndex:0],[values2 keyAtIndex:0],[values3 keyAtIndex:0],nil];
    
    [pickerController initWithListValue:v_array andListValueSelected:v_arrayValueSelected andNbColonnesToSee:3];
    pickerController.listLargueurColonne = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt: 170],[[NSNumber alloc] initWithInt: 70],[[NSNumber alloc] initWithInt: 60], nil];
    
    
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

- (void)modify{
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    
    SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
    
        NSArray *array = [[PEG_FMobilitePegase CreateConcurrent]GetBeanConcurentLieuByLieu:self.BeanLieu];
    BeanConcurentLieu* v_BeanConcurentLieu = (BeanConcurentLieu*)[array objectAtIndex:[self.MyTableView indexPathForSelectedRow].row ];
    
    
    
    for (BeanConcurents* v_RowConcurrent in [[PEG_FMobilitePegase CreateConcurrent]GetAllBeanConcurents])
    {
        if([v_RowConcurrent.idConcurentRef intValue] ==[v_BeanConcurentLieu.idConcurrence intValue]){
        [values setValue:v_RowConcurrent.libelleConcurent forKey:[v_RowConcurrent.idConcurentRef stringValue]];
        }
    }
    
    SPIROrderedDictionary *values2 = [[SPIROrderedDictionary alloc] init];
    
    NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixFamillePresentoir];
    for (BeanChoix* v_RowChoix in  v_listeChoix){
        [values2 setValue:v_RowChoix.code forKey:v_RowChoix.code];
    }
    
    SPIROrderedDictionary *values3 = [[SPIROrderedDictionary alloc] init];
    
    [values3 setValue:@"INT" forKey:@"INT"];
    [values3 setValue:@"EXT" forKey:@"EXT"];
    [values3 setValue:@"VP" forKey:@"VP"];
    
    
    NSArray* v_array = [[NSArray alloc] initWithObjects:values,values2,values3, nil];
    NSArray* v_arrayValueSelected = [[NSArray alloc]initWithObjects:[values keyAtIndex:0],v_BeanConcurentLieu.famille,v_BeanConcurentLieu.emplacement,nil];
    
    [pickerController initWithListValue:v_array andListValueSelected:v_arrayValueSelected andNbColonnesToSee:3];
    pickerController.listLargueurColonne = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt: 170],[[NSNumber alloc] initWithInt: 70],[[NSNumber alloc] initWithInt: 60], nil];
    
    
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
        NSNumber* v_indexSelectedConcurrent=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]);
        
        NSString* v_IDselected= (NSString*)[v_dict keyAtIndex:[v_indexSelectedConcurrent intValue]];
        
        SPIROrderedDictionary* v_dictFamille = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:1];
        NSNumber* v_indexSelectedFamille=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:1]);
        
        NSString* v_Famille= (NSString*)[v_dictFamille keyAtIndex:[v_indexSelectedFamille intValue]];
        
        SPIROrderedDictionary* v_dictEmplacement = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:2];
        NSNumber* v_indexSelectedEmplacement=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:2]);
        
        NSString* v_Emplacement= (NSString*)[v_dictEmplacement keyAtIndex:[v_indexSelectedEmplacement intValue]];
        
        BeanConcurents* v_BeanConcurrent=[[PEG_FMobilitePegase CreateConcurrent] GetBeanConcurentsById:[NSNumber numberWithInt:[v_IDselected intValue]]];
        
        [[PEG_FMobilitePegase CreateConcurrent] AddOrReplaceConcurrent:v_BeanConcurrent.idConcurentRef AndBeanLieu:self.BeanLieu andFamille:v_Famille andEmplacement:v_Emplacement];
        
        [self.MyTableView reloadData];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[PEG_FMobilitePegase CreateConcurrent] GetNbConcurentLieuByLieu:self.BeanLieu]>0)
        return  [[PEG_FMobilitePegase CreateConcurrent] GetNbConcurentLieuByLieu:self.BeanLieu];
    else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEG_ConcurrentCell *cell=nil;;
    
    if(indexPath.section==0){
        if([[PEG_FMobilitePegase CreateConcurrent] GetNbConcurentLieuByLieu:self.BeanLieu]>0){
            static NSString *CellIdentifier = @"cellNomConcurrent";
            cell =(PEG_ConcurrentCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            // pm201402 no effect ? commented out next line
			//[cell showingDeleteConfirmation];
            
            NSArray *array = [[PEG_FMobilitePegase CreateConcurrent]GetBeanConcurentLieuByLieu:self.BeanLieu];
            BeanConcurentLieu* v_BeanConcurentLieu = ((BeanConcurentLieu*)[array objectAtIndex:indexPath.item ]);
            BeanConcurents* v_BeanConcurrent=[[PEG_FMobilitePegase CreateConcurrent] GetBeanConcurentsById:v_BeanConcurentLieu.idConcurrence];
            
            cell.ConcurrentUILabel.text=[NSString stringWithFormat:@"%@ - %@ - %@",v_BeanConcurrent.libelleConcurent , v_BeanConcurentLieu.famille,v_BeanConcurentLieu.emplacement ];
        }else
        {
            static NSString *CellIdentifier = @"cellZeroConcurrent";
            cell =(PEG_ConcurrentCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [cell.SansConcurrentSwitch setOn:[self.BeanLieu.aucunConcurent boolValue]];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *array = [[PEG_FMobilitePegase CreateConcurrent]GetBeanConcurentLieuByLieu:self.BeanLieu];
        BeanConcurentLieu* v_BeanConcurentLieu = ((BeanConcurentLieu*)[array objectAtIndex:indexPath.item ]);
        [[PEG_FMobilitePegase CreateConcurrent] DeleteConcurenFortLieu:self.BeanLieu andIdConcurent:v_BeanConcurentLieu.idConcurrence];
        [_MyTableView reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[PEG_FMobilitePegase CreateConcurrent] GetNbConcurentLieuByLieu:self.BeanLieu]>0){
    [self modify];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.BeanLieu.listConcurentLieu.count>0){
        return YES;
    }else{
        return NO;
    }
}


@end
