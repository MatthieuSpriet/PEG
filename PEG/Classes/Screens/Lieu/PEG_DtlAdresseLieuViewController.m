//
//  PEG_DtlAdresseLieuViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 09/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_DtlAdresseLieuViewController.h"
//#import "PEG_BeanLieu.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_ViewDtlAdministratifViewController.h"
#import "PEG_ViewDtlAdministratifView1Controller.h"
#import "PEG_ViewDtlAdministratifView2Controller.h"

@interface PEG_DtlAdresseLieuViewController ()
@property (strong, nonatomic) NSNumber* IdLieu;
@property (assign, nonatomic) BOOL VFModeCreation;
@end

@implementation PEG_DtlAdresseLieuViewController

- (IBAction)EditUIButtonClick:(id)sender {
    
    if(self.pageControl.currentPage==0){
        
        BOOL v_valeur = YES;
        v_valeur=[((PEG_ViewDtlAdministratifView1Controller*)[self.childViewControllers objectAtIndex:0]) isTableViewEditable];
        
        if(v_valeur){
            if([((PEG_ViewDtlAdministratifView1Controller*)[self.childViewControllers objectAtIndex:0]) Save])
            {
                UIBarButtonItem *EditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(EditUIButtonClick:)];
                self.navigationItem.rightBarButtonItem = EditButton;
                [self.scrollView setScrollEnabled:YES];
                self.navigationItem.hidesBackButton = NO;
                [((PEG_ViewDtlAdministratifView1Controller*)[self.childViewControllers objectAtIndex:0]) setTableViewEditable:NO];
            }
            
        }else{
            UIBarButtonItem *SaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(EditUIButtonClick:)];
            [SaveButton setTintColor:[UIColor redColor]];
            self.navigationItem.rightBarButtonItem = SaveButton;
            [self.scrollView setScrollEnabled:NO];
            self.navigationItem.hidesBackButton = YES;
            [((PEG_ViewDtlAdministratifView1Controller*)[self.childViewControllers objectAtIndex:0]) setTableViewEditable:YES];
        }
        
    }else if (self.pageControl.currentPage==1){
        
        BOOL v_valeur = YES;
        v_valeur=[((PEG_ViewDtlAdministratifView2Controller*)[self.childViewControllers objectAtIndex:1]) isTableViewEditable];
        
        if(v_valeur){
            if([((PEG_ViewDtlAdministratifView2Controller*)[self.childViewControllers objectAtIndex:1]) Save])
            {
                UIBarButtonItem *EditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(EditUIButtonClick:)];
                self.navigationItem.rightBarButtonItem = EditButton;
                [self.scrollView setScrollEnabled:YES];
                self.navigationItem.hidesBackButton = NO;
                [((PEG_ViewDtlAdministratifView2Controller*)[self.childViewControllers objectAtIndex:1]) setTableViewEditable:NO];
            }
        }else{
            UIBarButtonItem *SaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(EditUIButtonClick:)];
            [SaveButton setTintColor:[UIColor redColor]];
            self.navigationItem.rightBarButtonItem = SaveButton;
            [self.scrollView setScrollEnabled:NO];
            self.navigationItem.hidesBackButton = YES;
            [((PEG_ViewDtlAdministratifView2Controller*)[self.childViewControllers objectAtIndex:1]) setTableViewEditable:YES];
        }
        
    }else if (self.pageControl.currentPage==2){
        
    }
    
    if(self.VFModeCreation == true)
    {
        BeanLieu* v_BLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:self.IdLieu];
        BOOL v_isKO = false;
        if(v_BLieu != nil)
        {
            if(v_BLieu.codeActivite == nil
               || v_BLieu.respNom == nil
               || v_BLieu.liNomLieu == nil
               || v_BLieu.nomVoie == nil
               || v_BLieu.codePostal == nil
               || v_BLieu.ville == nil)
            {
                v_isKO = true;
            }
        }
        if(v_isKO)
        {
            self.navigationItem.hidesBackButton = YES;
            UIBarButtonItem *AnnulerButton = [[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:UIBarButtonItemStylePlain target:self action:@selector(AnnulerUIButtonClick:)];
            self.navigationItem.leftBarButtonItem = AnnulerButton;
        }
        else
        {
            [self.navigationItem setLeftBarButtonItem:nil animated:NO];
        }
    }

}

- (IBAction)AnnulerUIButtonClick:(id)sender
{
    
    [[PEG_FMobilitePegase CreateLieu] AnnuleCreateBeanLieu:self.IdLieu];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TimeButtonClick:(id)sender {
        [((PEG_ViewDtlAdministratifViewController*)[self.childViewControllers objectAtIndex:2]) ShowHoraireSemaine];
}

-(void) setDetailItemForCreation:(NSNumber*)p_IdLieu
{
    self.VFModeCreation = true;
    self.IdLieu = p_IdLieu;
}

-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.VFModeCreation = false;
    self.IdLieu = p_IdLieu;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View1"]];
    
    UIViewController* v_UIVC1 = [self.storyboard instantiateViewControllerWithIdentifier:@"View1"];
    [((PEG_ViewDtlAdministratifView1Controller*)v_UIVC1) setDetailItem:self.IdLieu];
    [self addChildViewController:v_UIVC1];
    
	//[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View2"]];
    UIViewController* v_UIVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"View2"];
    [((PEG_ViewDtlAdministratifView2Controller*)v_UIVC2) setDetailItem:self.IdLieu];
    [self addChildViewController:v_UIVC2];
    
    //[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View3"]];
    UIViewController* v_UIVC3 = [self.storyboard instantiateViewControllerWithIdentifier:@"View3"];
    [((PEG_ViewDtlAdministratifViewController*)v_UIVC3) setDetailItem:self.IdLieu];
    [self addChildViewController:v_UIVC3];
    
    /* Ca ne fonctionne pas
     if(self.VFModeCreation == true)
    {
        //On passe en mode edition, on simul le click
        [self EditUIButtonClick:nil];
        //[((PEG_ViewDtlAdministratifView1Controller*)[self.childViewControllers objectAtIndex:0]) setTableViewEditable:true];
    }*/
    
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    [super scrollViewDidScroll:sender];
    
    if(self.pageControl.currentPage==0){
        UIBarButtonItem *EditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(EditUIButtonClick:)];
        self.navigationItem.rightBarButtonItem = EditButton;
    }else if(self.pageControl.currentPage==1){
        UIBarButtonItem *EditButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(EditUIButtonClick:)];
        self.navigationItem.rightBarButtonItem = EditButton;
    }else if(self.pageControl.currentPage==2){
        self.navigationItem.rightBarButtonItem = nil;
        UIImage *image = [UIImage imageNamed:@"timeBlanc.png"];
        UIBarButtonItem *TimeButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(TimeButtonClick:)];
        
        self.navigationItem.rightBarButtonItem = TimeButton;
    }
    
}

@end
