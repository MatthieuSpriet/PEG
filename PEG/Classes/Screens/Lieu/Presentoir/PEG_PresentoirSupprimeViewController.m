//
//  PEG_PresentoirSupprimeViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 28/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_PresentoirSupprimeViewController.h"
#import "PEG_PresentoirSupprimeCell.h"
#import "PEG_FMobilitePegase.h"
#import "BeanPresentoir.h"
#import "PEG_EnumFlagMAJ.h"

@interface PEG_PresentoirSupprimeViewController ()
@property (strong, nonatomic) BeanPresentoir* _BeanPresentoir;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL IsLieuInactif;
@property (assign, nonatomic) BOOL IsSupprime;
@end

@implementation PEG_PresentoirSupprimeViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setDetailItem:(NSNumber*)p_IdPresentoir{
    self._BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
    
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if([self._BeanPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
    if([[PEG_FMobilitePegase CreateLieu] GetNbPresentoir:self._BeanPresentoir.parentLieu]<=1 && self.IsSupprime)
    {
        return 2;
    }else{
        return 1;
    }
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    if(indexPath.row ==0){
        
        cellIdentifier=@"CellPresentoirSupp";
        PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        //if([self._BeanPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted])
        if(self.IsSupprime)
        {
            [cellDtl.SupprimeUISwitch setOn:YES];
        }
        
        return cellDtl;
    }
    if(indexPath.row ==1){
        
        
        //if dernier lieu
        cellIdentifier=@"CellPresentoirLieuInactif";
        PEG_PresentoirSupprimeCell* cellDtl = (PEG_PresentoirSupprimeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        return cellDtl;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
    
}
- (IBAction)supprimerChanged:(id)sender {
    UISwitch* v_switch=(UISwitch*)sender;
    if(v_switch.isOn){
        self.IsSupprime = true;
        /*self._BeanPresentoir.flagMAJ =PEG_EnumFlagMAJ_Deleted;
        if(![[PEG_FMobilitePegase CreateLieu] GetNbPresentoir:self._BeanPresentoir.parentLieu]==0){
            [self.navigationController popViewControllerAnimated:YES];
        }*/

    }else{
        self.IsSupprime = false;
        //self._BeanPresentoir.flagMAJ =PEG_EnumFlagMAJ_Unchanged;
    }
    [self.tableView reloadData];
}
- (IBAction)LieuInactifChanged:(id)sender {
    
    UISwitch* v_switch=(UISwitch*)sender;
    if(v_switch.isOn){
        self.IsLieuInactif = true;
    }else{
        self.IsLieuInactif = false;
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
    //[self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
