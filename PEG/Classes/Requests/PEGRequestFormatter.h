//
//  ADXRequestFormatter.h
//  ADX
//
//  Created by Antoine Marcadet on 06/06/12.
//  Copyright (c) 2012 SQLI Agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRMustacheTemplateDelegate.h"

@interface PEGRequestFormatter : NSObject <GRMustacheTemplateDelegate>

@property (nonatomic, strong) NSMutableArray *templateNumberFormatterStack;
@property (nonatomic, strong) NSMutableArray *templateDateFormatterStack;

@end
