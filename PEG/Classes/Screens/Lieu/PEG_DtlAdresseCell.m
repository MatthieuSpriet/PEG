//
//  PEG_DtlAdresseCell.m
//  PEG
//
//  Created by 10_200_11_120 on 10/09/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_DtlAdresseCell.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_FTechnical.h"

@implementation PEG_DtlAdresseCell

- (IBAction)GeolocalisationTouchUpInsideButon:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          
                          initWithTitle:@"Géolocalisation"
                          message:@"Mise à jour coordonnées?"
                          delegate:self
                          cancelButtonTitle:@"Non"
                          otherButtonTitles:@"Oui",nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Oui"])
    {
        PEG_BeanPoint* v_Pt = [PEG_FTechnical GetCoordActuel];
        [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdateLieuCoordonneeByIdLieu:[[NSNumber alloc] initWithInt:self.IdLieu] andBeanPoint:v_Pt];
        [self.DtlLieuUITableView reloadData];
    }
}

@end
