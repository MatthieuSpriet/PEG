//
//  PEG_ListeLieuViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 13/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

//#import "PEGAppDelegate.h"

#import "PEG_ListeLieuViewController.h"
#import "PEG_ListeLieuCell.h"
#import "PEG_BeanPointDsgn.h"
#import "PEG_FMobilitePegase.h"
#import "BeanMobilitePegase.h"
#import "BeanPresentoir.h"
#import "PEG_FTechnical.h"
#import "PEG_DtlLieuxViewController.h"
#import "PEG_DtlAdresseLieuViewController.h"
#import "MBProgressHUD.h"
#import "PEG_BeanPresentoirParution.h"
#import "PEG_EnumFlagMAJ.h"
#import "BeanEdition.h"
#import "PEGSession.h"

@interface PEG_ListeLieuViewController ()

@property (nonatomic,strong) NSMutableArray* ListBeanPointDsgn;
@property (nonatomic,strong) NSArray* ListBeanPointFiltreDsgn;
@property (strong, nonatomic) IBOutlet UITableView *ListeLieuUITableView;

@property (nonatomic,strong) PEG_BeanPoint* BeanPointActuel;
@property (strong, nonatomic) IBOutlet UITextField *DistanceUITextField;

@property (nonatomic,strong) NSString* ContextListe;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBarUISearchBar;

@end

@implementation PEG_ListeLieuViewController

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
    self.BeanPointActuel = [[PEG_BeanPoint alloc] init];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    [self initClavier];
    
    self.DistanceUITextField.text = @"200";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatedLocation:)
                                                 name:@"newLocationNotif"
                                               object:nil];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void) updatedLocation:(NSNotification*)notif {
    CLLocation* newLocation = (CLLocation*)[[notif userInfo] valueForKey:@"newLocationResult"];
    
    if([self.restorationIdentifier isEqualToString:@"LieuGPS"])
    {
        //CLLocation *newLocation = [locations lastObject];
        /*CLLocation *oldLocation;
        if (locations.count > 1) {
            oldLocation = [locations objectAtIndex:locations.count-2];
        } else {
            oldLocation = nil;
        }*/
        NSNumber* v_NewLong = [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude];
        NSNumber* v_NewLat = [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude];
        if((![self.BeanPointActuel.Long isEqualToNumber:v_NewLong]) || (![self.BeanPointActuel.Lat isEqualToNumber:v_NewLat]))
        {
            DLog(@"didUpdateToLocation %@ old(%@ %@)", newLocation,self.BeanPointActuel.Long,self.BeanPointActuel.Lat);
            self.BeanPointActuel.Long = v_NewLong;
            self.BeanPointActuel.Lat = v_NewLat;
            [self setListeItem];
            [self.ListeLieuUITableView reloadData];
        }
    }

}

/*- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if([self.restorationIdentifier isEqualToString:@"LieuGPS"])
    {
        CLLocation *newLocation = [locations lastObject];
        CLLocation *oldLocation;
        if (locations.count > 1) {
            oldLocation = [locations objectAtIndex:locations.count-2];
        } else {
            oldLocation = nil;
        }
        NSNumber* v_NewLong = [[NSNumber alloc] initWithDouble:newLocation.coordinate.longitude];
        NSNumber* v_NewLat = [[NSNumber alloc] initWithDouble:newLocation.coordinate.latitude];
        if((![self.BeanPointActuel.Long isEqualToNumber:v_NewLong]) || (![self.BeanPointActuel.Lat isEqualToNumber:v_NewLat]))
        {
            DLog(@"didUpdateToLocation %@ from %@ old(%@ %@)", newLocation, oldLocation,self.BeanPointActuel.Long,self.BeanPointActuel.Lat);
            self.BeanPointActuel.Long = v_NewLong;
            self.BeanPointActuel.Lat = v_NewLat;
            [self setListeItem];
            [self.ListeLieuUITableView reloadData];
        }
    }
}
- (void)startGPSStandardUpdates
{
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}*/

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Gestion des coordonnées GPS
    //PEGAppDelegate* appDelegate = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    
