//
//  PEG_AdminChoixHoraireViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 18/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_AdminChoixHoraireViewController.h"
#import "PEG_AdminChoixHoraireCell.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEGAppDelegate.h"
#import "PEG_FMobilitePegase.h"

@interface PEG_AdminChoixHoraireViewController ()


@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (strong, nonatomic) IBOutlet UILabel *SelectedLabel;
@property (assign, nonatomic) BOOL  IsDemiJourneeActivee;
@property (assign, nonatomic) BOOL  IsOuvert;
@property (strong, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) BeanLieu* BeanLieu;

@property (assign, nonatomic) int jour;
@property (assign, nonatomic) int selectedTag;
@property (strong, nonatomic) NSDate* aMDebut; //1
@property (strong, nonatomic) NSDate* pMDebut; //2
@property (strong, nonatomic) NSDate* aMFin; //3
@property (strong, nonatomic) NSDate* pMFin; //4

@property (assign, nonatomic) BOOL  IsContextSemaineComplete;
@end

@implementation PEG_AdminChoixHoraireViewController



#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) setDetailItemForJour:(NSNumber*)p_Jour andAMDebut:(NSDate*)p_AMDebut andAMFin:(NSDate*)p_AMFin andPMDebut:(NSDate*)p_PMDebut andPMFin:(NSDate*)p_PMFin andLieu:(BeanLieu*)p_BeanLieu
{
    self.jour = [p_Jour intValue];
    self.aMDebut = p_AMDebut;
    self.aMFin = p_AMFin;
    self.pMDebut = p_PMDebut;
    self.pMFin = p_PMFin;
    self.BeanLieu=p_BeanLieu;
    
}

-(void) setContextSemaineComplete:(BeanLieu*)p_BeanLieu{
    self.IsContextSemaineComplete=YES;
    self.BeanLieu=p_BeanLieu;
}



