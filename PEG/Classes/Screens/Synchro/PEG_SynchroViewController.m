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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Synchro";
    self.navigationItem.hidesBackButton = YES;
    self.ProgressBar.progress = (float)0.00f;
    
}

//sur cet écran, on ne veut pas la tab bar d'en bas.
- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
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
        [self synchronisation];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //On re-active la mise en veille auto
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


#pragma mark Méthodes privées
- (void)synchronisation
{
    @try{
        [PEGSession sharedPEGSession].IsSynchroOK=NO;
        
        //faire la synchro
        self.MessageUILabel.text = @"Publication des Photos...";
        [self.MessageUILabel setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];        //Pour permettre l'affichage

        //On envoi les données local vers le SI
        //on envoie les photo
        NSArray * v_AllPhoto=[[PEG_FMobilitePegase CreateImage] GetAllBeanPhotoNotSend];
        self.nbPhoto=[v_AllPhoto count];
        
        self.MessageUILabel.text = [NSString stringWithFormat:@"Publication des Photos %d",self.nbPhoto];
        [self.MessageUILabel setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        
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
        
    }
    @catch(NSException* p_exception) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans synchronisation" andExparams:nil];
        [self MessageErrorUser:@"PreSave"];
    }
}

- (void)synchroEtape2
{
    @try{
        self.ProgressBar.progress = (float)0.2f;
        self.MessageUILabel.text = @"Publication vers Pégase...";
        [self.MessageUILabel setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        
        [[PEGWebServices sharedWebServices] saveBeanMobilitePegaseWithSucces:^(void) {
            NSLog (@"saveBeanMobilitePegaseWithSucces success");
            [self fillFinishedSaveBeanMobilitePegase];
        } failure:^(NSError *error) {
            NSLog (@"saveBeanMobilitePegaseWithSucces failure. error: %@", error);
            [self fillFinishedSaveWithErrorBeanMobilitePegase:error];
        }];
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
        self.MessageUILabel.text = [NSString stringWithFormat:@"Publication des Photos %d",self.nbPhoto];
        [self.MessageUILabel setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]]; //Pour permettre l'affichage

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
    self.MessageUILabel.text = [NSString stringWithFormat:@"Publication des Photos %d",self.nbPhoto];
    [self.MessageUILabel setNeedsDisplay];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];     // affichage
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Attention"
                          message:[NSString stringWithFormat:@"La photo du présentoir d'id %i n'a pu être transmise. Elle est malheureusement perdue.",p_BeanImage.IdImage]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    
    [alert show];
    if (self.nbPhoto<=0) [self synchroEtape2];
}

#pragma mark interface PEG_BeanMobilitePegaseDataSource
-(void) fillFinishedSaveBeanMobilitePegase
{
    @try{
        NSString* v_Matricule = [[PEGSession sharedPEGSession] matResp];
        NSDate* v_Date = [NSDate date];
        self.ProgressBar.progress = (float)0.5f;
        
        self.MessageUILabel.text = @"Effacement de la base locale...";
        [self.MessageUILabel setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        
        //On vide les infos
        NSString* v_ContenuCD = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
        DLog(@"Avant Purge %@",v_ContenuCD);
        [[PEG_FMobilitePegase CreateCoreData] ViderCoreData];
        v_ContenuCD = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
        DLog(@"Apres Purge %@",v_ContenuCD);
        
        self.ProgressBar.progress = (float)0.6f;
        self.MessageUILabel.text = @"Récupération des données...";
        [self.MessageUILabel setNeedsDisplay];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        
        //On récupère les infos du SI
        [[PEGWebServices sharedWebServices] getBeanMobilitePegaseByMatricule:v_Matricule andDate:v_Date succes:^(void) {
            NSLog (@"getBeanMobilitePegaseByMatricule success");
            [self fillFinishedGetBeanMobilitePegase];
        } failure:^(NSError *error) {
            NSLog (@"getBeanMobilitePegaseByMatricule failure.");
            [self finishedWithErrorGetBeanMobilitePegase:error];
        }];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans fillFinishedSaveBeanMobilitePegase" andExparams:nil];
        [self MessageErrorUser:@"Save."];
    }
    
}

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
        
        // On ne fait plus le get tournee lors de la synchro
        [self fillFinishedGetBeanTournee];
        
        self.ProgressBar.progress = (float)0.8f;
    }
    @catch(NSException* p_exception){
        
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