//    [self startGPSStandardUpdates];
    //self.locationManager = appDelegate.principalLocationManager;
    //self.locationManager.delegate = self;
    //[self.locationManager startUpdatingLocation];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Chargement des lieux";
    [hud show:YES];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setListeItem];    //  main thread, coredata ne supporte pas multithread
        [hud hide:YES];
    });
}

-(void)setContextPointParCriteredeRecherche{
    self.navigationItem.title=@"Recherche";
    self.ContextListe = @"Recherche";
}
-(void)setContextPointAlerte{
    self.navigationItem.title=@"Lieux en alertes";
    self.ContextListe = @"Alertes";
    
}
-(void)setContextProspection{
    self.navigationItem.title=@"Réactivation";
    self.ContextListe = @"Activation";
}

- (void) viewWillDisappear:(BOOL)animated
{
    self.locationManager.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:[NSString stringWithFormat:@"%@ - Warning Memory",NSStringFromClass([self class])] andExparams:[NSString stringWithFormat:@"Matricule : %@",[[PEGSession sharedPEGSession] matResp]]];
}

-(NSNumber*) GetDistanceForFiltre
{
    NSNumber* v_distance;
    if(![self.DistanceUITextField.text isEqual:(@"")])
    {
        v_distance = [[NSNumber alloc] initWithInt:[self.DistanceUITextField.text intValue]];
    }
    else
    {
        v_distance = [[NSNumber alloc] initWithInt:200];
    }
    
    return v_distance;
}

