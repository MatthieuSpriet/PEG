//
//  PEG_ViewDtlAdministratifViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 10/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ViewDtlAdministratifViewController.h"
//#import "PEG_BeanLieu.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_DtlAdminViewCell.h"
#import "PEG_AdminChoixHoraireViewController.h"
#import "PEGAppDelegate.h"

@interface PEG_ViewDtlAdministratifViewController ()

@property (strong, nonatomic) BeanLieu* BeanLieu;

@property (strong, nonatomic) IBOutlet UITableView *MyTableView;



@end

@implementation PEG_ViewDtlAdministratifViewController

#pragma mark - Init
-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
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
	  
    
    
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.MyTableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    if(indexPath.section==0){
        
        cellIdentifier=@"cellEnteteDtlAdmin";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_DtlAdminViewCell* cellDtl = (PEG_DtlAdminViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_DtlAdminViewCell" bundle:nil];
            cellDtl = (PEG_DtlAdminViewCell*) c.view;
        }
        
        
        cellDtl.LieuUILabel.text = [NSString stringWithFormat:@"%@ - %@ ",[self.BeanLieu.idLieu stringValue],self.BeanLieu.liNomLieu];
        [cellDtl.Livrable247UISwitch setOn:[[PEG_FMobilitePegase CreateLieu] IsLivrable247:self.BeanLieu]];
        
        return cellDtl;
    }
    
    if(indexPath.section==1){
        
        cellIdentifier=@"cellHoraireDtlAdmin";
        
        PEG_DtlAdminViewCell* cellDtl = (PEG_DtlAdminViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_DtlAdminViewCell" bundle:nil];
            cellDtl = (PEG_DtlAdminViewCell*) c.view;
        }
        
        cellDtl.HorairesUILabel.text =  [[[PEG_FMobilitePegase CreateLieu] GetHorairesComplet:self.BeanLieu] objectAtIndex:indexPath.item];
        return cellDtl;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 70;
    }
    if(indexPath.section==1){
        return 40;
    }
    return 0;
}



-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[PEG_FMobilitePegase CreateLieu] IsLivrable247:self.BeanLieu]){
        return 1;
    }else{
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return [[PEG_FMobilitePegase CreateLieu] GetHorairesComplet:self.BeanLieu].count;
        //return self._ListeChoix.count;
    }
    
    return 0;
}



#pragma mark - Action
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"pushChoixHoraire"])
    {
        NSIndexPath* v_index = [self.MyTableView  indexPathForSelectedRow];
        BeanHoraire* v_BH = [[PEG_FMobilitePegase CreateLieu] GetBeanHoraireByIndex:v_index.row andLieu:self.BeanLieu];
        [((PEG_AdminChoixHoraireViewController*)[segue destinationViewController]) setDetailItemForJour:v_BH.jour andAMDebut:v_BH.aMDebut andAMFin:v_BH.aMFin andPMDebut:v_BH.pMDebut andPMFin:v_BH.pMFin andLieu:self.BeanLieu];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // [super navigationController:navigationController willShowViewController animated:]
    
    [self.MyTableView reloadData];
}
- (IBAction)Livrable247Changed:(id)sender {
    
    UISwitch* myswitch =(UISwitch*)sender;
    [[PEG_FMobilitePegase CreateLieu] UpdateLivrable247:self.BeanLieu andLivrable247:[myswitch isOn]];
     self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:self.BeanLieu.idLieu];
    
    [self.MyTableView reloadData];
}

- (void)ShowHoraireSemaine
{    
    PEG_AdminChoixHoraireViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_AdminChoixHoraireViewController"];
    
    [pickerController setContextSemaineComplete:self.BeanLieu];
    
    [self.navigationController pushViewController:pickerController animated:YES];
}

@end
