//
//  PEG_PointTourneeADXViewController.m
//  PEG
//
//  Created by Pierre Marty on 27/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

//
// L'écran avec les actions possibles pour un point de la tournée ADX (IP09)
// On ne doit avoir qu'un seul présentoire, avec une liste d'actions possibles
//


#import "PEG_PointTourneeADXViewController.h"
#import "PEG_FMobilitePegase.h"
#import "PEG_PointTourneeADXActionCell.h"
#import "PEG_BeanPresentoirParution.h"
#import "PEG_BeanPointDsgn.h"

@interface PEG_PointTourneeADXViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) PEG_BeanPointDsgn* PointDesign;
@property (strong, nonatomic) NSArray* listActionPres;      // array of BeanChoix*
@property (strong, nonatomic) NSArray* listActionADX;      // array of BeanChoix*
// @property (strong, nonatomic) BeanParution* parution;
@end


@implementation PEG_PointTourneeADXViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setDetailItem:(PEG_BeanPointDsgn*)p_BeanPointDsg
{
    self.PointDesign = p_BeanPointDsg;
    
    self.listActionPres = [[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixMaterielByTypePresentoir:self.PointDesign.TypePresentoir];
    self.listActionADX = [[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixInfosADX];

}


#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section == 0)
    {
        title = @"Matériel";
    }
    else
    {
        title = @"Info";
    }
    return title;
}


// on a 2 sections : une dynamique pour le materiel (dépendante du matériel) et une des info que peut remonter le distributeur ADX
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    if (section == 0)
    {
        numberOfRows = self.listActionPres.count;
    }
    else
    {
        numberOfRows = self.listActionADX.count;
    }
    return numberOfRows;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"action";
    PEG_PointTourneeADXActionCell* cellDtl = (PEG_PointTourneeADXActionCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cellDtl == nil)
    {
        UIViewController *c = [[UIViewController alloc] initWithNibName:@"PEG_PointTourneeADXActionCell" bundle:nil];
        cellDtl = (PEG_PointTourneeADXActionCell*) c.view;
    }
    if (indexPath.section == 0)
    {
    BeanChoix* v_beanchoix  = [self.listActionPres objectAtIndex:indexPath.item];
        cellDtl.actionUILabel.text=v_beanchoix.libelle;
        cellDtl.CodeMateriel = v_beanchoix.code;
        cellDtl.IsActionPresentoir = YES;
    
    
    if([[PEG_FMobilitePegase CreatePresentoir] IsTacheAFaireIsOnPresentoir:v_beanchoix.code andIdPresentoir:self.PointDesign.IdPresentoir]){
        cellDtl.TachesSegControl.selectedSegmentIndex=0;
    }else{
        cellDtl.TachesSegControl.selectedSegmentIndex=1;
    }
    
        cellDtl.TachesSegControl.tag= [v_beanchoix.idItemListChoix intValue];
        cellDtl.IdLieuPassage = [self.PointDesign.IdLieuPassage intValue];
        cellDtl.IdLieu = [self.PointDesign.IdLieu intValue];
    cellDtl.IdPresentoir = [self.PointDesign.IdPresentoir intValue];
    }
    else
    {
        BeanChoix* v_beanchoix  = [self.listActionADX objectAtIndex:indexPath.item];
        cellDtl.actionUILabel.text=v_beanchoix.libelle;
        cellDtl.CodeMateriel = v_beanchoix.code;
        cellDtl.IsActionPresentoir = NO;
        
        
        if([[PEG_FMobilitePegase CreateLieu] IsTacheAFaireIsOnLieu:v_beanchoix.code andIdLieu:self.PointDesign.IdLieu]){
         cellDtl.TachesSegControl.selectedSegmentIndex=0;
         }else{
         cellDtl.TachesSegControl.selectedSegmentIndex=1;
         }
        
        cellDtl.TachesSegControl.tag= [v_beanchoix.idItemListChoix intValue];
        cellDtl.IdLieuPassage = [self.PointDesign.IdLieuPassage intValue];
        cellDtl.IdLieu = [self.PointDesign.IdLieu intValue];
        cellDtl.IdPresentoir = [self.PointDesign.IdPresentoir intValue];
    }
    return cellDtl;
}




@end
