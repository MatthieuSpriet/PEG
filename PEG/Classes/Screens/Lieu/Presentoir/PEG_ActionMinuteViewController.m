//
//  PEG_ActionMinuteViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 16/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ActionMinuteViewController.h"
#import "PEG_ActionReplaceViewController.h"
#import "BeanPresentoir.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_ActionMinuteCell.h"

@interface PEG_ActionMinuteViewController ()
@property (strong, nonatomic) IBOutlet UITableView *MyTableView;

@end

@implementation PEG_ActionMinuteViewController

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
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


- (IBAction)Okclicked:(id)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(formActionMinuteFinished:)])
	{
		[self.delegate formActionMinuteFinished:self];
	}
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pushDeplaceItem"])
    {
        [((PEG_ActionReplaceViewController*)[segue destinationViewController]) setDetailItem:self._IdPresentoir];
        
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEG_ActionMinuteCell *cell;
    
    if(indexPath.row==0){
        
        static NSString *CellIdentifier = @"cellControle";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.IdPresentoir = [self._IdPresentoir intValue];
        cell.IsControlVisuel = [[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirControleVisuelByIdPresentoir:self._IdPresentoir];
        [cell SetValue];
    }
    
    if(indexPath.row==1){
        
        static NSString *CellIdentifier = @"cellNettoye";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.IdPresentoir = [self._IdPresentoir intValue];
        cell.IsNettoye = [[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirNettoyeByIdPresentoir:self._IdPresentoir];
        [cell SetValue];
        
    }
    if(indexPath.row==2){
        
        static NSString *CellIdentifier = @"cellReplace";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.IdPresentoir = [self._IdPresentoir intValue];
        cell.IsReplace = [[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirReplaceByIdPresentoir:self._IdPresentoir];

        if([[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirDeplaceByIdPresentoir:self._IdPresentoir]){
            cell.userInteractionEnabled=NO;
            
        }else{
            cell.userInteractionEnabled=YES;
        }
        [cell SetValue];
        
    }
    if(indexPath.row==3){
        
        static NSString *CellIdentifier = @"cellDeplace";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.IdPresentoir = [self._IdPresentoir intValue];
        if([[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirReplaceByIdPresentoir:self._IdPresentoir]){
            cell.userInteractionEnabled=NO;
        }else{
            cell.userInteractionEnabled=YES;
        }
        
        
    }
    return cell;
}

- (IBAction)ControleVisuelChange:(id)sender {
    UISwitch* v_uiswitch=(UISwitch*)sender;
    [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirControleVisuelByIdPresentoir:self._IdPresentoir andFait:v_uiswitch.isOn];
    [self.MyTableView reloadData];
}
- (IBAction)NettoyeChange:(id)sender {
    UISwitch* v_uiswitch=(UISwitch*)sender;
    [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirNettoyeByIdPresentoir:self._IdPresentoir andFait:v_uiswitch.isOn];
    [self.MyTableView reloadData];
}
- (IBAction)ReplaceChange:(id)sender {
    UISwitch* v_uiswitch=(UISwitch*)sender;
    [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirReplaceByIdPresentoir:self._IdPresentoir andFait:v_uiswitch.isOn];
    [self.MyTableView reloadData];
}




- (void)viewDidUnload {
    [self setMyTableView:nil];
    [super viewDidUnload];
}
@end
