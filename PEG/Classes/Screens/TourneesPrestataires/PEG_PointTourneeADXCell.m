//
//  PEG_PointTourneeADXCell.m
//  PEG
//
//  Created by Pierre Marty on 27/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_PointTourneeADXCell.h"
#import "PEG_BeanPointDsgn.h"


@interface PEG_PointTourneeADXCell ()
@property (strong, nonatomic) IBOutlet UILabel *numeroPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *nomPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *nombreTacheLabel;
@property (strong, nonatomic) IBOutlet UILabel *typePresentoirLabel;
@property (strong, nonatomic) IBOutlet UILabel *communeLabel;
@property (strong, nonatomic) IBOutlet UILabel *parutionLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantitePrepareeLabel;
@end


@implementation PEG_PointTourneeADXCell



- (void)initWithPointDsgn:(PEG_BeanPointDsgn*)v_BeanPointDsgn
{
    self.numeroPointLabel.text = v_BeanPointDsgn.NumeroPoint;
    self.nomPointLabel.text = v_BeanPointDsgn.NomPoint;
    self.typePresentoirLabel.text = v_BeanPointDsgn.TypePresentoir;
    if([v_BeanPointDsgn.NombreTache intValue] == 0)
    {
        self.nombreTacheLabel.hidden = true;
    }
    else
    {
        self.nombreTacheLabel.hidden = false;
    }
    self.nombreTacheLabel.text = [v_BeanPointDsgn.NombreTache stringValue];
    self.communeLabel.text = v_BeanPointDsgn.Commune;
    self.parutionLabel.text = v_BeanPointDsgn.Parution;
    self.quantitePrepareeLabel.text = [v_BeanPointDsgn.QuantitePreparee stringValue];
    self.quantiteDistribueeTextField.text = [v_BeanPointDsgn.QuantiteDistribuee stringValue];
    self.quantiteRetourTextField.text = [v_BeanPointDsgn.QuantiteRetour stringValue];
}

- (IBAction)BtnCopieQtePreviTouchUpInsiade:(id)sender {
    /*self.QuantiteDistribueeUITextField.text = self.QuantitePrepareeUILabel.text;
     if(self.QuantiteDistribueeUITextField.text.length > 0)
     {
     int v_Qte = [self.QuantiteDistribueeUITextField.text intValue];
     if(v_Qte > 0){
     BeanLieuPassage* v_LP = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuPassageById:self.IdLieuPassage];
     [[PEG_FMobilitePegase CreateLieu] AddOrUpdateQteDistribueByIdLieu:v_LP.idLieu andIdPresentoir:self.IdPresentoir andIdParution:self.IdParution andQte:[[NSNumber alloc] initWithInt:v_Qte]];
     }
     }*/
    
}

@end




