//
//  PEG_ListRelationnelViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 24/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListRelationnelViewController.h"
#import "PEG_SaisieCadeauxViewController.h"
#import "PEG_RelationnelCell.h"
#import "PEG_FMobilitePegase.h"

@interface PEG_ListRelationnelViewController ()

@end

@implementation PEG_ListRelationnelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)DoneClicked:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(formActionMinuteFinished:)])
	{
		// pm140218 probably a copy/paste mismatch. self is a PEG_ListRelationnelViewController, not a PEG_ActionMinuteViewController !
		// [self.delegate formActionMinuteFinished:self];
		[self.delegate formListRelationnelFinished:self];
	}
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(section==0){
        return 2;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PEG_RelationnelCell *cell=nil;
    
    if(indexPath.section==0){
        if(indexPath.row==0){
            static NSString *CellIdentifier = @"cellRelationnel";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.idLieu = [self.BeanLieu.idLieu intValue];
            cell.IsRelationnel = [[PEG_FMobilitePegase CreateActionPresentoir] IsLieuRelationnelByIdLieu:self.BeanLieu.idLieu];
            [cell SetValue];
        }
        if(indexPath.row==1){
            static NSString *CellIdentifier = @"cellSaisir";
            cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
        }
        
    }
    
    return cell;
}
#pragma mark Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"PushSaisieCadeau"])
    {
        [((PEG_SaisieCadeauxViewController*)[segue destinationViewController]) setDetailItem:self.BeanLieu.idLieu];
    }
}

@end
