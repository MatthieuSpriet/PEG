//
//  PEG_ModuleCommunicationRequest.m
//  PEG
//
//  Created by 10_200_11_120 on 10/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_ModuleCommunicationRequest.h"
#import "PEGParametres.h"
#import "PEG_BeanException.h"

@implementation PEG_ModuleCommunicationRequest

+(PEG_ModuleCommunicationRequest *)GetBeanCommunicationByIDRequest:(NSNumber*)p_id{

    PEG_ModuleCommunicationRequest *request;
    
    @try{
        
        PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
        
        NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesModuleCom"];
        
        NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/getListBeanModulecommunicationForAllRest?App=Pegase&sequence=%@",UrlWebservice,p_id];
        
        DLog(@"=>request: %@ ",renderUrl);
        NSURL* url = [NSURL URLWithString:renderUrl];
        
        request = [PEG_ModuleCommunicationRequest requestWithURL:url];
        
        [request setSpecificTimeOutSeconds:600];
        [request configureRequestInJsonCompressedFormat];
        
        
    }@catch(NSException* p_exception){
    }
	return request;

}

- (void)dealloc {
	NSLog (@"PEG_ModuleCommunicationRequest dealloc");	// pm1400218 test leak with blocks zzz
}

-(PEG_BeanCommunication*)processResponse{
    
    PEG_BeanCommunication* v_PEG_BeanCommunication=[[PEG_BeanCommunication alloc]init];
    @try{
    
        

        NSDictionary* responseDictionary = [super processResponseWithJsonKeyPath];
        DLog(@"=>reponse: %@ ",responseDictionary);
        
        
        if (responseDictionary !=nil && [responseDictionary count]!=0)
        {
//            NSArray* liste = [responseDictionary arrayForKeyPath:@"BeanModulecommunication"];
//            for (NSDictionary* v_BeanModulecommunication in liste)
//            {
                //PEG_BeanCommunication* v_PEG_BeanCommunication=[[PEG_BeanCommunication alloc]init];
                NSString* v_msg = [responseDictionary stringForKeyPath:@"Msg"];
                NSString* v_Typemsg = [responseDictionary stringForKeyPath:@"typeMsg"];
                v_PEG_BeanCommunication.Message=v_msg;
                v_PEG_BeanCommunication.TypeMessage=v_Typemsg;
                v_PEG_BeanCommunication.idsequence= [[responseDictionary stringForKeyPath:@"seq"] integerValue];
         //   }
          
        }
        
    }@catch(NSException* p_exception){
        
       
    }
    return v_PEG_BeanCommunication;

}

@end
