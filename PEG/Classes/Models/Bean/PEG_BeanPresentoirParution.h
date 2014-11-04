//
//  PEG_BeanPresentoirParution.h
//  PEG
//
//  Created by Horsmedia3 on 08/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanPresentoir.h"
#import "BeanParution.h"

@interface PEG_BeanPresentoirParution : NSObject
@property (nonatomic, strong) BeanPresentoir* Presentoir;
@property (nonatomic, strong) BeanParution* Parution;
@property (nonatomic, assign) BOOL IsFirstPres;
@end
