//
//  PEG_ParutionServices.h
//  PEG
//
//  Created by 10_200_11_120 on 09/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanParution.h"

@interface PEG_ParutionServices : NSObject

-(BeanParution*) GetBeanParutionById:(NSNumber *)p_idParution;
-(BeanParution*) GetBeanParutionSuivanteById:(NSNumber *)p_idParution;
-(BeanParution*) GetBeanParutionCouranteByIdEdition:(NSNumber *)p_idEdition;
-(NSArray*) GetListBeanParutionCouranteByCP:(NSString*)p_CodePostal;
-(NSArray*) GetListBeanParutionCourante;
@end
