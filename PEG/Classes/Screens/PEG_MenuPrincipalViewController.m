//
//  PEG_MenuPrincipalViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 18/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_MenuPrincipalViewController.h"
#import "PEG_MenuPrincipalCell.h"
#import "PEG_ListeTourneesViewController.h"

@interface PEG_MenuPrincipalViewController ()

@end

@implementation PEG_MenuPrincipalViewController

- (id)initWithCoder:(NSCoder*)aDecoder
{
//    if(self = [super initWithCoder:aDecoder])
//    {
//        // Do something
//    }
    return self;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
// 
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.hidesBackButton = YES;
//
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    
    if(indexPath.section==0){
        cellIdentifier=@"cellTourneePreparee";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_MenuPrincipalCell* cellDtl = (PEG_MenuPrincipalCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_MenuPrincipalCell" bundle:nil];
            cellDtl = (PEG_MenuPrincipalCell*) c.view;
        }
        //   cellDtl.LieuUILabel.text = [self.BeanLieu.IdLieu stringValue];
        //   [cellDtl.Livrable247UISwitch setOn:[self.BeanLieu IsLivrable247]];
        
        return cellDtl;
    }
    if(indexPath.section==1){
        cellIdentifier=@"CellSaisirCompteRendu";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_MenuPrincipalCell* cellDtl = (PEG_MenuPrincipalCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_MenuPrincipalCell" bundle:nil];
            cellDtl = (PEG_MenuPrincipalCell*) c.view;
        }
        //   cellDtl.LieuUILabel.text = [self.BeanLieu.IdLieu stringValue];
        //   [cellDtl.Livrable247UISwitch setOn:[self.BeanLieu IsLivrable247]];
        
        return cellDtl;
    }
    if(indexPath.section==2){
        cellIdentifier=@"cellMesLieux";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_MenuPrincipalCell* cellDtl = (PEG_MenuPrincipalCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_MenuPrincipalCell" bundle:nil];
            cellDtl = (PEG_MenuPrincipalCell*) c.view;
        }
        //   cellDtl.LieuUILabel.text = [self.BeanLieu.IdLieu stringValue];
        //   [cellDtl.Livrable247UISwitch setOn:[self.BeanLieu IsLivrable247]];
        
        return cellDtl;
    }
    if(indexPath.section==3){
        cellIdentifier=@"cellMesTaches";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_MenuPrincipalCell* cellDtl = (PEG_MenuPrincipalCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_MenuPrincipalCell" bundle:nil];
            cellDtl = (PEG_MenuPrincipalCell*) c.view;
        }
        //   cellDtl.LieuUILabel.text = [self.BeanLieu.IdLieu stringValue];
        //   [cellDtl.Livrable247UISwitch setOn:[self.BeanLieu IsLivrable247]];
        
        return cellDtl;
    }
    
    return nil;
}



-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return 1;

}
- (IBAction)SynchroClicked:(id)sender {
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	// Créer un tabBarViewController
	tabBarController = [[UITabBarController alloc] init];
    
	// Créer une vue 1 et affecter
	PEG_ListeTourneesViewController *v1 = [[PEG_ListeTourneesViewController alloc] initWithNibName:@"ListTourneeView" bundle:nil];
    
	// Créer une vue image et affecter
	PEG_ListeTourneesViewController *v2 = [[PEG_ListeTourneesViewController alloc] initWithNibName:@"ListTourneeView" bundle:nil];
    
    
	tabBarController.viewControllers = [NSArray arrayWithObjects:v1, v2, nil];
    
    
	[self.window addSubview:tabBarController.view];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