-(void) setListeItem
{
    // [NSThread sleepForTimeInterval:5];
    
    PEG_BeanPointDsgn* v_NewBeanPoint = [[PEG_BeanPointDsgn alloc] init];
    PEG_BeanPoint* v_PointLieu = [[PEG_BeanPoint alloc] init];
    
    NSArray* v_ListLieu = nil;
    self.ListBeanPointDsgn = nil;
    self.ListBeanPointDsgn = [[NSMutableArray alloc] init];
    
    if([self.restorationIdentifier isEqualToString:@"LieuGPS"])
    {
        v_ListLieu = [[PEG_FMobilitePegase CreateLieu] GetListeBeanLieuByDistance:[self GetDistanceForFiltre] AndPoint:[PEG_FTechnical GetCoordActuel]];
    }
    else if([self.restorationIdentifier isEqualToString:@"LieuRecherche"])
    {
        if([self.ContextListe isEqualToString:@"Recherche"])
        {
            v_ListLieu = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuActif];
        }
        else if ([self.ContextListe isEqualToString:@"Alertes"])
        {
            v_ListLieu = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuEnAlerte];
        }
        else if([self.ContextListe isEqualToString:@"Activation"])
        {
            v_ListLieu = [[PEG_FMobilitePegase CreateLieu] GetAllBeanLieuInactif];
        }
    }
    
    for (BeanLieu* v_ItemLieu in v_ListLieu)
    {
        int v_PresentoirNumber = 1;
        v_PointLieu = [v_PointLieu initWithLong:v_ItemLieu.coordXpda AndLat:v_ItemLieu.coordYpda];
        v_NewBeanPoint.IdLieu = v_ItemLieu.idLieu;
        v_NewBeanPoint.NomPoint = v_ItemLieu.liNomLieu;
        //v_NewBeanPoint.NbMetre =  [[PEG_FMobilitePegase CreateLieu] GetDistanceMetreEntreDeuxPoint1:v_PointLieu AndPoint2:self.BeanPointActuel];
        v_NewBeanPoint.NbMetre =  [[PEG_FMobilitePegase CreateLieu] GetDistanceMetreEntreDeuxPoint1:v_PointLieu AndPoint2:[PEG_FTechnical GetCoordActuel]];
        v_NewBeanPoint.NbSemaine = [PEG_FTechnical GetSemaineEntreDeuxDatesWithDate1:v_ItemLieu.dateDerniereVisite AndDate2:[NSDate date]];
        //v_NewBeanPoint.IsLieuAlerte = ([PEG_FTechnical GetNbJourEntreDeuxDatesWithDate1:v_ItemLieu.dateDerniereVisite AndDate2:[NSDate date]] > 60);
        v_NewBeanPoint.IsLieuAlerte = [[PEG_FMobilitePegase CreateLieu] IsLieuEnAlerte:v_ItemLieu];
        v_NewBeanPoint.Adresse = [[[PEG_FMobilitePegase CreateLieu] GetAdresseComplete:v_ItemLieu] lowercaseString];
        
        v_NewBeanPoint.ListeTypePresentoirString = @"";
        v_NewBeanPoint.NombreTache =[[NSNumber alloc] initWithInt:0];
        
        for(BeanPresentoir* v_ItemPresentoir in v_ItemLieu.listPresentoir)
        {
            if (![v_ItemPresentoir.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Deleted]){
                
                if([v_NewBeanPoint.ListeTypePresentoirString isEqualToString:@""])
                {
                    v_NewBeanPoint.ListeTypePresentoirString = v_ItemPresentoir.tYPE;
                }
                else
                {
                    v_NewBeanPoint.ListeTypePresentoirString = [NSString stringWithFormat:@"%@,%@",v_NewBeanPoint.ListeTypePresentoirString, v_ItemPresentoir.tYPE ];
                }
                v_NewBeanPoint.NombreTache = [[NSNumber alloc] initWithInt:[v_NewBeanPoint.NombreTache integerValue] + [v_ItemPresentoir.listTache count]];
                
                //On ne traite le reste qu'en mode GPS
                if([self.restorationIdentifier isEqualToString:@"LieuGPS"])
                {
                    for (PEG_BeanPresentoirParution* v_BPP in [[PEG_FMobilitePegase CreatePresentoir] GetListPresentoirParutionByPresentoir:v_ItemPresentoir])
                    {
                        
                        //BeanParution* v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_ItemPresentoir.idParution];
                        BeanParution* v_BeanParution = nil;
                        /*if(v_ItemPresentoir.idParution != nil && ![v_ItemPresentoir.idParution isEqualToNumber:[[NSNumber alloc] initWithInt:0]])
                         {*/
                        v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_BPP.Parution.id];
                        /* }
                         else{
                         v_BeanParution = [[PEG_FMobilitePegase CreatePresentoir] GetParutionEnCoursByPresentoir:v_ItemPresentoir];
                         v_ItemPresentoir.idParution = v_BeanParution.id;
                         }*/
                        if(v_PresentoirNumber == 1)
                        {
                            v_NewBeanPoint.IdPresentoir = v_ItemPresentoir.id;
                            //v_NewBeanPoint.NombreTache = [[NSNumber alloc] initWithInt:[v_ItemPresentoir.listTache count]];
                            
                            v_NewBeanPoint.TypePresentoir = v_ItemPresentoir.tYPE;
                            if(v_BeanParution != nil)
                            {
                                v_NewBeanPoint.Parution = v_BeanParution.libelleEdition;
                                v_NewBeanPoint.QuantiteDistribuee = [[PEG_FMobilitePegase CreateLieu] GetQteDistribueeByIdPresentoir:v_ItemPresentoir.idPointDistribution andIdParution:v_BeanParution.id];
                                v_NewBeanPoint.QuantiteRetour = [[PEG_FMobilitePegase CreateLieu] GetQteRetourByIdPresentoir:v_ItemPresentoir.idPointDistribution andIdParution:v_BeanParution.idParutionPrec];
                            }
                            v_NewBeanPoint.TypePresentoir2 = @"";
                            v_NewBeanPoint.Parution2 = @"";
                            v_NewBeanPoint.QuantiteDistribuee2 = nil;
                            v_NewBeanPoint.QuantiteRetour2 = nil;
                            v_NewBeanPoint.PlusDeTroisPresentoir = false;
                            //On n'affiche qu'une fois le presentoir par parution
                            //if(v_BPP.IsFirstPres)
                            //{
                            //    v_NewBeanPoint.ListeTypePresentoirString = v_ItemPresentoir.tYPE;
                            //}
                            v_PresentoirNumber++;
                        }
                        else if(v_PresentoirNumber == 2)
                        {
                            //v_NewBeanPoint.NombreTache = [[NSNumber alloc] initWithInt:[v_NewBeanPoint.NombreTache integerValue] + [v_ItemPresentoir.listTache count]];
                            //On n'affiche qu'une fois le presentoir par parution
                            if(v_BPP.IsFirstPres)
                            {
                                v_NewBeanPoint.TypePresentoir2 = v_ItemPresentoir.tYPE;
                                //v_NewBeanPoint.ListeTypePresentoirString = [NSString stringWithFormat:@"%@,%@",v_NewBeanPoint.ListeTypePresentoirString, v_ItemPresentoir.tYPE ];
                            }
                            if(v_BeanParution != nil)
                            {
                                v_NewBeanPoint.Parution2 = v_BeanParution.libelleEdition;
                                
                                v_NewBeanPoint.QuantiteDistribuee2 = [[PEG_FMobilitePegase CreateLieu] GetQteDistribueeByIdPresentoir:v_ItemPresentoir.idPointDistribution andIdParution:v_BeanParution.id];
                                v_NewBeanPoint.QuantiteRetour2 = [[PEG_FMobilitePegase CreateLieu] GetQteRetourByIdPresentoir:v_ItemPresentoir.idPointDistribution andIdParution:v_BeanParution.idParutionPrec];
                            }
                            v_PresentoirNumber++;
                        }
                        else
                        {
                            //v_NewBeanPoint.NombreTache = [[NSNumber alloc] initWithInt:[v_NewBeanPoint.NombreTache integerValue] + [v_ItemPresentoir.listTache count]];
                            v_NewBeanPoint.PlusDeTroisPresentoir = true;
                            //On n'affiche qu'une fois le presentoir par parution
                            //if(v_BPP.IsFirstPres)
                            //{
                            //    v_NewBeanPoint.ListeTypePresentoirString = [NSString stringWithFormat:@"%@,%@",v_NewBeanPoint.ListeTypePresentoirString, v_ItemPresentoir.tYPE ];
                            //}
                            break;
                        }
                    }
                }
            }
        }
        if(v_NewBeanPoint.IdLieu != nil)
        {
            [self.ListBeanPointDsgn addObject:v_NewBeanPoint];
            v_NewBeanPoint = [[PEG_BeanPointDsgn alloc] init];
        }
    }
    if([self.restorationIdentifier isEqualToString:@"LieuGPS"])
    {
        [self.ListBeanPointDsgn sortUsingSelector:@selector(compareMetre:)];
    }
    else if([self.restorationIdentifier isEqualToString:@"LieuRecherche"])
    {
        [self.ListBeanPointDsgn sortUsingSelector:@selector(compareNomAdresse:)];
        
        if(self.SearchBarUISearchBar.text != nil && ![self.SearchBarUISearchBar.text isEqualToString:@""])
        {
            [self filterContentForSearchText:self.SearchBarUISearchBar.text scope:nil];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }
    
    
    [self.ListeLieuUITableView reloadData];
    // [hud  hide:YES];

}


