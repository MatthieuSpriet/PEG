//
//  PEG_ModuleCommunicationRequest.h
//  PEG
//
//  Created by 10_200_11_120 on 10/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEGBaseRequest.h"
#import "PEG_BeanCommunication.h"

@interface PEG_ModuleCommunicationRequest : PEGBaseRequest

+(PEG_ModuleCommunicationRequest *)GetBeanCommunicationByIDRequest:(NSNumber*)p_id;

-(PEG_BeanCommunication*)processResponse;
@end
