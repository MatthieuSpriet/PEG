//
//  PEG_AdminChoixHoraireViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 18/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanHoraire.h"
#import "BeanLieu.h"

@interface PEG_AdminChoixHoraireViewController : PEG_BaseUIViewController


-(void) setDetailItemForJour:(NSNumber*)p_Jour andAMDebut:(NSDate*)p_AMDebut andAMFin:(NSDate*)p_AMFin andPMDebut:(NSDate*)p_PMDebut andPMFin:(NSDate*)p_PMFin andLieu:(BeanLieu*)p_BeanLieu;

-(void) setContextSemaineComplete:(BeanLieu*)p_BeanLieu;
@end
