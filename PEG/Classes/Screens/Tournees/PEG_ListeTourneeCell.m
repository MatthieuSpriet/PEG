//
//  PEG_ListeTourneeCell.m
//  PEG
//
//  Created by HorsMedia1 on 17/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListeTourneeCell.h"

@implementation PEG_ListeTourneeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) initDataWithNomTournees:(NSString*) p_nomTournees andDateTournee:(NSDate*)p_dateTournee andNbTache:(NSNumber*)p_nbTache andNbLieux:(NSNumber*)p_nbLieux andLibelleMagazine:(NSString*)p_libMagazine
{
    self.NomTourneeUILabel.text=p_nomTournees;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString* v_dateStr = [formatter stringFromDate:p_dateTournee];
    
    self.DateTourneeUILabel.text= v_dateStr;
    if([p_nbTache intValue] == 0)
    {
        self.NbTacheUILabel.hidden = true;
    }
    else
    {
        self.NbTacheUILabel.hidden = false;
    }
    self.NbTacheUILabel.text= [p_nbTache stringValue];
    self.NbLieuUILabel.text = [p_nbLieux stringValue];
    self.LibelleMagazineUILabel.text= p_libMagazine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    //NSString* v_NomTournee=@"kk";
    DLog(@"%d",indexPath.row);
}

@end
