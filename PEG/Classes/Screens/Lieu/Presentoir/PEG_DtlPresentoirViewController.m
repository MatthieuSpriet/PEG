//
//  PEG_DtlPresentoirViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_DtlPresentoirViewController.h"
#import "PEG_DtlQuantiteMaterielViewController.h"

@interface PEG_DtlPresentoirViewController ()
@property (retain, nonatomic) NSNumber* _IdPresentoir;
@end

@implementation PEG_DtlPresentoirViewController

@synthesize tabBarController;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
- (void)viewDidLoad
{
    [super viewDidLoad];
//
   // UITabBarController* tabBarController = [[UITabBarController alloc] init];
    
    
//    UIViewController* v_UIVC0 = [self.storyboard instantiateViewControllerWithIdentifier:@"DeletePresentoirView"];
//    UIViewController* v_UIVC1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangePresentoirView"];
//    UIViewController* v_UIVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"QuantiteMaterielView"];
//    [((PEG_DtlQuantiteMaterielViewController*)v_UIVC2) setDetailItem:self._IdPresentoir];
//    
//    
//    self.tabBarController.viewControllers = [NSArray arrayWithObjects:v_UIVC0,v_UIVC1,v_UIVC2, nil];
//    [[self tabBarController] setSelectedIndex:1];
//    
//    self.tabBarController.delegate = self;
    
    
    //[self presentModalViewController:self.tabBarController animated:NO];
    //[self.navigationController pushViewController:tabBarController animated:YES];

    
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    //    if(self = [super initWithCoder:aDecoder])
    //    {
    //        // Do something
    //    }
    return self;
}


-(void) setDetailItem:(NSNumber*)p_IdPresentoir{
    self._IdPresentoir=p_IdPresentoir;
    
    UIViewController* v_UIVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"QuantiteMaterielView"];
    [((PEG_DtlQuantiteMaterielViewController*)v_UIVC2) setDetailItem:self._IdPresentoir];
    

}

#pragma mark Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([[segue identifier] isEqualToString:@"pushQuantiteMateriel"])
    {
                [((PEG_DtlQuantiteMaterielViewController*)[segue destinationViewController]) setDetailItem:self._IdPresentoir];
        //        NSIndexPath* v_index = [self.listeTourneeUITableView indexPathForSelectedRow];
        //        PEG_BeanTournee* v_Tournee = [self.ListTourneeDate objectAtIndex:v_index.row];
                //[((PEG_DtlQuantiteMaterielViewController*)[segue destinationViewController]) setDetailItem:v_Tournee.IdTournee];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.section==0){
        
        static NSString *CellIdentifier = @"cellVole";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    if(indexPath.section==1){
        
        static NSString *CellIdentifier = @"cellSupprime";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    }
    if(indexPath.section==2){
        
        static NSString *CellIdentifier = @"cellChange";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    }
    if(indexPath.section==3){
        
        static NSString *CellIdentifier = @"cellQuantite";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    }
    return cell;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
{
       return YES;
}




- (void)dealloc {
    [_TabBar release];
    [super dealloc];
}
@end
