//
//  PEG_ListeTachesViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 24/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListeTachesViewController.h"
#import "PEG_ListeTachesCell.h"
//#import "PEG_BeanMobilitePegase.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_DtlLieuxViewController.h"

@interface PEG_ListeTachesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *ListeTachesUITableView;
@property (strong, nonatomic) NSMutableArray* ListBeanLieu;
@end

@implementation PEG_ListeTachesViewController

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
    
    //[PEG_BeanMobilitePegase sharedInstance].;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //On refresh à chaque fois qu'on affiche
    self.ListBeanLieu=[[PEG_FMobilitePegase CreateLieu] GetListeBeanLieuWithTache];
    [self.ListeTachesUITableView reloadData];
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 43;
    }
    else if(indexPath.section==1)
    {
        return 53;
    }
    return 43;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0){
        return 3;
    }else if(section==1){
        return self.ListBeanLieu.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEG_ListeTachesCell *cell;
    
    if(indexPath.section==0){
        if(indexPath.row==0){
            static NSString *CellIdentifier = @"cellToutes";
            cell = (PEG_ListeTachesCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.ToutesTacheUILabel.text=[NSString stringWithFormat:@"%d",[[PEG_FMobilitePegase CreateLieu] GetNbTacheForAllLieu] ];
        }
        if(indexPath.row==1){
            static NSString *CellIdentifier = @"cellPhotos";
            cell= (PEG_ListeTachesCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.TachePhotosUILabel.text=[NSString stringWithFormat:@"%d",[[PEG_FMobilitePegase CreateLieu] GetNbTachePhotoForAllLieu] ];
            
        }
        if(indexPath.row==2){
            static NSString *CellIdentifier = @"cellMateriel";
            cell= (PEG_ListeTachesCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.TacheMaterielUILabel.text=[NSString stringWithFormat:@"%d",[[PEG_FMobilitePegase CreateLieu] GetNbTacheMaterielForAllLieu] ];
        }
        
    }
    
    if(indexPath.section==1){
        static NSString *CellIdentifier = @"cellEtablisement";
        cell= (PEG_ListeTachesCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        BeanLieu* v_BeanLieu=[self.ListBeanLieu objectAtIndex:indexPath.item];
        cell.NomEtablissementUILabel.text=v_BeanLieu.liNomLieu;
        cell.VilleUILabel.text=v_BeanLieu.ville;
        
        if([[PEG_FMobilitePegase CreateLieu] IsTacheAFaireMaterielOnLieu:v_BeanLieu.idLieu])
        {
            cell.MaterielUILabel.hidden = NO;
        }
        else{
            cell.MaterielUILabel.hidden = YES;
        }
        if([[PEG_FMobilitePegase CreateLieu] IsTacheAFairePhotoOnLieu:v_BeanLieu.idLieu])
        {
            cell.PhotoUILabel.hidden = NO;
        }
        else{
            cell.PhotoUILabel.hidden = YES;
        }
        if([[PEG_FMobilitePegase CreateLieu] IsTacheAFaireApporterPresentoirOnLieu:v_BeanLieu.idLieu])
        {
            cell.PresentoirUILabel.hidden = NO;
        }
        else{
            cell.PresentoirUILabel.hidden = YES;
        }
        
    }
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"PushTacheToDetailLieu"])
    {
        NSIndexPath *indexPath = nil;
        indexPath = [self.ListeTachesUITableView indexPathForSelectedRow];
        BeanLieu* v_BeanLieu = [self.ListBeanLieu objectAtIndex:indexPath.row];
       [((PEG_DtlLieuxViewController*)[segue destinationViewController]) setDetailItem:v_BeanLieu.idLieu];
    }
}

- (void)viewDidUnload {
    [self setListeTachesUITableView:nil];
    [super viewDidUnload];
}

#if 1	// pm201402 but it doesn't work
#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
	[searchBar resignFirstResponder];
}
#endif

@end
