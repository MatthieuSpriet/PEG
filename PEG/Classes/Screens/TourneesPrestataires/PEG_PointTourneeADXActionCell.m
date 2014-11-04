//
//  PEG_PointTourneeADXActionCell.m
//  PEG
//
//  Created by Pierre Marty on 28/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_PointTourneeADXActionCell.h"
#import "BeanPresentoir.h"
#import "PEG_ActionPresentoirServices.h"
#import "PEG_FMobilitePegase.h"

@implementation PEG_PointTourneeADXActionCell 

- (void)setDetailItem:(NSString*) p_Action
{
}


- (IBAction)todoControlChanged:(id)sender
{
    UISegmentedControl* v_UISegmentedControl= ((UISegmentedControl*) sender);
    DLog (@"todoControlChanged : %d", v_UISegmentedControl.selectedSegmentIndex);
    
    NSString* v_CodeMatos = self.CodeMateriel;
    if (v_UISegmentedControl.selectedSegmentIndex==0) {     // action "à faire"
        if(self.IsActionPresentoir == YES)
        {
            [[PEG_FMobilitePegase CreateActionPresentoirADX] UpdatePresentoirTacheByPresentoir:[[NSNumber alloc] initWithInt:self.IdPresentoir ] andTache:v_CodeMatos andAFaire:true];
        }
        else
        {
            
            [[PEG_FMobilitePegase CreateActionPresentoirADX] UpdateLieuTacheByLieu:[[NSNumber alloc] initWithInt:self.IdLieu ] andTache:v_CodeMatos andAFaire:true];
        }
    }
    else {  // "RAS"
        if(self.IsActionPresentoir == YES)
        {
        [[PEG_FMobilitePegase CreateActionPresentoirADX] UpdatePresentoirTacheByPresentoir:[[NSNumber alloc]initWithInt:self.IdPresentoir] andTache:v_CodeMatos andAFaire:false];
        }
        else
        {
            [[PEG_FMobilitePegase CreateActionPresentoirADX] UpdateLieuTacheByLieu:[[NSNumber alloc]initWithInt:self.IdLieu] andTache:v_CodeMatos andAFaire:false];
        }
    }
}




@end
