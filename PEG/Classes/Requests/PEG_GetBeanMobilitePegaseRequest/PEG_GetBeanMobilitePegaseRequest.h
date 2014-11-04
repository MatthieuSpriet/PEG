//
//  PEG_GetBeanMobilitePegaseRequest.h
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEGBaseRequest.h"
//#import "PEG_BeanMobilitePegase.h"

@interface PEG_GetBeanMobilitePegaseRequest : PEGBaseRequest
<UIAlertViewDelegate>

+ (PEG_GetBeanMobilitePegaseRequest *)requestGetBeanMobilitePegaseByMatricule:(NSString*)p_Matricule andDate:(NSDate*)p_Date;
- (BOOL)processResponse;

+ (PEG_GetBeanMobilitePegaseRequest *)requestGetBeanTourneeByMatricule:(NSString*)p_Matricule andDateDebut:(NSDate*)p_DateDebut andDateFin:(NSDate*)p_DateFin;
- (BOOL)processResponseGetBeanTourneeByMatricule;

+ (PEG_GetBeanMobilitePegaseRequest *)requestSaveBeanMobilitePegase;
-(BOOL) processResponseSave;

@end
