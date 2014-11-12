//
//  PEG_TestUnitaireViewController.m
//  PEG
//
//  Created by HorsMedia1 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_TestUnitaireViewController.h"
#import "PEG_GetBeanMobilitePegaseRequest.h"
//#import "PEG_BeanMobilitePegase.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_MobilitePegaseService.h"
#import "PEG_FSuiviKilometre.h"
#import "PEG_PickerViewController.h"
#import "PEG_ListeViewController.h"

@interface PEG_TestUnitaireViewController ()

@property (nonatomic,strong) NSNumber* nbLigneToSee;

@end

@implementation PEG_TestUnitaireViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _nbLigneToSee = [NSNumber numberWithInt:0];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.nbLigneToSee integerValue];

}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell* cell = nil;
    if (indexPath.section==0)
    {
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        }
        
        //cell.textLabel.text=[NSString stringWithFormat:@"Presentoir - %d",indexPath.row ] ;
        
        //cell.textLabel.text= ((PEG_BeanSuiviKMUtilisateur*)[self.g_BeanMobilitePegase.ListSuiviKMUtilisateur objectAtIndex:0]).Matricule;

    }
    return cell;
    
    
}
- (IBAction)BtnChargerBean_Click:(id)sender {
    
/* test commenté pm 11/2014 GetBeanMobilitePegaseWithObserver n'est pas appelé dans l'application
 NSString* v_Matricule = [[NSString alloc] init];
    v_Matricule = @"00000619";
    NSDate* v_Date = [NSDate date];
    
    [[PEG_FMobilitePegase CreateMobilitePegaseService] GetBeanMobilitePegaseWithObserver:self andMatricule:v_Matricule andDate:v_Date];
    //chargement
    //self.nbLigneToSee=[NSNumber numberWithInt:2];
    self.nbLigneToSee = [NSNumber numberWithInt:1];
 */
    
}

- (IBAction)BtnSave_Click:(id)sender {
    
    //[[PEG_FMobilitePegase  CreateMobilitePegaseService ] SaveBeanMobilitePegaseInFile :self.g_BeanMobilitePegase] ;
    
    //PEG_BeanMobilitePegase * v_PEG_BeanMobilitePegase=[[PEG_FMobilitePegase  CreateMobilitePegaseService ] GetBeanMobilitePegaseFromFile];
    //[v_PEG_BeanMobilitePegase release];
}


- (IBAction)btnPicker_Click:(id)sender {
    
    
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    //[pickerController setField:_field];
    
    SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
    
    [values setValue:@"Lib1" forKey:@"val1"];
    [values setValue:@"Lib2" forKey:@"val2"];
    [values setValue:@"Lib3" forKey:@"val3"];
    
    SPIROrderedDictionary *values2 = [[SPIROrderedDictionary alloc] init];
    
    [values2 setValue:@"Lib21" forKey:@"val21"];
    [values2 setValue:@"Lib22" forKey:@"val22"];
    [values2 setValue:@"Lib23" forKey:@"val23"];

    NSArray* v_array = [[NSArray alloc] initWithObjects:values,values2, nil];
    
    NSArray* v_arrayValueSelected = [[NSArray alloc]initWithObjects:@"val3",@"val22", nil];
    
    [pickerController initWithListValue:v_array andListValueSelected:v_arrayValueSelected andNbColonnesToSee:2];
    
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
                         
                     }];
    

    
}

- (void)formPicker:(PEG_PickerViewController *)_formPicker didChoose:(NSMutableArray *)values
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

}
- (IBAction)btnListe_TouchUpInside:(id)sender {
    
    PEG_ListeViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_ListeViewController"];
    //[pickerController setField:_field];
    
    SPIROrderedDictionary *values = [[SPIROrderedDictionary alloc] init];
    
    [values setValue:@"Lib1" forKey:@"val1"];
    [values setValue:@"Lib2" forKey:@"val2"];
    [values setValue:@"Lib3" forKey:@"val3"];
    
    pickerController.listValues = values;
    pickerController.valueSelected = @"val1";
    
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
                         
                     }];
    

}

-(void) formListePicker:(PEG_ListeViewController *)_formListePicker didChoose:(NSString *)value
{
    PEG_ListeViewController *pickerController = [self.childViewControllers objectAtIndex:0];
    
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

}

#pragma mark interface PEG_BeanMobilitePegaseDataSource
-(void) fillFinishedBeanMobilitePegase
{
    //DLog(@"=>self.g_BeanMobilitePegase: %@ ",self.g_BeanMobilitePegase);
    [self loadView];
}

@end
