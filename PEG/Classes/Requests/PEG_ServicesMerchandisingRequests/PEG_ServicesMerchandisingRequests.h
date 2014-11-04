//
//  PEG_ServicesMerchandisingRequests.h
//  PEG
//
//  Created by 10_200_11_120 on 24/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEGBaseRequest.h"
#import "PEG_BeanImage.h"
//#import "PEG_BeanSuiviKMUtilisateur.h"

@interface PEG_ServicesMerchandisingRequests : PEGBaseRequest

+ (PEG_ServicesMerchandisingRequests *)requestGetLastSuiviKilometreByMatricule:(NSString*)p_Matricule;
- (BOOL)processResponseGetLastSuiviKilometre;

+ (PEG_ServicesMerchandisingRequests *)requestSetBeanSuiviKilometreByMatriculeDate:(NSString*)p_Matricule andDate:(NSDate*)p_Date andKm:(NSNumber*)p_Km;
//- (void)processResponseSetBeanSuiviKilometre:(PEG_BeanSuiviKMUtilisateur*) p_ObjectToFill;


+ (PEG_ServicesMerchandisingRequests *)requestGetImageByIdPointLivraison:(int)p_IdPointLivraison;
+ (PEG_ServicesMerchandisingRequests *)requestSaveImage:(PEG_BeanImage*)p_BeanImage;
- (UIImage*)processResponseGetImageByIdPointLivraison;
- (BOOL)processResponseSaveImage;
@end
