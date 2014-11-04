//
//  PEGWebServices.h
//  PEG
//
//  Created by Pierre Marty on 21/02/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEG_BeanCommunication.h"
#import "PEG_BeanImage.h"
#import "AFNetworking.h"

@interface PEGWebServices : NSObject

@property (nonatomic, strong) AFHTTPRequestOperationManager* mymanager;

+ (PEGWebServices*)sharedWebServices;		// singleton

- (void)getLastSuiviKilometreByMatricule:(NSString*)matricule succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure;

- (void)getBeanMobilitePegaseByMatricule:(NSString*)p_Matricule andDate:(NSDate*)p_Date succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure;

- (void)getBeanTourneeByMatricule:(NSString*)p_Matricule andDateDebut:(NSDate*)p_DateDebut andDateFin:(NSDate*)p_DateFin succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure;

- (void)saveBeanMobilitePegaseWithSucces:(void (^)(void))succes failure:(void (^)(NSError *error))failure;

- (void)GetBeanCommunicationByIDRequest:(NSNumber*)p_id succes:(void (^)(PEG_BeanCommunication* p_BeanCommunication))succes failure:(void (^)(NSError *error))failure;

- (void)Login:(NSString*)p_Login andPassword:(NSString*) p_Password succes:(void (^)(bool p_IsAuthentified))succes failure:(void (^)(NSError *error))failure;

- (void)getBeanTourneeADXByMatricule:(NSString*)p_Matricule andDateDebut:(NSDate*)p_DateDebut andDateFin:(NSDate*)p_DateFin succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure;

- (void)getBeanimageByIdPointLivraison:(int)p_IdPointLivraison succes:(void (^)(UIImage* p_image))succes failure:(void (^)(NSError *error))failure;
- (void)getImageStreamByIdPointLivraison:(int)p_IdPointLivraison succes:(void (^)(UIImage* p_image))succes failure:(void (^)(NSError *error))failure;

- (void)saveBeanImage:(PEG_BeanImage*)p_BeanImage succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure;
@end