#pragma mark Gestion de la table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     //Setter en dur pour avoir la bonne taille lors de la recherche
 return 70.;
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.ListBeanPointDsgn != nil)
    {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [self.ListBeanPointFiltreDsgn count];
            
        } else {
            return [self.ListBeanPointDsgn count];
        }
    }
    else return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"cellListeLieu";
    
    PEG_ListeLieuCell* cellDtl = (PEG_ListeLieuCell *) [self.ListeLieuUITableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cellDtl == nil)
    {
        //UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_ListeLieuCell" bundle:nil];
        //cellDtl = (PEG_ListeLieuCell*) c.view;
        cellDtl = [[PEG_ListeLieuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    PEG_BeanPointDsgn* v_BeanPointDsgn;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        v_BeanPointDsgn = [self.ListBeanPointFiltreDsgn objectAtIndex:indexPath.item];
    }
    else
    {
        v_BeanPointDsgn = [self.ListBeanPointDsgn objectAtIndex:indexPath.item];
    }
    /*NSString* v_NomPoint = v_BeanPointDsgn.NomPoint;
     NSNumber* v_NombreTache = v_BeanPointDsgn.NombreTache;
     NSString* v_TypePresentoir = v_BeanPointDsgn.TypePresentoir;
     NSString* v_Parution = v_BeanPointDsgn.Parution;
     NSString* v_TypePresentoir2 = v_BeanPointDsgn.TypePresentoir2;
     NSString* v_Parution2 = v_BeanPointDsgn.Parution2;*/
    
    //[cellDtl initDataWithNomPoint:v_NomPoint andTypePresentoir1:v_TypePresentoir andParution1:v_Parution andTypePresentoir2:v_TypePresentoir2 andParution2:v_Parution2 andNbTache:v_NombreTache];
    [cellDtl initDataWithPointDsg:v_BeanPointDsgn];
    if(v_BeanPointDsgn.IsLieuAlerte)
    {
        UIView* bview = [[UIView alloc] init];
        bview.backgroundColor = [[UIColor alloc] initWithRed:0.5 green:0 blue:0 alpha:0.3];
        cellDtl.backgroundView = bview;
    }
    else
    {
        cellDtl.backgroundView = nil;
    }
    return cellDtl;
    
}

#pragma mark Gestion du clavier
-(void) initClavier
{
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPadDistance)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadDistance)],
                           nil];
    [numberToolbar sizeToFit];
    self.DistanceUITextField.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPadDistance{
    [self.DistanceUITextField resignFirstResponder];
}

