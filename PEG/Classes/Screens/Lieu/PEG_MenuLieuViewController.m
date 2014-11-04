//
//  PEG_MenuLieuViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 18/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_MenuLieuViewController.h"
#import "PEG_ListeLieuViewController.h"
#import "MBProgressHUD.h"

@interface PEG_MenuLieuViewController ()
@property (strong, nonatomic) MBProgressHUD *hud ;
@end

@implementation PEG_MenuLieuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.title = @"Mes Lieux";
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void) viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section==0){
        
        static NSString *CellIdentifier = @"cellPoint";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    if(indexPath.section==1){
        
        static NSString *CellIdentifier = @"cellPointCritere";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    }
    if(indexPath.section==2){
        
        static NSString *CellIdentifier = @"cellPointAlertes";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    }
    if(indexPath.section==3){
        
        static NSString *CellIdentifier = @"cellProspection";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
    }
    if(indexPath.section==4){
        
        static NSString *CellIdentifier = @"cellSynchronisation";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 40;
    }
    if(indexPath.section==1){
        return 80;
    }
    if(indexPath.section==2){
        return 40;
    }
    if(indexPath.section==3){
        return 40;
    }
    if(indexPath.section==4){
        return 50;
    }
    return 0;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if([[segue identifier] isEqualToString:@"PushPointParCriteredeRecherche"])
    {
        [((PEG_ListeLieuViewController*)[segue destinationViewController]) setContextPointParCriteredeRecherche];
    }
    if([[segue identifier] isEqualToString:@"PushPointAlertes"])
    {
        [((PEG_ListeLieuViewController*)[segue destinationViewController]) setContextPointAlerte];
    }
    if([[segue identifier] isEqualToString:@"PushProspection"])
    {
        [((PEG_ListeLieuViewController*)[segue destinationViewController]) setContextProspection];
    }
   
}




@end
