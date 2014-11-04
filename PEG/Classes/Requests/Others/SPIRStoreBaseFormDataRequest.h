//
//  SPIRBaseFormDataRequest.h
//  SPIR
//
//  Created by Frédéric JOUANNAUD on 01/03/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "SPIRRequestProtocol.h"

@interface SPIRStoreBaseFormDataRequest : ASIFormDataRequest <SPIRRequestProtocol>

- (id)processResponseWithString:(NSString *)response;

@end