-(void)doneWithNumberPadDistance{
    //NSString *numberFromTheKeyboard = self.QuantiteDistribueeUITextField.text;
    [self.DistanceUITextField resignFirstResponder];
    [self setListeItem];
    [self.ListeLieuUITableView reloadData];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self performSegueWithIdentifier:@"pushListLieuToDetailLieu" sender:self];
}

#pragma mark Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pushListLieuToDetailLieu"])
    {
        NSIndexPath *indexPath = nil;
        PEG_BeanPointDsgn* v_PointDsgn;
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            v_PointDsgn = [self.ListBeanPointFiltreDsgn objectAtIndex:indexPath.row];
            
        } else {
            indexPath = [self.ListeLieuUITableView indexPathForSelectedRow];
            v_PointDsgn = [self.ListBeanPointDsgn objectAtIndex:indexPath.row];
        }
        [((PEG_DtlLieuxViewController*)[segue destinationViewController]) setDetailItem:v_PointDsgn.IdLieu];
    }
    if([[segue identifier] isEqualToString:@"pushListLieuToCreationLieu"])
    {
        BeanLieu * v_BeanLieu=[[PEG_FMobilitePegase CreateLieu] CreateBeanLieu];
        [((PEG_DtlAdresseLieuViewController*)[segue destinationViewController]) setDetailItemForCreation:v_BeanLieu.idLieu];
    }
}

#pragma mark Search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    /*NSPredicate *resultPredicate = [NSPredicate
     predicateWithFormat:@"SELF contains[cd] %@",
     searchText];*/
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"NomPoint CONTAINS[cd] %@ OR Adresse CONTAINS[cd] %@ ", searchText,searchText ];
    
    self.ListBeanPointFiltreDsgn = [self.ListBeanPointDsgn filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



@end
