//
//  PEG_PresentoirChangeViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 29/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_PresentoirChangeViewController.h"
#import "PEG_FMobilitePegase.h"
#import "BeanPresentoir.h"

@interface PEG_PresentoirChangeViewController ()
@property (strong, nonatomic) BeanPresentoir* _BeanPresentoir;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PEG_PresentoirChangeViewController


-(void) setDetailItem:(NSNumber*)p_IdPresentoir{
    self._BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
    
}
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
}
- (void)viewWillAppear:(BOOL)animated {
        
    [super viewWillAppear:animated];
    [self showPickerNewPresentoir];
    
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

        return 1;

}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    
    
    if(indexPath.section ==0){
        if(indexPath.row ==0){
            cellIdentifier=@"CellChange";
            UITableViewCell* cellDtl = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if([self._BeanPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
//            {
//                [cellDtl.SupprimeUISwitch setOn:YES];
//            }
            
            return cellDtl;
        }
        
    }
    return nil;
}

// pm201402 commented out as the size defined in the storyboard is "default", ie 44
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//    
//}

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
        
        [[PEG_FMobilitePegase CreatePresentoir] RemplacerBeanPresentoirOnLieu:self._BeanPresentoir.parentLieu andBeanPresentoirOrigine:self._BeanPresentoir andType:v_Code];
       
            [self.navigationController popViewControllerAnimated:YES];
            //[self.DtlLieuUITableView reloadData];
        
    }
    else{
        
    }
    
}

@end
