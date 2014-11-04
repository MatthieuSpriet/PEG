//
//  PEG_ListeLieuCell.m
//  PEG
//
//  Created by 10_200_11_120 on 13/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_ListeLieuCell.h"

@implementation PEG_ListeLieuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if(self.NomLieuUILabel == nil) self.NomLieuUILabel = [[UILabel alloc] init];
        if(self.NbTacheUILabel == nil) self.NbTacheUILabel = [[UILabel alloc] init];
        if(self.TypePres1UILabel == nil) self.TypePres1UILabel = [[UILabel alloc] init];
        if(self.EditionPres1UILabel == nil) self.EditionPres1UILabel = [[UILabel alloc] init];
        if(self.QteDistribueePres1UILabel == nil) self.QteDistribueePres1UILabel = [[UILabel alloc] init];
        if(self.QteRetourPres1UILabel == nil) self.QteRetourPres1UILabel = [[UILabel alloc] init];
        if(self.TypePres2UILabel == nil) self.TypePres2UILabel = [[UILabel alloc] init];
        if(self.EditionPres2UILabel == nil) self.EditionPres2UILabel = [[UILabel alloc] init];
        if(self.QteDistribueePres2UILabel == nil) self.QteDistribueePres2UILabel = [[UILabel alloc] init];
        if(self.QteRetourPres2UILabel == nil) self.QteRetourPres2UILabel = [[UILabel alloc] init];
        if(self.DistanceTempsUILabel == nil) self.DistanceTempsUILabel = [[UILabel alloc] init];
        if(self.PresentoirSuivantUILabel == nil) self.PresentoirSuivantUILabel = [[UILabel alloc] init];
        if(self.ListCodePresentoirUILabel == nil) self.ListCodePresentoirUILabel = [[UILabel alloc] init];
        if(self.AdresseUILabel == nil) self.AdresseUILabel = [[UILabel alloc] init];
    }
    return self;
}
-(void) initDataWithPointDsg:(PEG_BeanPointDsgn*) p_PointDsg
{
    if(self.NomLieuUILabel == nil) self.NomLieuUILabel = [[UILabel alloc] init];
    self.NomLieuUILabel.text = p_PointDsg.NomPoint;
    if(p_PointDsg.NombreTache>0 ){
        self.NbTacheUILabel.text = [p_PointDsg.NombreTache stringValue];
        [self.NbTacheUILabel setHidden:NO];
    }else{
        [self.NbTacheUILabel setHidden:YES];
    }
    self.TypePres1UILabel.text = p_PointDsg.TypePresentoir;
    self.EditionPres1UILabel.text = p_PointDsg.Parution;
    self.QteDistribueePres1UILabel.text = [p_PointDsg.QuantiteDistribuee stringValue];
    self.QteRetourPres1UILabel.text = [p_PointDsg.QuantiteRetour stringValue];
    self.TypePres2UILabel.text = p_PointDsg.TypePresentoir2;
    self.EditionPres2UILabel.text = p_PointDsg.Parution2;
    self.QteDistribueePres2UILabel.text = [p_PointDsg.QuantiteDistribuee2 stringValue];
    self.QteRetourPres2UILabel.text = [p_PointDsg.QuantiteRetour2 stringValue];
    if([p_PointDsg.NbMetre intValue] < 9000)
    {
        self.DistanceTempsUILabel.text=[NSString stringWithFormat:@"%im %is",[p_PointDsg.NbMetre intValue],[p_PointDsg.NbSemaine intValue]];
    }
    else
    {
        self.DistanceTempsUILabel.text=[NSString stringWithFormat:@"%ikm %is",([p_PointDsg.NbMetre intValue] / 1000),[p_PointDsg.NbSemaine intValue]];
    }
    //self.DistanceTempsUILabel.text = [NSString stringWithFormat:@"%im %is",[p_PointDsg.NbMetre intValue],[p_PointDsg.NbSemaine intValue]];
    if(p_PointDsg.PlusDeTroisPresentoir)
    {
        self.PresentoirSuivantUILabel.text = @"...";
    }
    else
    {
        self.PresentoirSuivantUILabel.text = @"";
    }
    self.ListCodePresentoirUILabel.text = p_PointDsg.ListeTypePresentoirString;
    self.AdresseUILabel.text = p_PointDsg.Adresse;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
