//
//  PEG_ListeViewController.m
//  PEG
//
//  Created by HorsMedia1 on 21/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListeViewController.h"
#import "SPIROrderedDictionary.h"

@interface PEG_ListeViewController ()

- (IBAction)BtnConfirmer_Click:(id)sender;

@end

@implementation PEG_ListeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.indexSelectedRow = [[NSIndexPath alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listValues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cellPres = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cellPres == nil)
    {
        cellPres = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cellPres.textLabel.text=[NSString stringWithFormat:@"%@",[self.listValues objectAtIndex:indexPath.row]] ;
   
    cellPres.accessoryType = UITableViewCellAccessoryNone;
    if (self.indexSelectedRow)
    {
        if (self.indexSelectedRow.row == indexPath.row)
        {
            cellPres.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else
    {
        if (self.valueSelected)
        {
            if ([self.valueSelected compare:[self.listValues keyAtIndex:indexPath.row]]==NSOrderedSame)
            {
                self.indexSelectedRow = indexPath;	// ARC pm140218
                cellPres.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    return  cellPres;

}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	UITableViewCell *previousSelected = [aTableView cellForRowAtIndexPath:self.indexSelectedRow];
	previousSelected.accessoryType = UITableViewCellAccessoryNone;
	
	UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
    self.valueSelected = cell.textLabel.text;
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
	self.indexSelectedRow= indexPath;	// ARC pm140218
	
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (IBAction)BtnConfirmer_Click:(id)sender {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(formListePicker:didChoose:)])
	{
        if (self.indexSelectedRow)
        {
            [self.delegate formListePicker:self didChoose:[self.listValues keyAtIndex:self.indexSelectedRow.row]];
        }
        else
        {
            [self.delegate formListePicker:self didChoose:nil];

        }
	}
}
@end
