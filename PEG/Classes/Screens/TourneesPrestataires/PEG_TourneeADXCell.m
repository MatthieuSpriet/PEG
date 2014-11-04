//
//  PEG_TourneeADXCell.m
//  PEG
//
//  Created by Pierre Marty on 26/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_TourneeADXCell.h"
#import "PEG_FMobilitePegase.h"

@implementation PEG_TourneeADXCell


-(void) initWithNomTournees:(NSString*) p_nomTournees andDateTournee:(NSDate*)p_dateTournee andNbTache:(NSNumber*)p_nbTache andNbLieux:(NSNumber*)p_nbLieux andLibelleMagazine:(NSString*)p_libMagazine andIdTournee:(NSNumber*)p_IdTournee
{
    self.NomTourneeUILabel.text=p_nomTournees;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString* v_dateStr = [formatter stringFromDate:p_dateTournee];
    
    self.DateTourneeUILabel.text= v_dateStr;
    
    self.FaitUILabel.hidden= ![[PEG_FMobilitePegase CreateTourneeADX] IsCompteRenduTourneeTermineeByIdTournee:p_IdTournee];
    self.NbLieuUILabel.text = [p_nbLieux stringValue];
    self.LibelleMagazineUILabel.text= p_libMagazine;
}


@end
