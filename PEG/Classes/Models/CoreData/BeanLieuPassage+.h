//
//  BeanLieuPassage+.h
//  PEG
//
//  Created by Horsmedia3 on 24/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanLieuPassage.h"

@interface BeanLieuPassage(addListActionObject)

-(void) addListActionObject:(BeanAction*)p_BeanAction;
-(void) setFlagMAJ:(NSString*)p_FlagMAJ;

@end
