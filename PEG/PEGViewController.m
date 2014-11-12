//
//  PEGViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 05/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGViewController.h"
#import "PEG_FSuiviKilometre.h"
#import "PEGSession.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEGCell.h"
#import "BeanSuiviKMUtilisateur.h"
#import "PEGWebServices.h"


@interface PEGViewController ()

@property (strong, nonatomic) IBOutlet UITableView *MyTableView;

@property (nonatomic, strong) NSNumber* OldKilometre;

@end

@implementation PEGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //bouton Ecran Tests à afficher ou à cacher là
    
    self.OldKilometre = [[NSNumber alloc] initWithInt:-1];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    @try{
        
        //[[PEGSession sharedPEGSession] replaceMatResp:@"00921843"];
		NSString* v_Matricule = [[PEGSession sharedPEGSession] matResp];
		if(v_Matricule != nil)
		{
			if(![[PEG_FMobilitePegase CreateSuiviKilometre] IsKilometrageDuJourDejaSaisie:v_Matricule])
			{
				//On recharge pour mettre à jour le dernier kilometre dès que le matricule est dispo
				[self.MyTableView reloadData];
				//On fait sortir le clavier sur saisie des Kilometres
				PEGCell* cell= (PEGCell*)[self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
				[cell.textKmUITextField becomeFirstResponder];
				//On appelle le WS pour mettre à jour les Kilometre
				//PEG_BeanSuiviKMUtilisateur* v_BSK = [[PEG_BeanSuiviKMUtilisateur alloc ] init];
				
				// pm140220 faire un WebService AFN
				[[PEGWebServices sharedWebServices] getLastSuiviKilometreByMatricule:v_Matricule succes:^(void) {
					NSLog (@"getLastSuiviKilometreByMatricule success");
					[self fillFinishedGetLastSuiviKMUtilisateur];
				} failure:^(NSError *error){
					NSLog (@"getLastSuiviKilometreByMatricule failure");
					[self fillFinishedErrorGetLastSuiviKMUtilisateur:error];
				}];
			}
			else
			{
                if( [[PEG_FMobilitePegase CreateMobilitePegaseService] IsChangementJourDepuisDerniereSynchro])
                {
                    [self performSegueWithIdentifier:@"pushSynchro" sender:self];
                }
                {
                    [self performSegueWithIdentifier:@"pushWithoutSynchro" sender:self];
                }
			}
		}
	}@catch(NSException* p_exception){
		
		[[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans PEGViewController viewDidAppear" andExparams:nil];
	}
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL) isSaisieKm_Ok
{
    //ici : on pourra faire des comparaisons sur l'ancien km et le nouveau....
    PEGCell* cell= (PEGCell*)[self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    //Si c'est pas vide
    if (self.OldKilometre == nil || [self.OldKilometre integerValue] == -1)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"Patience"
                              message:@"Veuillez patienter afin d'obtenir le dernier kilométrage. Merci."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
        return false;
    }
    
    if ([cell.textKmUITextField.text isEqualToString:@""] || [self.GetKilometreSaisieAsNumber integerValue] < [self.OldKilometre integerValue])
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              
                              initWithTitle:@"KM"
                              message:@"Veuillez saisir un kilométrage supérieur au précédent. Merci."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
        return false;
    }
    return true;
}

//methode qui permet de savoir si on peut lancer l'action prévue dans le story board
-(BOOL)  shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //si btn ok appuyé, on vérifie d'abord si la saisie du km est ok
    if([self isSaisieKm_Ok])
    {
        [[PEG_FMobilitePegase CreateSuiviKilometre] AddOrUpdateSuiviKilometragePourMatricule:[[PEGSession sharedPEGSession] matResp] andDate:[NSDate date] andKM:self.GetKilometreSaisieAsNumber];
        
        return true;
    }
    else
    {
        return false;
    }
}

-(NSNumber *) GetKilometreSaisieAsNumber
{
    //Si c'est pas vide
    PEGCell* cell= (PEGCell*)[self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    if(![cell.textKmUITextField.text isEqualToString:@""])
    {
        return [NSNumber numberWithInt:[cell.textKmUITextField.text intValue]];
    }
    else
    {
        return [NSNumber numberWithInt:0];;
    }
}



// pm 140221 protocol PEG_BeanSuiviKMUtilisateurDataSource
// on peut appeler directement ces fonction dans les bloc success / faillure de l'appel à getLastSuiviKilometreByMatricule
// dans ce cas, on peut supprimer la déclaration du protocol "PEG_BeanSuiviKMUtilisateurDataSource"

#pragma mark - protocol PEG_BeanSuiviKMUtilisateurDataSource


-(void) fillFinishedGetLastSuiviKMUtilisateur
{    
    PEGCell* cell= (PEGCell*)[self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.labelKMUILabel.text = [[PEG_FMobilitePegase CreateSuiviKilometre] GetDernierKilometrageDesignByMatricule:[[PEGSession sharedPEGSession] matResp]];
    self.OldKilometre = [[PEG_FMobilitePegase CreateSuiviKilometre] GetDernierKilometrageByMatricule:[[PEGSession sharedPEGSession] matResp]];
    [self.MyTableView reloadData];
}


-(void) fillFinishedErrorGetLastSuiviKMUtilisateur:(NSError *)error
{
    [self MessageErrorUser:@"Get KM" andError:error];
}

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
    }
}



#pragma mark interface PEG_BeanMobilitePegaseDataSource

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEGCell *cell;
    
    if(indexPath.section==0){
        
        static NSString *CellIdentifier = @"cellTitre";
        cell = (PEGCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    
    if(indexPath.section==1){
        if(indexPath.row==0){
            static NSString *CellIdentifier = @"cellKm";
            cell= (PEGCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.labelKMUILabel.text = [[PEG_FMobilitePegase CreateSuiviKilometre] GetDernierKilometrageDesignByMatricule:[[PEGSession sharedPEGSession] matResp]];
            self.OldKilometre = [[PEG_FMobilitePegase CreateSuiviKilometre] GetDernierKilometrageByMatricule:[[PEGSession sharedPEGSession] matResp]];
            
        }else{
            static NSString *CellIdentifier = @"cellSaisie";
            cell= (PEGCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if([cell.textKmUITextField canBecomeFirstResponder])
            {
                [cell.textKmUITextField becomeFirstResponder];
            }
            
        }
        
    }
    if(indexPath.section==2){
        
        static NSString *CellIdentifier = @"cellTestUnitaire";
        cell = (PEGCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 2;
    }
    else if (section == 2)
    {
        if([PEGSession sharedPEGSession].IsAdmin)
        //On masque le bouton test
        return 1;
    }
    
    return 0;
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (IBAction)DeconnexionClick:(id)sender {
    [SPIRSession logout];
    exit(0);
}
- (IBAction)Usurpation:(id)sender {
    PEGCell* cell= (PEGCell*)[self.MyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [[PEGSession sharedPEGSession] replaceMatResp:cell.TextMatriculeUsurp.text];
}



@end
