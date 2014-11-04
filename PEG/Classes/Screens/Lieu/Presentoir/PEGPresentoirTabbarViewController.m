//
//  PEGPresentoirTabbarViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 30/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGPresentoirTabbarViewController.h"
#import "PEG_DtlQuantiteMaterielViewController.h"
#import "PEG_PresentoirSupprimeViewController.h"
#import "PEG_PresentoirVoleViewController.h"
#import "PEG_PresentoirChangeViewController.h"

@interface PEGPresentoirTabbarViewController ()
@property (strong, nonatomic) NSNumber* _IdPresentoir;
@property (weak, nonatomic) IBOutlet UITabBar *MyUITabBar;

@end

@implementation PEGPresentoirTabbarViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}
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
    
    UIBarButtonItem *SaveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(SaveUIButtonClick:)];
    [SaveButton setTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItem = SaveButton;
    
}

- (IBAction)SaveUIButtonClick:(id)sender {
    
    if([self.MyUITabBar selectedItem].tag == 2){
        
        UIViewController* v_viewSupprime=[self.childViewControllers objectAtIndex:2];
        [((PEG_PresentoirSupprimeViewController*)v_viewSupprime) Save];
        
    }
    else if([self.MyUITabBar selectedItem].tag == 3){
        
        UIViewController* v_viewVole=[self.childViewControllers objectAtIndex:3];
        [((PEG_PresentoirVoleViewController*)v_viewVole) Save];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setDetailItem:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber *)p_IdParution{
    self._IdPresentoir=p_IdPresentoir;
    
    UIViewController* v_view=[self.childViewControllers objectAtIndex:0];
    //UIViewController* v_view = [self.storyboard instantiateViewControllerWithIdentifier:@"QuantiteMaterielView"];
    [((PEG_DtlQuantiteMaterielViewController*)v_view) setDetailItem:self._IdPresentoir andIdParution:p_IdParution];
    
	// pm201402 was objectAtIndex:3 -- TODO: à vérifier
    UIViewController* v_viewChange=[self.childViewControllers objectAtIndex:1];
    [((PEG_PresentoirChangeViewController*)v_viewChange) setDetailItem:self._IdPresentoir];
    
    UIViewController* v_viewSupprime=[self.childViewControllers objectAtIndex:2];
    [((PEG_PresentoirSupprimeViewController*)v_viewSupprime) setDetailItem:self._IdPresentoir];
    
    
    UIViewController* v_viewVole=[self.childViewControllers objectAtIndex:3];
    [((PEG_PresentoirVoleViewController*)v_viewVole) setDetailItem:self._IdPresentoir];

}

@end
