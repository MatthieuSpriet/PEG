//
//  PEG_BeanException.h
//  PEG
//
//  Created by 10_200_11_120 on 13/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanException : NSObject

@property (nonatomic,strong) NSString* Exception;
@property (nonatomic,strong) NSString* Message;
@property (nonatomic,strong) NSMutableArray* Parametres;


-(NSMutableDictionary* ) objectToJson;

-(void) LogError;

@end
