//
//  PEG_MapAnnotation.m
//  PEG
//
//  Created by 10_200_11_120 on 29/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_MapAnnotation.h"

@implementation PEG_MapAnnotation

@synthesize title, coordinate,subtitle;

- (id)initWithTitle:(NSString *)p_title andSubtitle:(NSString *)p_subtitle andCoordinate:(CLLocationCoordinate2D)c2d{
	if (!(self = [super init])) return nil;
	// pm201402 attention, on accede ici à des ivar, pas à des peoperties, donc c'est à nous à faire le copy correspondant à la dcl de la property
	title = [p_title copy];
    subtitle= [p_subtitle copy];
	coordinate = c2d;
    
	return self;
}

@end