- (void)viewDidLoad
{
    // set the left bar button to a nice trash can
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(BackClicked)];
    self.navigationItem.rightBarButtonItem = backButton;
    
    
    
	// Do any additional setup after loading the view.
    if(self.aMDebut !=nil){
        self.IsOuvert=YES;
        if(self.pMDebut !=nil){
            self.IsDemiJourneeActivee=YES;
        }else{
            self.IsDemiJourneeActivee=NO;
        }
    }else{
        self.IsOuvert=NO;
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    UITapGestureRecognizer * tapGestureRecognizer;
	
    if(indexPath.row==0){
        cellIdentifier=@"cellOuvert";
        //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        PEG_AdminChoixHoraireCell* cellDtl = (PEG_AdminChoixHoraireCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellDtl == nil)
        {
            UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_AdminChoixHoraireCell" bundle:nil];
            cellDtl = (PEG_AdminChoixHoraireCell*) c.view;
        }
        //   cellDtl.LieuUILabel.text = [self.BeanLieu.IdLieu stringValue];
        //   [cellDtl.Livrable247UISwitch setOn:[self.BeanLieu IsLivrable247]];
        if(self.IsOuvert){
            [cellDtl.OuvertSwitch setOn:YES animated:YES];
        }else{
            [cellDtl.OuvertSwitch setOn:NO animated:YES];
        }
        return cellDtl;
    }
    if(indexPath.row==1){
        if(self.IsOuvert){
		
            cellIdentifier=@"cellHoraire";
            //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            PEG_AdminChoixHoraireCell* cellDtl = (PEG_AdminChoixHoraireCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cellDtl == nil)
            {
                UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_AdminChoixHoraireCell" bundle:nil];
                cellDtl = (PEG_AdminChoixHoraireCell*) c.view;
            }
 			// note pm140218 on n'a sans doute pas besoin d'une propriété recognizerDtDeb. Le addGestureRecognizer crée une strong reference sur le gesture recognizer…
			tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [cellDtl.DtDebutLabel setUserInteractionEnabled:YES];
            [cellDtl.DtDebutLabel addGestureRecognizer:tapGestureRecognizer];
            
            NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
            [outputFormatter setDateFormat:@"HH : mm"];
            
            if(self.aMDebut !=nil){
                NSString *dateString=[outputFormatter stringFromDate:self.aMDebut];
                cellDtl.DtDebutLabel.text= dateString;
            }else{
                cellDtl.DtDebutLabel.text=@"08 : 00";
            }
            
            tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [cellDtl.DtFinLabel setUserInteractionEnabled:YES];
            [cellDtl.DtFinLabel addGestureRecognizer:tapGestureRecognizer];
            
            if(self.aMFin !=nil){
                NSString *dateFinString=[outputFormatter stringFromDate:self.aMFin];
                cellDtl.DtFinLabel.text= dateFinString;
            }else{
                cellDtl.DtFinLabel.text=@"12 : 00";
            }
            return cellDtl;
        }
    }
    if(indexPath.row==2){
        if(self.IsOuvert){
            cellIdentifier=@"cellActiverJournee";
            //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            
            PEG_AdminChoixHoraireCell* cellDtl = (PEG_AdminChoixHoraireCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cellDtl == nil)
            {
                UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_AdminChoixHoraireCell" bundle:nil];
                cellDtl = (PEG_AdminChoixHoraireCell*) c.view;
            }
            //   cellDtl.LieuUILabel.text = [self.BeanLieu.IdLieu stringValue];
            //   [cellDtl.Livrable247UISwitch setOn:[self.BeanLieu IsLivrable247]];
            if(self.IsDemiJourneeActivee){
                [cellDtl.DemiJourneeSwitch setOn:YES animated:YES];
            }else{
                [cellDtl.DemiJourneeSwitch setOn:NO animated:YES];
            }
            return cellDtl;
        }
    }
    if(indexPath.row==3){
        if(self.IsOuvert){
            if(self.IsDemiJourneeActivee){
                cellIdentifier=@"cellHoraireComplement";
                //        PEG_DetailQteCell* cellDtl = [[[PEG_DetailQteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                
                PEG_AdminChoixHoraireCell* cellDtl = (PEG_AdminChoixHoraireCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cellDtl == nil)
                {
                    UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_AdminChoixHoraireCell" bundle:nil];
                    cellDtl = (PEG_AdminChoixHoraireCell*) c.view;
                }
                
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [cellDtl.DtDebutComplLabel setUserInteractionEnabled:YES];
                [cellDtl.DtDebutComplLabel addGestureRecognizer:tapGestureRecognizer];
                
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"HH : mm"];
                
                if(self.pMDebut !=nil){
                    NSString *dateString=[outputFormatter stringFromDate:self.pMDebut];
                    cellDtl.DtDebutComplLabel.text= dateString;
                }else{
                    cellDtl.DtDebutComplLabel.text=@"14 : 00";
                }
                
                
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [cellDtl.DtFinComplLabel setUserInteractionEnabled:YES];
                [cellDtl.DtFinComplLabel addGestureRecognizer:tapGestureRecognizer];
                
                if(self.pMFin !=nil){
                    NSString *dateFinString=[outputFormatter stringFromDate:self.pMFin];
                    cellDtl.DtFinComplLabel.text= dateFinString;
                }else{
                    cellDtl.DtFinComplLabel.text=@"19 : 00";
                }
                return cellDtl;
            }
        }
    }
    
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        return 50;
    }
    
    return 0;
}



-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if(self.IsOuvert){
            if(self.IsDemiJourneeActivee){
                return 4;
            }else{
                return 3;
            }
        }else{
            return 1;
        }
    }
    
    
    return 0;
}

