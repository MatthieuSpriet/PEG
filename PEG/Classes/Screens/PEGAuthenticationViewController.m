//
//  PEGAuthenticationViewController.m
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 28/06/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "PEGAuthenticationViewController.h"
#import "EHAlertView.h"
#import "Reachability.h"
#import "SPIRStoreHostApplicationAuthorizationRequest.h"
#import "MBProgressHUD.h"
#import "SPIRMessage.h"
#import "SPIRApplication.h"
#import "SPIRBasicAuthURL.h"
#import "PEGSession.h"
#import "PEGAppDelegate.h"
#import "PEGParametres.h"
#import "PEGAuthentificationWSRequest.h"
#import "PEGWebServices.h"
#import "PEG_FMobilitePegase.h"

@interface PEGAuthenticationViewController ()
{
	IBOutlet UITextField *loginTextField;
	IBOutlet UITextField *passwordTextField;
	
	NSString					*_username;
	NSString					*_password;
}

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

- (void)keyboardWillAppear:(NSNotification *)notif;
- (void)keyboardWillDisappear:(NSNotification *)notif;
- (void)login;
- (void)checkStoreApplicationAuthorization;

@end

@implementation PEGAuthenticationViewController

@synthesize username = _username;
@synthesize password = _password;


- (id)init
{
    if(self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil]) 
	{		
		self.username = [SPIRSession username];
		self.password = [SPIRSession password];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
		
	if ([[SPIRSession username] length] != 0) 
	{
		self.username = [SPIRSession username];
		loginTextField.text = self.username;
		if ([[SPIRSession password] length] != 0)
		{
			self.password = [SPIRSession password];	
			passwordTextField.text = self.password;
		}
	}
	else 
	{
		loginTextField.text = @"";
		passwordTextField.text = @"";
		
		self.username = nil;
		self.password = nil;
	}
	
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

#ifdef DEBUG
	if ([self.username length] > 0 && [self.password length] > 0)
	{
		// l'utilisateur s'est déjà connecté, on le connecte automatiquement
		[self login];
	}
#endif
    // pm 10/11/2014 UIKeyboardWillShowNotification broadcasted before viewDidAppear was causing incorect layout!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Keyboard

- (void)keyboardWillAppear:(NSNotification *)notif
{
	NSDictionary *userInfo = [notif userInfo];
	
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	UIViewAnimationOptions animationOption = animationCurve << 16;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];

	[UIView animateWithDuration:animationDuration
						  delay:.0 
						options:animationOption
					 animations:^{
						 [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
					 } 
					 completion:NULL];
}

- (void)keyboardWillDisappear:(NSNotification *)notif
{
	NSDictionary *userInfo = [notif userInfo];
	
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	UIViewAnimationOptions animationOption = animationCurve << 16;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
	
    
	[UIView animateWithDuration:animationDuration
						  delay:.0 
						options:animationOption
					 animations:^{
						 [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardFrame.size.height/2, self.view.frame.size.width, self.view.frame.size.height)];
					 } 
					 completion:NULL];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)inTextField
{
	[inTextField resignFirstResponder];
	
	if (inTextField == passwordTextField)
	{
		[self login];
	} 
	else
	{
		[passwordTextField becomeFirstResponder];
	}
	return YES;
}


// Traitement à l'issue de la saisie d'un champ
- (void)textFieldDidEndEditing:(UITextField *)textField
{	
	if (textField == loginTextField) // Login
	{
		self.username = textField.text;
	}
	else // Mot de passe
	{
		self.password = textField.text;
	}
}


#pragma mark - Login

