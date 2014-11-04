//
//  PEG_DatePickerViewController.m
//  PEG
//
//  Created by HorsMedia1 on 20/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_DatePickerViewController.h"

@interface PEG_DatePickerViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerUIDatePicker;
- (IBAction)BtnChoisirUIButton:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItemUINavigationItem;

@end

@implementation PEG_DatePickerViewController

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
    
    [self.datePickerUIDatePicker setDate: (self.date == nil?[NSDate date]:self.date)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)DatePicker_ValueChanged:(id)sender {
    self.date = ((UIDatePicker *)sender).date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE d MMMM"];
    [self.navigationItemUINavigationItem setTitle:[dateFormat stringFromDate:self.date]];
    
}

- (IBAction)BtnChoisirUIButton:(id)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(formDatePicker:didChooseDate:)])
	{
		[self.delegate formDatePicker:self didChooseDate:self.date != nil ? self.date : [NSDate date]];
	}
}
@end
