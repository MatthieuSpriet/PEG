//
//  PEG_BaseUIViewController.m
//  PEG
//
//  Created by Pierre Marty on 28/05/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_BaseUIViewController.h"

@implementation PEG_BaseUIViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    const char *name =  object_getClassName(self);
    self.screenName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    DLog (@"viewWillAppear: %@", self.screenName);
}

@end
