//
//  PEG_SynchroViewController.m
//  PEG
//
//  Created by HorsMedia1 on 17/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_SynchroViewController.h"
#import "PEGSession.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_FTechnical.h"
#import "PEGWebServices.h"


/********** Pour DEBUG *********************/
// 0: Synchro (Pour Prod)
// 1: Pas de synchro
#define SANS_SYNCHRO 0
/*******************************************/

@interface PEG_SynchroViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *ProgressBar;
@property (strong, nonatomic) IBOutlet UILabel *MessageUILabel;

@property (assign, nonatomic)  int nbPhoto;


@end

@implementation PEG_SynchroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Synchro";
    self.navigationItem.hidesBackButton = YES;
    self.ProgressBar.progress = (float)0.00f;
    
}

//sur cet écran, on ne veut pas la tab bar d'en bas. On surcharge la méthode initiale
-(BOOL) hidesBottomBarWhenPushed
{
    return YES;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //On desactive la mise en veille auto
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.navigationItem.hidesBackButton = YES;
    self.ProgressBar.progress = (float)0.00f;
    if (SANS_SYNCHRO)
    {
        [self fillFinishedGetBeanTournee];
    }
    else
    {
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       //     NSAutoreleasePool* p = [[NSAutoreleasePool alloc] init];
            [self synchronisation];
        //    [p drain];
        //});
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //On re-active la mise en veille auto
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Méthodes privées
-(BOOL) synchronisation
{
    @try{
        [PEGSession sharedPEGSession].IsSynchroOK=NO;
		
        //faire la synchro
        //[NSThread sleepForTimeInterval:1];
        //dispatch_async(dispatch_get_main_queue(), ^{
			self.MessageUILabel.text = @"Publication des Photos...";
			[self.MessageUILabel setNeedsDisplay];
            //Pour permettre l'affichage
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        //});
        //On envoi les données local vers le SI
        //on envoie les photo
        
        NSArray * v_AllPhoto=[[PEG_FMobilitePegase CreateImage] GetAllBeanPhotoNotSend];
        self.nbPhoto=[v_AllPhoto count];
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            self.MessageUILabel.text = [NSString stringWithFormat:@"Publication des Photos %d",self.nbPhoto];
            [self.MessageUILabel setNeedsDisplay];
            //Pour permettre l'affichage
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        //});
        
        PEG_BeanImage *v_BeanImage = nil;
        for (BeanPhoto* v_BeanPhoto in v_AllPhoto) {
            UIImage* v_image=[[PEG_FMobilitePegase CreateImage] GetPictureFromFileById:[v_BeanPhoto.idPresentoir intValue]];
            v_BeanImage = [[PEG_BeanImage alloc ]init];
            v_BeanImage.IdImage=[v_BeanPhoto.idPresentoir intValue];
            v_BeanImage.NomImage=[NSString stringWithFormat:@"%@.jpg",v_BeanPhoto.idPresentoir];
            v_BeanImage.Image=v_image;
            [v_BeanImage SaveBeanImageWithObserver:self];
        }
        
        //Si pas de photo, pas d'appel au fillfinished, donc on lance directement l'étape suivante
        if([v_AllPhoto count] == 0)
        {
            [self synchroEtape2];
        }
        v_AllPhoto = nil; //Pour liberer la mémoire des UIImage
        
        /*do{
         dispatch_async(dispatch_get_main_queue(), ^{
         self.MessageUILabel.text = [NSString stringWithFormat:@"Publication des Photos %d",self.nbPhoto];
         [self.MessageUILabel setNeedsDisplay];
         });
         sleep(1);
         }
         while(self.nbPhoto>0);*/
        //[self fillFinishedSaveBeanMobilitePegase]; //Bouchon
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans synchronisation" andExparams:nil];
        [self MessageErrorUser:@"PreSave"];
    }
    //quand c'est terminé, renvoyer true si c'est ok
    return true;
}

-(void)synchroEtape2
{
    @try{
        self.ProgressBar.progress = (float)0.2f;
    //dispatch_async(dispatch_get_main_queue(), ^{
        self.MessageUILabel.text = @"Publication vers Pégase...";
        [self.MessageUILabel setNeedsDisplay];
        //Pour permettre l'affichage
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    //});
    
#if USE_AFNetworkingWS
    [[PEGWebServices sharedWebServices] saveBeanMobilitePegaseWithSucces:^(void) {
        NSLog (@"saveBeanMobilitePegaseWithSucces success");
        [self fillFinishedSaveBeanMobilitePegase];
    } failure:^(NSError *error) {
        NSLog (@"saveBeanMobilitePegaseWithSucces failure. error: %@", error);
        [self fillFinishedSaveWithErrorBeanMobilitePegase:error];
    }];
#else
    [[PEG_FMobilitePegase CreateMobilitePegaseService] SaveBeanMobilitePegaseWithObserver:self];
#endif
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans synchroEtape2" andExparams:@""];
    }
}

-(void) fillFinishedSaveBeanImage:(PEG_BeanImage*)p_BeanImage
{
    @try{
        NSLog(@"fillFinishedSaveBeanImage");
        self.nbPhoto--;
        //dispatch_async(dispatch_get_main_queue(), ^{
            self.MessageUILabel.text = [NSString stringWithFormat:@"Publication des Photos %d",self.nbPhoto];
            [self.MessageUILabel setNeedsDisplay];
            //Pour permettre l'affichage
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        //});
        
        [[PEG_FMobilitePegase CreateImage] SavePhotoSend:p_BeanImage.IdImage];

        if(self.nbPhoto<=0) [self synchroEtape2];
    }
    @catch (NSException *p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans fillFinishedSaveBeanImage" andExparams:@""];
    }
    //[PEGSession sharedPEGSession].IsSynchroOK = true;
    
    
}

-(void) finishedWithErrorSaveBeanImage:(PEG_BeanImage*)p_BeanImage
{
    NSLog(@"finishedWithErrorSaveBeanImage");
    self.nbPhoto--;
    //dispatch_async(dispatch_get_main_queue(), ^{
        self.MessageUILabel.text = [NSString stringWithFormat:@"Publication des Photos %d",self.nbPhoto];
        [self.MessageUILabel setNeedsDisplay];
        //Pour permettre l'affichage
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    //});
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Attention"
                          message:[NSString stringWithFormat:@"La photo du présentoir d'id %i n'a pu être transmise. Elle est malheureusement perdue.",p_BeanImage.IdImage]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
    if(self.nbPhoto<=0) [self synchroEtape2];
}

#pragma mark interface PEG_BeanMobilitePegaseDataSource
-(void) fillFinishedSaveBeanMobilitePegase
{
    @try{
        NSString* v_Matricule = [[PEGSession sharedPEGSession] matResp];
        NSDate* v_Date = [NSDate date];
        //TODO bouchon a supprimer
        //v_Date = [PEG_FTechnical GetDateYYYYMMDDFromString:@"20130429"];
        
        //On met la barre de progression à 40%
        self.ProgressBar.progress = (float)0.5f;
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            self.MessageUILabel.text = @"Effacement de la base locale...";
        [self.MessageUILabel setNeedsDisplay];
        //Pour permettre l'affichage
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
         //});

        //On vide les infos
        NSString* v_ContenuCD = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
        DLog(@"Avant Purge %@",v_ContenuCD);
        [[PEG_FMobilitePegase CreateCoreData] ViderCoreData];
        v_ContenuCD = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
        DLog(@"Apres Purge %@",v_ContenuCD);
        
        //On met la barre de progression à 40%
        self.ProgressBar.progress = (float)0.6f;
        //dispatch_async(dispatch_get_main_queue(), ^{
            self.MessageUILabel.text = @"Récupération des données...";
            [self.MessageUILabel setNeedsDisplay];
            //Pour permettre l'affichage
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        //});
        //On récupère les infos du SI
#if USE_AFNetworkingWS
		[[PEGWebServices sharedWebServices] getBeanMobilitePegaseByMatricule:v_Matricule andDate:v_Date succes:^(void) {
			NSLog (@"getBeanMobilitePegaseByMatricule success");
			[self fillFinishedGetBeanMobilitePegase];
		} failure:^(NSError *error) {
			NSLog (@"getBeanMobilitePegaseByMatricule failure.");
			[self finishedWithErrorGetBeanMobilitePegase:error];
		}];
#else
        [[PEG_FMobilitePegase CreateMobilitePegaseService] GetBeanMobilitePegaseWithObserver:self andMatricule:v_Matricule andDate:v_Date];
#endif
        //[self fillFinishedGetBeanMobilitePegase]; //Bouchon
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans fillFinishedSaveBeanMobilitePegase" andExparams:nil];
        [self MessageErrorUser:@"Save."];
    }
    
}

// pm140221 p_Error can be nil ?
-(void) fillFinishedSaveWithErrorBeanMobilitePegase:(NSError*)p_Error
{
    [PEGSession sharedPEGSession].IsSynchroOK=NO;
    [self MessageErrorUser:@"Save" andError:p_Error];
}

-(void) fillFinishedGetBeanMobilitePegase
{
    @try{
        NSString* v_ContenuCD = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
        DLog(@"Après chargement %@",v_ContenuCD);
        
        //self.MessageUILabel.text = @"MAJ des parutions...";
        //self.ProgressBar.progress = (float)0.6f;
        //On ne fait pas [[PEG_FMobilitePegase CreatePresentoir] MAJParutionPresentoir];
        
        // On ne fait plus le get tournee lors de la synchro
        [self fillFinishedGetBeanTournee];
        /*NSString* v_Matricule = [[PEGSession sharedPEGSession] matResp];

		// NSCalendar *calendar = [[NSCalendar currentCalendar]initWithCalendarIdentifier:NSGregorianCalendar];
		// pm201402 exeption sur la ligne au dessus. En supposant que l'utilisateur a un setting calendrier gregorien:
        NSCalendar *calendar = [NSCalendar currentCalendar];
        //NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        comps=[calendar components:NSWeekCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
        comps.weekday = 2;
        //create date on week start
        NSDate* v_dateDeb=[calendar dateFromComponents:comps];
        NSDate* v_dateFin = [v_dateDeb dateByAddingTimeInterval:((3600*24)*6)];
#if USE_AFNetworkingWS
		[[PEGWebServices sharedWebServices] getBeanTourneeByMatricule:v_Matricule andDateDebut:v_dateDeb andDateFin:v_dateFin succes:^(void) {
			NSLog (@"getBeanTourneeByMatricule success");
			[self fillFinishedGetBeanTournee];
		} failure:^(NSError *error) {
			NSLog (@"getBeanTourneeByMatricule failure.");
			[self finishedWithErrorGetBeanTournee:error];
		}];
#else
        [[PEG_FMobilitePegase CreateMobilitePegaseService] GetBeanTourneeWithObserver:self andMatricule:v_Matricule andDateDebut:v_dateDeb andDateFin:v_dateFin];
#endif
        //[self fillFinishedGetBeanTournee];
        dispatch_async(dispatch_get_main_queue(), ^{
        self.MessageUILabel.text = @"Récupération des tournées...";
        [self.MessageUILabel setNeedsDisplay];
        });*/
        self.ProgressBar.progress = (float)0.8f;
        
        //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Suivant"
        //                                                                              style:self.editButtonItem.style target:self action:@selector(doneButtonNext)];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans fillFinishedGetBeanMobilitePegase" andExparams:nil];
        [self MessageErrorUser:@"Get"];
    }
}
-(void) fillFinishedGetBeanTournee
{
    [PEGSession sharedPEGSession].IsSynchroOK=YES;
    self.MessageUILabel.text = @"Synchronisation Terminé";
    self.ProgressBar.progress = (float)1;
    //Pour permettre l'affichage
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    sleep(2);
    [self performSegueWithIdentifier:@"NextSegue2" sender:self];

}
-(void) finishedWithErrorGetBeanTournee:(NSError *)error
{
    [PEGSession sharedPEGSession].IsSynchroOK=YES;
    self.MessageUILabel.text = @"Synchronisation Terminé";
    self.ProgressBar.progress = (float)1;
    //Pour permettre l'affichage
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    sleep(2);
    [self performSegueWithIdentifier:@"NextSegue2" sender:self];
}

-(void) finishedWithErrorGetBeanMobilitePegase:(NSError *)error
{
    [self MessageErrorUser:@"Get" andError:error];
}


#pragma mark interface UIAlertViewDelegate
- (void)MessageErrorUser:(NSString *)p_titre andMessage:(NSString*)p_Message
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:p_titre
                          message:p_Message
                          delegate:self
                          cancelButtonTitle:@"Quitter"
                          otherButtonTitles:@"Tél 65 45",nil];
    
    [alert show];
}

