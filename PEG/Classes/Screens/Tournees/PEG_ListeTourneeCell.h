//
//  PEG_ListeTourneeCell.h
//  PEG
//
//  Created by HorsMedia1 on 17/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_ListeTourneeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *NomTourneeUILabel;
@property (strong, nonatomic) IBOutlet UILabel *DateTourneeUILabel;
@property (strong, nonatomic) IBOutlet UILabel *NbTacheUILabel;
@property (strong, nonatomic) IBOutlet UILabel *LibelleMagazineUILabel;
@property (strong, nonatomic) IBOutlet UILabel *NbLieuUILabel;


-(void) initDataWithNomTournees:(NSString*) p_nomTournees andDateTournee:(NSDate*)p_dateTournee andNbTache:(NSNumber*)p_nbTache andNbLieux:(NSNumber*)p_nbLieux andLibelleMagazine:(NSString*)p_libMagazine;

@end
