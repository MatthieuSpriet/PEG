//
//  PEG_TourneesADXViewController.m
//  PEG
//
//  Created by Pierre Marty on 26/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_TourneesADXViewController.h"

#import "PEG_DatePickerViewController.h"

#import "PEG_TourneeADXCell.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_TourneeADXViewController.h"
#import "PEGSession.h"
#import "PEG_FTechnical.h"
#import "PEG_FMobilitePegase.h"
#import "MBProgressHUD.h"
#import "PEGWebServices.h"
#import "PEG_GoogleAnalyticsServices.h"


@interface PEG_TourneesADXViewController () <UITableViewDataSource, UITableViewDelegate, PEGDatePickerDelegate>

@property (nonatomic,assign) PEGDateSelected dateSelected;

@property (nonatomic,strong) NSArray* tournees;  //liste de PEG_BeanTournee <<<< ???? PEG_BeanTournee semble obsolete ???
@property (nonatomic,strong) NSDate* dateDebut;
@property (nonatomic,strong) NSDate* dateFin;

@property (strong, nonatomic) IBOutlet UILabel *dateDebutLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateFinLabel;
@property (strong, nonatomic) IBOutlet UITableView *tourneesTableView;

@property (assign, nonatomic) BOOL dataCharged;

@property (strong, nonatomic) MBProgressHUD *hud ;

@end

@implementation PEG_TourneesADXViewController


// this is the initializer when using a storyboard
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.dataCharged= false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps=[calendar components:NSWeekCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
    comps.weekday = 2;
    //create date on week start
    NSDate* v_dateDeb=[calendar dateFromComponents:comps];
    NSDate* v_dateFin = [v_dateDeb dateByAddingTimeInterval:((3600*24)*6)];
    
    self.dateDebutLabel.text = [self getDateSelected: v_dateDeb];
    self.dateDebut = [PEG_FTechnical GetDateYYYYMMDDFromDate:v_dateDeb];
    self.dateFinLabel.text = [self getDateSelected: v_dateFin];
    self.dateFin = [PEG_FTechnical GetDateYYYYMMDDFromDate:v_dateFin];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    self.hud.labelText=@"Chargement des tournées";
    [self.view addSubview:self.hud ];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.hud show:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadData];    // in main thread
        [self.hud hide:YES];
    });
}

// load from core data
- (void)loadData
{
    self.tournees = [[PEG_FMobilitePegase CreateTourneeADX] GetTourneeBetweenDateDebut:self.dateDebut andDateFin:self.dateFin];
    self.dataCharged = true;
    [self.tourneesTableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark Gestion des dates
- (IBAction)btnDateDebut_TouchUpInside:(id)sender
{
    self.dateSelected = DateDebutSelected;
    [self showDatePicker];
}

- (IBAction)btnDateFin_TouchUpInside:(id)sender
{
    self.dateSelected = DateFinSelected;
    [self showDatePicker];
}

-(NSString*)getDateSelected: (NSDate*)date
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
    
    // compensate for tabBar height at the bottom of the screen
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
                         
                     }
     ];
}

-(void)formDatePicker:(PEG_DatePickerViewController *)_formDatePicker didChooseDate:(NSDate *)date
{
    if (self.dateSelected == DateDebutSelected)
    {
        self.dateDebutLabel.text = [self getDateSelected: date];
        self.dateDebut = [PEG_FTechnical GetDateYYYYMMDDFromDate:date];
    }
    else
    {
        self.dateFinLabel.text = [self getDateSelected: date];
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
                     }
     ];
}





#pragma  mark Affichage

- (IBAction)BtnOK_Click:(id)sender {
    
    [self.hud show:YES];
    
    [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"ListeTourneeADX" andAction:@"BtnOK"];
    
    NSString* v_Matricule = [[PEGSession sharedPEGSession] matResp];

    [[PEGWebServices sharedWebServices] getBeanTourneeADXByMatricule:v_Matricule andDateDebut:self.dateDebut andDateFin:self.dateFin succes:^(void) {
        NSLog (@"getBeanTourneeADXByMatricule success");
        //self.tournees = [[PEG_FMobilitePegase CreateTourneeADX] GetTourneeBetweenDateDebut:self.dateDebut andDateFin:self.dateFin];
        //self.dataCharged= true;
        //[self.tourneesTableView reloadData];
        [self loadData];
        [self.hud hide:YES];
    } failure:^(NSError *error) {
        NSLog (@"getBeanTourneeADXByMatricule failure.");
        [self.hud hide:YES];
    }];
}


#pragma mark Gestion de la table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataCharged)
    {
        return [self.tournees count];
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        NSString * cellIdentifier = @"cellListeTournee";
        
        PEG_TourneeADXCell* cellDtl = (PEG_TourneeADXCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_TourneePrestataireCell" bundle:nil];
            cellDtl = (PEG_TourneeADXCell*) c.view;
        }
        BeanTourneeADX* v_Tournee = [self.tournees objectAtIndex:indexPath.row];
        
        NSString* v_NomTournee=v_Tournee.liTournee;
        
            // pm150526 changed dtDebut from NSString* to NSDate*
        NSDate* v_DateTournee= v_Tournee.dtDebut;
        NSNumber* v_NbTache= [[PEG_FMobilitePegase CreateTourneeADX] GetNbTacheByTournee:v_Tournee.idTournee ];
        NSNumber* v_NbLieu=[NSNumber numberWithInt:[v_Tournee.listLieuPassageADX count]];
        NSString* v_LibelleMagazin=[[PEG_FMobilitePegase CreateTourneeADX] GetLibelleMagazinesForDesignByTournee:v_Tournee andNbCarTrunc:12 andEntete:false];
        
        [cellDtl initWithNomTournees:v_NomTournee andDateTournee:v_DateTournee andNbTache:v_NbTache andNbLieux:v_NbLieu andLibelleMagazine:v_LibelleMagazin andIdTournee:v_Tournee.idTournee];
        
        return cellDtl;
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"tableView" andExparams:[NSString stringWithFormat:@"indexPath : %i", indexPath.row]];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"pushTournee" sender:self];
////// test
//    [[PEG_GoogleAnalyticsServices sharedInstance] setCustomValue:@"Grenoble" forDimension:1];
//    [[PEG_GoogleAnalyticsServices sharedInstance] setCustomValue:@"Vourey" forDimension:2];
//    [[PEG_GoogleAnalyticsServices sharedInstance] setCustomValue:@"24.1" forMetric:1];
}


#pragma mark - Segue

// set the tournee for destination PEG_ListePointTourneeViewController
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pushTournee"])
    {
        NSIndexPath* v_index = [self.tourneesTableView indexPathForSelectedRow];
        BeanTourneeADX* v_Tournee = [self.tournees objectAtIndex:v_index.row];
        [((PEG_TourneeADXViewController*)[segue destinationViewController]) setDetailItem:v_Tournee.idTournee];
    }
}



@end