#pragma mark - Actions
- (IBAction)TimeValueChanged:(id)sender {
    
    
    UIDatePicker *picker = (UIDatePicker *)sender;
    
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH : mm"];
    NSString *dateString=[outputFormatter stringFromDate:picker.date];
    self.SelectedLabel.text=dateString;
    
    if(self.selectedTag == 1)
    {
        self.aMDebut =picker.date;
    }
    else if(self.selectedTag == 2)
    {
        self.aMFin =picker.date;
    }
    else if(self.selectedTag == 3)
    {
        self.pMDebut =picker.date;
    }
    else if(self.selectedTag == 4)
    {
        self.pMFin =picker.date;
    }
}
- (IBAction)ActiverDemiJourneeChanged:(id)sender {
    
    UISwitch *Monswitch = (UISwitch *)sender;
    
    self.IsDemiJourneeActivee=Monswitch.isOn;
    [self.TableView reloadData];
}
- (IBAction)OuvertureChangerd:(id)sender {
    UISwitch *Monswitch = (UISwitch *)sender;
    
    self.IsOuvert=Monswitch.isOn;
    [self.TableView reloadData];
}
- (void)tapAction:(UITapGestureRecognizer *)tapGesture {
    self.SelectedLabel = (UILabel *)tapGesture.view;
    self.selectedTag = ((UILabel *)tapGesture.view).tag;
    [self.DatePicker setDate: [self LabelTextToNsDate:self.SelectedLabel.text ]];
    //delete it using removeFromSuperView or do whatever you need with tapped label
    
}

-(NSDate*) LabelTextToNsDate:(NSString *)p_HoraireString
{
    
    NSDate *myDate=nil;
    
    NSString *stringWithoutSpaces = [p_HoraireString
                                     stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString* v_dateenstring= [NSString stringWithFormat:@"2013-01-01 %@:00",stringWithoutSpaces];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    myDate = [df dateFromString: v_dateenstring];
    
    return myDate;
}

- (void)BackClicked
{
    
        PEG_AdminChoixHoraireCell* cellDtlHoraire = (PEG_AdminChoixHoraireCell *) [self.TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        PEG_AdminChoixHoraireCell* cellDtlComplement = (PEG_AdminChoixHoraireCell *) [self.TableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        
        if(self.IsOuvert){
            
            self.aMDebut=[self LabelTextToNsDate:cellDtlHoraire.DtDebutLabel.text ];
            self.aMFin=[self LabelTextToNsDate:cellDtlHoraire.DtFinLabel.text ];
            
            if(self.IsDemiJourneeActivee){
                
                self.pMDebut=[self LabelTextToNsDate:cellDtlComplement.DtDebutComplLabel.text ];
                self.pMFin=[self LabelTextToNsDate:cellDtlComplement.DtFinComplLabel.text ];
            }else{
                
                self.pMDebut=nil;
                self.pMFin=nil;
            }
        }else{
            
            self.aMDebut=nil;
            self.pMDebut=nil;
            self.aMFin=nil;
            self.pMFin=nil;
        }
    if(!self.IsContextSemaineComplete){
        [[PEG_FMobilitePegase CreateLieu] AddOrReplaceHoraireForJour:[[NSNumber alloc] initWithInt:self.jour] andAMDebut:self.aMDebut andAMFin:self.aMFin andPMDebut:self.pMDebut andPMFin:self.pMFin andLieu:self.BeanLieu];
        
    }else{
        [[PEG_FMobilitePegase CreateLieu] AddOrReplaceHoraireFormSemaineCompleteForAMDebut:self.aMDebut andAMFin:self.aMFin andPMDebut:self.pMDebut andPMFin:self.pMFin andLieu:self.BeanLieu];
    }
    [[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:self.BeanLieu.idLieu];
    [self.navigationController popViewControllerAnimated:YES];
    
}

/*- (void)InitBeanLieuSemaineComplete {
    for (int i=0;i<7;i++)
    {
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        BeanHoraire* v_BeanHoraire = [NSEntityDescription insertNewObjectForEntityForName:@"BeanHoraire" inManagedObjectContext:app.managedObjectContext];
        [v_BeanHoraire setIdLieu:self.BeanLieu.idLieu];
        [v_BeanHoraire setFlagMAJ:PEG_EnumFlagMAJ_Added];
        [[PEG_FMobilitePegase CreateLieu] AddOrReplaceHoraire:v_BeanHoraire andLieu:self.BeanLieu];
    }
}
- (void)MAJBeanLieu{
    
}*/

@end
