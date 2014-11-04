//
//  PEGCompteRenduWebview.m
//  PEG
//
//  Created by 10_200_11_120 on 15/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGCompteRenduWebview.h"

@implementation PEGCompteRenduWebview


- (id)init
{
    if(self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil])
	{
	
    }
    return self;
}



- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
	// Créer une URL
	NSURL *urlAddress = [NSURL URLWithString: @"http://www.google.fr"];
    
	// Faire une requête sur cette URL
	NSURLRequest *requestObject = [NSURLRequest requestWithURL:urlAddress];
    
	// Charger la requête dans la UIWebView
	[self.Webview loadRequest:requestObject];
        
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