// Lancement de l'authentification
- (void)login
{
	// vérif de connexion internet
	
	// no more PEGAuthentificationRequest in project
	// TODO: vérifier si on doit tester [PEGAuthentificationWSRequest hasCache]
//	if (![[Reachability reachabilityForInternetConnection] isReachable] && ![PEGAuthentificationRequest hasCache])
	if (![[Reachability reachabilityForInternetConnection] isReachable] && ![PEGAuthentificationWSRequest hasCache])
	{
		__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Connexion indisponible"
																	message:@"Vous devez être connecté à Internet pour pouvoir vous authentifier, souhaitez-vous réessayer ?"
														  cancelButtonTitle:@"Fermer"
														  otherButtonTitles:@"Réessayer", nil];
		[alertView setClickedButtonBlock:^(NSInteger buttonIndex) {
			if (buttonIndex == 1)
			{
				[self login];
			}
		}];
		[alertView show];
		return;
	}
	
	// vérif qu'on ait toutes les données
	if ([self.username length] == 0 || [self.password length] == 0)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erreur"
															message:@"Veuillez saisir votre identifiant et votre mot de passe avant de vous authentifier."
														   delegate:nil
												  cancelButtonTitle:@"Fermer"
												  otherButtonTitles:nil];
		[alertView show];
		return;
	}
	
	
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
	hud.removeFromSuperViewOnHide = YES;
	[self.view addSubview:hud];
	[hud hide:YES];
    
    
    //NSString * v_Login=@"ADREXO_ext.dev.tse";
    //NSString * v_Pass=@"spir3";
    
    NSString * v_Login=self.username; //penser a decomander le ADREXO_ dans le service
    NSString * v_Pass=self.password;
    
    [[PEG_FMobilitePegase CreateGoogleAnalytics] signInWithUser:v_Login];
    
    //Dans le cas des tests, pour eviter la saisie du mot de passe qu'on ne connait pas, on met un compte de service
    if(![PEG_WS_ENVIRONNEMENT isEqualToString:@"PROD"])
    {
        v_Login=@"SPIR_CompteServiceExtranetAdrexoLogin";
        v_Pass=@"CompteServiceExtranetAdrexoPwd";
    }
    
    // recuperation du fichier de config depuis le serveur
    PEGParametres* sharedCEXParametres = [PEGParametres sharedInstance];
    [sharedCEXParametres start_download:PEG_WS_ENVIRONNEMENT];	// requète synchrone !

    hud.labelText = @"Chargement...";
	[hud show:YES];
    
    [[PEGWebServices sharedWebServices] Login:v_Login andPassword:v_Pass  succes:^(bool p_isAuthentif) {
        
        [hud hide:YES];
        if(!p_isAuthentif){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Echec de l'authentification"
                                                            message:@"Votre identifiant et/ou votre mot de passe sont incorrects."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Fermer", nil];
            [alert show];

        }else{
            
            [SPIRSession saveUsername:v_Login andPassword:v_Pass];
            [SPIRSession saveUsername:self.username andPassword:self.password];//A supprimer qd v_Login sera le bon
            
            //On set le matricule du merch
            [[PEGSession sharedPEGSession] replaceMatResp:self.username];
            //[[PEGSession sharedPEGSession] replaceMatResp:v_Login];
            
            //TODO A supprimer
            //[[PEGSession sharedPEGSession] replaceMatResp:@"00000619"];
            // et on check le store
            [self checkStoreApplicationAuthorization];
        }
        
    } failure:^(NSError *error) {
        [hud hide:YES];
        // pm0514 here we can also  have a communincation error (no network)
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Echec de l'authentification"
                                                        message:@"Votre identifiant et/ou votre mot de passe sont incorrects."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Fermer", nil];
        [alert show];
        
        //TODO a supprimer qd store de nouveau dispo
        /*if ([PEG_WS_ENVIRONNEMENT isEqualToString:@"INT"] || [PEG_WS_ENVIRONNEMENT isEqualToString:@"REC"]) {
            [SPIRSession saveUsername:self.username andPassword:v_Pass];
            [[PEGSession sharedPEGSession] replaceMatResp:self.username];
            [[NSNotificationCenter defaultCenter] postNotificationName:PEGLoginSucceedNotification object:nil];
        }*/

    }];
}

- (void)checkStoreApplicationAuthorization
{
	if (![[Reachability reachabilityForInternetConnection] isReachable])
	{
		return;
	}
	
	//MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view.window];
	MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view]; //MSP Pour corriger le crash. A verifier?
	hud.removeFromSuperViewOnHide = YES;
	[self.view.window addSubview:hud];
	