- (void)MessageErrorUser:(NSString *)p_titre
{
    [self MessageErrorUser:p_titre andMessage:@"Une erreur s'est produite, merci d'appeler l'assistance pour débloquer l'application"];
}

- (void)MessageErrorUser:(NSString *)p_titre andError:(NSError*)p_Error
{
    if([p_Error.domain isEqualToString:@"NSURLErrorDomain"])
    {
        [self MessageErrorUser:[NSString stringWithFormat: @"%@ URL %d", p_titre, p_Error.code] andMessage:@"Erreur de déconnection reseau, veuillez relancer"];
    }
    else if([p_Error.domain isEqualToString:@"ASIHTTPRequestErrorDomain"])
    {
        [self MessageErrorUser:[NSString stringWithFormat: @"%@ ASI %d", p_titre, p_Error.code] andMessage:@"Erreur de déconnection reseau, veuillez relancer"];
    }
    else
    {
        [self MessageErrorUser:p_titre andMessage:@"Une erreur s'est produite, merci d'appeler l'assistance pour débloquer l'application"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Quitter"])
    {
        NSLog(@"Button Quitter.");
        exit(0);
    }
    else if([title isEqualToString:@"Tél 65 45"])
    {
        NSLog(@"Button Tél 65 45");
        [[PEG_FMobilitePegase CreateMobilitePegaseService] AppelAssistance];
        NSLog(@"On Quitte.");
        exit(0);
        //PEGAppDelegate* appDelegate = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        //appDelegate.isNeedToBeExit = true;
    }
}

#pragma mark Segue
-(void)doneButtonNext
{
    //pousse l'action NextSegue
    [self performSegueWithIdentifier:@"NextSegue" sender:self];
}

- (void)viewDidUnload {
    [self setMessageUILabel:nil];
    [super viewDidUnload];
}

@end
