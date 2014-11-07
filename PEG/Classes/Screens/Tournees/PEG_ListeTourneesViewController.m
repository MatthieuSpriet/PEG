//
//  PEG_ListeTourneesViewController.m
//  PEG
//
//  Created by HorsMedia1 on 17/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListeTourneesViewController.h"
#import "PEG_ListeTourneeCell.h"
#import "PEG_DatePickerViewController.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_ListePointTourneeViewController.h"
#import "PEGSession.h"
#import "PEG_FTechnical.h"
#import "PEG_FMobilitePegase.h"
#import "MBProgressHUD.h"
#import "PEGWebServices.h"

@interface PEG_ListeTourneesViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *dateSelectUIDatePicker;

@property (strong, nonatomic) IBOutlet UIButton *BtnDateDebutUIButton;

@property (strong, nonatomic) IBOutlet UILabel *labelDtDebutUILabel;

@property (strong, nonatomic) IBOutlet UILabel *labelDtFinUILabel;


@property (strong, nonatomic) IBOutlet UITableView *listeTourneeUITableView;

@property (assign, nonatomic) BOOL dataCharged;

@property (strong, nonatomic) MBProgressHUD *hud ;

@end

@implementation PEG_ListeTourneesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil    // pm0514 probably not called !
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataCharged= false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dateSelectUIDatePicker.hidden= true;
    self.navigationItem.title= @"Tournées préparées";     // pm1405 ???
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //TODO bouchon a supprimer
    //NSDate *v_Date = [PEG_FTechnical GetDateYYYYMMDDFromString:@"20130429"];
    //NSDate *v_Date = [NSDate date];

	//pm201402
	// NSCalendar *calendar = [[NSCalendar currentCalendar]initWithCalendarIdentifier:NSGregorianCalendar];
	NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps=[calendar components:NSWeekCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    comps.weekday = 2;
    //create date on week start
    NSDate* v_dateDeb=[calendar dateFromComponents:comps];
    NSDate* v_dateFin = [v_dateDeb dateByAddingTimeInterval:((3600*24)*6)];
    
    self.labelDtDebutUILabel.text = [self getDateSelected: v_dateDeb];
    self.dateDebut = [PEG_FTechnical GetDateYYYYMMDDFromDate:v_dateDeb];
    self.labelDtFinUILabel.text = [self getDateSelected: v_dateFin];
    self.dateFin = [PEG_FTechnical GetDateYYYYMMDDFromDate:v_dateFin];
    //Faire le chargement des données
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud .labelText=@"Chargement des tournées";
    [self.view addSubview:self.hud ];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.hud show:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadData];    // in main thread
        [self.hud hide:YES];
    });

}