// #if USE_AFNetworking
#if 0	// pm140220 c'est encore une requete ASIFormDataRequest
	SPIRStoreHostApplicationAuthorizationRequest *request = [SPIRStoreHostApplicationAuthorizationRequest request];

	[request setSuccessBlock:^{
		@try
		{
			SPIRApplication *application = [request processResponse];
			
			if (application == nil)
			{
				__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Attention"
																			message:@"Vous ne disposez pas des droits nécessaire pour accéder à cette application"
																  cancelButtonTitle:@"Fermer"
																  otherButtonTitles:nil];
				[alertView show];
			}
			else
			{
				DLog(@"URL install %@", [application.manifest absoluteString]);
				NSString *authUrl = urlWithAuth([application.manifest absoluteString]);
				
				if (application.status == SPIRApplicationStatusUpdate)
				{
					if (application.updateType == SPIRApplicationUpdateTypeMajor)
					{
						DLog(@"Update type majeur");
						__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Attention"
																					message:@"Vous devez mettre à jour cette application"
																		  cancelButtonTitle:@"Annuler"
																		  otherButtonTitles:@"Continuer", nil];
						[alertView setClickedButtonBlock:^(NSInteger buttonIndex) {
							if (buttonIndex == 1)
							{
								[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authUrl]];
							}
							else
							{
                                [[NSNotificationCenter defaultCenter] postNotificationName:PEGLoginSucceedNotification object:nil];
							}
						}];
						[alertView show];
					}
					else
					{
						DLog(@"Update type mineure");
						__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Avertissement"
																					message:@"Une mise à jour est disponible pour cette application. Voulez-vous l'installer ?"
																		  cancelButtonTitle:@"Non"
																		  otherButtonTitles:@"Oui", nil];
						[alertView setClickedButtonBlock:^(NSInteger buttonIndex) {
							if (buttonIndex == 1)
							{
								[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authUrl]];
							}
							else
							{
                                [[NSNotificationCenter defaultCenter] postNotificationName:PEGLoginSucceedNotification object:nil];
							}
						}];
						[alertView show];
					}
				}
				else if (application.status == SPIRApplicationStatusInstalled)
				{
					DLog(@"Déjà installé, pas d'update");
                    [[NSNotificationCenter defaultCenter] postNotificationName:PEGLoginSucceedNotification object:nil];
				}
			}
		}
		@catch (NSException *exception)
		{
			DLog(@"exception %@", exception.reason);
			__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Un problème serveur est survenu."
																		message:[NSString stringWithFormat:@"%@\nSouhaitez-vous réessayer ?", exception.reason]
															  cancelButtonTitle:@"Fermer"
															  otherButtonTitles:@"Réessayer", nil];
			[alertView setClickedButtonBlock:^(NSInteger buttonIndex) {
				if (buttonIndex == 1)
				{
					[self checkStoreApplicationAuthorization];
				}
			}];
			[alertView show];
		}
		@finally
		{
			[hud hide:YES];
		}
	}];
	
	[request setFailedBlock:^{
		[hud hide:YES];
		
	}];
	
	[request startAsynchronous];

	[hud setLabelText:@"Vérification des accès..."];
	[hud show:YES];
	

#else
	__weak SPIRStoreHostApplicationAuthorizationRequest *request = [SPIRStoreHostApplicationAuthorizationRequest request];
	
	[request setStartedBlock:^{
		[hud setLabelText:@"Vérification des accès..."];
		[hud show:YES];
	}];
	
	[request setCompletionBlock:^{
		@try
		{
			SPIRApplication *application = [request processResponse];
			
			if (application == nil)
			{
				__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Attention"
																			message:@"Vous ne disposez pas des droits nécessaire pour accéder à cette application"
																  cancelButtonTitle:@"Fermer"
																  otherButtonTitles:nil];
				[alertView show];
			}
			else
			{
				DLog(@"URL install %@", [application.manifest absoluteString]);
				NSString *authUrl = urlWithAuth([application.manifest absoluteString]);
				
				if (application.status == SPIRApplicationStatusUpdate)
				{
					if (application.updateType == SPIRApplicationUpdateTypeMajor)
					{
						DLog(@"Update type majeur");
						__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Attention"
																					message:@"Vous devez mettre à jour cette application"
																		  cancelButtonTitle:@"Annuler"
																		  otherButtonTitles:@"Continuer", nil];
						[alertView setClickedButtonBlock:^(NSInteger buttonIndex) {
							if (buttonIndex == 1)
							{
								[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authUrl]];
							}
							else
							{
                                [[NSNotificationCenter defaultCenter] postNotificationName:PEGLoginSucceedNotification object:nil];
							}
						}];
						[alertView show];
					}
					else
					{
						DLog(@"Update type mineure");
						__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Avertissement"
																					message:@"Une mise à jour est disponible pour cette application. Voulez-vous l'installer ?"
																		  cancelButtonTitle:@"Non"
																		  otherButtonTitles:@"Oui", nil];
						[alertView setClickedButtonBlock:^(NSInteger buttonIndex) {
							if (buttonIndex == 1)
							{
								[[UIApplication sharedApplication] openURL:[NSURL URLWithString:authUrl]];
							}
							else
							{
                                [[NSNotificationCenter defaultCenter] postNotificationName:PEGLoginSucceedNotification object:nil];
							}
						}];
						[alertView show];
					}
				}
				else if (application.status == SPIRApplicationStatusInstalled)
				{
					DLog(@"Déjà installé, pas d'update");
                    [[NSNotificationCenter defaultCenter] postNotificationName:PEGLoginSucceedNotification object:nil];
				}
			}
		}
		@catch (NSException *exception)
		{
			DLog(@"exception %@", exception.reason);
			__block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Un problème serveur est survenu."
																		message:[NSString stringWithFormat:@"%@\nSouhaitez-vous réessayer ?", exception.reason]
															  cancelButtonTitle:@"Fermer"
															  otherButtonTitles:@"Réessayer", nil];
			[alertView setClickedButtonBlock:^(NSInteger buttonIndex) {
				if (buttonIndex == 1)
				{
					[self checkStoreApplicationAuthorization];
				}
			}];
			[alertView show];
		}
		@finally
		{
			[hud hide:YES];
		}
	}];
	
	[request setFailedBlock:^{
		[hud hide:YES];
		
	}];
	
	[request startAsynchronous];
#endif

}



@end
