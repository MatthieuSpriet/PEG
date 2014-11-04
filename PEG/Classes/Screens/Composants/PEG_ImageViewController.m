//
//  PEG_ImageViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 29/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ImageViewController.h"
#import "PEG_BeanImage.h"
@interface PEG_ImageViewController ()
@property (strong, nonatomic) PEG_BeanImage* ImageCourante;
@end

@implementation PEG_ImageViewController

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
    self.Imageview.userInteractionEnabled = YES;
    [self.Imageview setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.Imageview.image= self.ImageCourante.Image;
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    tapper.numberOfTapsRequired = 1;
    tapper.delegate = self;
    [self.Imageview addGestureRecognizer:tapper];
}

-(void)SetDetailItem:(PEG_BeanImage*)p_image {
    self.ImageCourante=p_image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageview:nil];
    [super viewDidUnload];
}
-(void)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}
@end
