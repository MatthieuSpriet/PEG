//
//  PEG_QuantiteACeJourViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 28/11/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_QuantiteACeJourViewController.h"
#import "PEG_FMobilitePegase.h"
#import "BeanPresentoir.h"
#import "PEG_QuantiteACeJourCell.h"
#import "BeanEdition.h"
#import "PEG_BeanHistoParution.h"

@interface PEG_QuantiteACeJourViewController ()

@property (strong, nonatomic) BeanPresentoir* _BeanPresentoir;
@property (strong, nonatomic) NSNumber* _idParution;

@property (strong, nonatomic) NSArray* _listeBeanHisto;
@end

@implementation PEG_QuantiteACeJourViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    BeanParution* v_BeanParution= [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:self._idParution];
    self.navigationItem.title=v_BeanParution.libelleEdition;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setDetailItem:(NSNumber*)p_IdPresentoir andIdParution:(NSNumber*)p_IdParution{
    self._BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] GetBeanPresentoirById:p_IdPresentoir];
    self._idParution = p_IdParution;
    
    self._listeBeanHisto = [[PEG_FMobilitePegase CreateLieu] GetListHistoDistriByIdPresentoir:p_IdPresentoir andIdParution:p_IdParution];
}

-(void) setDetailItem:(NSNumber*)p_IdPresentoir andIdEdition:(NSNumber*)p_IdEdition
{
    self._listeBeanHisto = [[PEG_FMobilitePegase CreateLieu] GetListHistoDistriByIdPresentoir:p_IdPresentoir andIdEdition:p_IdEdition];
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self._listeBeanHisto.count;

}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = nil;
    if(indexPath.section==0){
        
        cellIdentifier=@"cellDetailQteHisto";
         PEG_QuantiteACeJourCell* cellDtl = (PEG_QuantiteACeJourCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy"];
        /*BeanParution* v_BeanParution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:self._idParution];
        cellDtl.Noparutionlabel.text= v_BeanParution.libelleParution;
        
        cellDtl.DateLabel.text= [formatter stringFromDate:[self._listedate objectAtIndex:indexPath.row]];
        cellDtl.QteLabel.text= [[self._listeqte objectAtIndex:indexPath.row] stringValue];*/
        
        PEG_BeanHistoParution* v_bean = [self._listeBeanHisto objectAtIndex:indexPath.row];
        cellDtl.Noparutionlabel.text= v_bean.NumParution;
        cellDtl.DateLabel.text= [formatter stringFromDate:v_bean.dateDistri];
        cellDtl.QteLabel.text = [NSString stringWithFormat:@"%d",v_bean.QteDistri];
        cellDtl.QteRetourUILabel.text = [NSString stringWithFormat:@"%d",v_bean.QteRetour];
        
        return cellDtl;
    }
    
      return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        return 50;

}

@end