- (void)loadData
{
    self.ListTourneeDate = [[PEG_FMobilitePegase CreateTournee] GetTourneeBetweenDateDebut:self.dateDebut andDateFin:self.dateFin];
    self.dataCharged = true;
    [self.listeTourneeUITableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
#pragma mark Gestion des dates
- (IBAction)btnDateDebut_TouchUpInside:(id)sender {
    
    self.dateSelected = DateDebutSelected;
     [self showDatePicker];
}

- (IBAction)btnDateFin_TouchUpInside:(id)sender
{
    self.dateSelected = DateFinSelected;
    [self showDatePicker];
}

-(NSString*) getDateSelected: (NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"]];
    [formatter setDateFormat:@"dd MMM yyyy"];
    
    NSString* v_dateStr = [formatter stringFromDate:date];
    
    return v_dateStr;
}

// pm201402 on a une tab bar en bas de l'écran.
// pour ne pas changer de mécanisme, on peut juste compenser la hauteur de cette barre.
- (void)showDatePicker
{
    PEG_DatePickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_DatePickerViewController"];
    //[pickerController setField:_field];
    
    //[pickerController setDate:[NSDate date]];
    
    if (self.dateSelected == DateDebutSelected)
    {
        [pickerController setDate:self.dateDebut];
    }
    else
    {
        [pickerController setDate:self.dateFin];
    }
    
    [pickerController setDelegate:self];
    
    [self addChildViewController:pickerController];
    
	// pm201402 compensate for tabBar height at the bottom of the screen
	UITabBar *tabBar = self.tabBarController.tabBar;
	CGFloat tabBarHeight = tabBar.frame.size.height;
    CGRect frame = pickerController.view.frame;
    frame.size.height -= tabBarHeight;
	
    frame.origin = CGPointMake(.0, self.view.frame.size.height);
    
    pickerController.view.frame = frame;
    
    [self.view addSubview:pickerController.view];
    
    [pickerController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         pickerController.view.frame = CGRectMake(.0, .0, pickerController.view.frame.size.width, pickerController.view.frame.size.height);
                     }
     
                     completion:^(BOOL finished) {
                              
                     }];
    
    
}

-(void) formDatePicker:(PEG_DatePickerViewController *)_formDatePicker didChooseDate:(NSDate *)date
{
    if (self.dateSelected == DateDebutSelected)
    {
        self.labelDtDebutUILabel.text = [self getDateSelected: date];
        self.dateDebut = [PEG_FTechnical GetDateYYYYMMDDFromDate:date];
    }
    else
    {
        self.labelDtFinUILabel.text = [self getDateSelected: date];
        self.dateFin = [PEG_FTechnical GetDateYYYYMMDDFromDate:date];
    }
    PEG_DatePickerViewController *pickerController = [self.childViewControllers objectAtIndex:0];
    
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





#pragma  mark Affichage
- (IBAction)BtnOK_Click:(id)sender {
    
    [self.hud  show:YES];
    
    [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"ListeTournee" andAction:@"BtnOK"];
    
    //On récupere les tournées
    NSString* v_Matricule = [[PEGSession sharedPEGSession] matResp];
#if USE_AFNetworkingWS
    [[PEGWebServices sharedWebServices] getBeanTourneeByMatricule:v_Matricule andDateDebut:self.dateDebut andDateFin:self.dateFin succes:^(void) {
        NSLog (@"getBeanTourneeByMatricule success");
        [self fillFinishedGetBeanTournee];
    } failure:^(NSError *error) {
        NSLog (@"getBeanTourneeByMatricule failure.");
        [self finishedWithErrorGetBeanTournee:error];
    }];
    /**** TEST *****/
// commented out pm140527
//    [[PEGWebServices sharedWebServices] getBeanTourneeADXByMatricule:v_Matricule andDateDebut:self.dateDebut andDateFin:self.dateFin succes:^(void) {
//        NSLog (@"getBeanTourneeADXByMatricule success");
//    } failure:^(NSError *error) {
//        NSLog (@"getBeanTourneeADXByMatricule failure.");
//    }];
    /**** FIN TEST ****/
#else
    [[PEG_FMobilitePegase CreateMobilitePegaseService] GetBeanTourneeWithObserver:self andMatricule:v_Matricule andDateDebut:self.dateDebut andDateFin:self.dateFin];
#endif
    //Faire le chargement des données
    self.ListTourneeDate = [[PEG_FMobilitePegase CreateTournee] GetTourneeBetweenDateDebut:self.dateDebut andDateFin:self.dateFin];
    
    self.dataCharged= true;
    [self.listeTourneeUITableView reloadData];
    
}
-(void) fillFinishedGetBeanTournee
{
        //Faire le chargement des données
        self.ListTourneeDate = [[PEG_FMobilitePegase CreateTournee] GetTourneeBetweenDateDebut:self.dateDebut andDateFin:self.dateFin];
    [self.listeTourneeUITableView reloadData];
    
    [self.hud  hide:YES];
}

-(void) finishedWithErrorGetBeanTournee:(NSError *)error
{
    [self.hud  hide:YES];
}


#pragma mark Gestion de la table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataCharged)
    {
        return [self.ListTourneeDate count];
    }
    else{
        return 0;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
    NSString * cellIdentifier = @"cellListeTournee";
    
    PEG_ListeTourneeCell* cellDtl = (PEG_ListeTourneeCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cellDtl == nil)
    {
        UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_ListeTourneeCell" bundle:nil];
        cellDtl = (PEG_ListeTourneeCell*) c.view;
      
    }
    BeanTournee* v_Tournee = [self.ListTourneeDate objectAtIndex:indexPath.row];
    
    NSString* v_NomTournee=v_Tournee.liTournee;
    NSDate* v_DateTournee= v_Tournee.dtDebutReelle;
    NSNumber* v_NbTache= [[PEG_FMobilitePegase CreateTournee] GetNbTacheByTournee:v_Tournee.idTournee ];
    NSNumber* v_NbLieu=[NSNumber numberWithInt:[v_Tournee.listLieuPassage count]];
    NSString* v_LibelleMagazin=[[PEG_FMobilitePegase CreateTournee] GetLibelleMagazinesForDesignByTournee:v_Tournee andNbCarTrunc:12 andEntete:false];
    
    /*NSString* v_NomTournee=@"Nom tournee test";
    NSDate* v_DateTournee= [NSDate date];
    NSNumber* v_NbTache= [NSNumber numberWithInt:5];
    NSNumber* v_NbLieu=[NSNumber numberWithInt:92];
    NSString* v_LibelleMagazin=@"LI Lyon 5665 ex TOP Lyon 1220 ex";*/
    
    [cellDtl initDataWithNomTournees:v_NomTournee andDateTournee:v_DateTournee andNbTache:v_NbTache andNbLieux:v_NbLieu andLibelleMagazine:v_LibelleMagazin];
    
    return cellDtl;
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"tableView" andExparams:[NSString stringWithFormat:@"indexPath : %i", indexPath.row]];
    }
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushListePointTournee" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pushListePointTournee"])
    {
        NSIndexPath* v_index = [self.listeTourneeUITableView indexPathForSelectedRow];
        BeanTournee* v_Tournee = [self.ListTourneeDate objectAtIndex:v_index.row];
        [((PEG_ListePointTourneeViewController*)[segue destinationViewController]) setDetailItem:v_Tournee.idTournee];
    }
  }



@end
