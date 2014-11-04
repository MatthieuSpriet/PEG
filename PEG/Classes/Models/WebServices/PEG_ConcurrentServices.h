//
//  PEG_ConcurrentServices.h
//  PEG
//
//  Created by 10_200_11_120 on 28/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanConcurents.h"
#import "BeanLieu.h"
#import "BeanConcurentLieu.h"

@interface PEG_ConcurrentServices : NSObject

-(NSMutableArray*) GetAllBeanConcurents;
-(BeanConcurents*) GetBeanConcurentsById:(NSNumber *)p_idConcurent;
-(NSArray*) GetBeanConcurentLieuByLieu:(BeanLieu *)p_BeanLieu;
-(void)AddOrReplaceConcurrent:(NSNumber*)p_idConcurent AndBeanLieu:(BeanLieu *)p_BeanLieu andFamille:(NSString*)p_Famille andEmplacement:(NSString*)p_Emplacement;
-(int) GetNbConcurentLieuByLieu:(BeanLieu *)p_BeanLieu;
-(void)DeleteConcurenFortLieu:(BeanLieu*)p_BeanLieu andIdConcurent:(NSNumber*)p_idConcurrence;
-(void)UpdateSansConcurrentByBeanLieu:(BeanLieu *)p_BeanLieu andSansConcurent:(BOOL)p_VFSansConcurent;
@end
