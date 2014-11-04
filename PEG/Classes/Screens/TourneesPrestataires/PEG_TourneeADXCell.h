//
//  PEG_TourneeADXCell.h
//  PEG
//
//  Created by Pierre Marty on 26/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEG_TourneeADXCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *NomTourneeUILabel;
@property (strong, nonatomic) IBOutlet UILabel *DateTourneeUILabel;
@property (strong, nonatomic) IBOutlet UILabel *LibelleMagazineUILabel;
@property (strong, nonatomic) IBOutlet UILabel *NbLieuUILabel;
@property (weak, nonatomic) IBOutlet UILabel *FaitUILabel;


-(void) initWithNomTournees:(NSString*)p_nomTournees andDateTournee:(NSDate*)p_dateTournee andNbTache:(NSNumber*)p_nbTache andNbLieux:(NSNumber*)p_nbLieux andLibelleMagazine:(NSString*)p_libMagazine andIdTournee:(NSNumber*)p_IdTournee;

@end
