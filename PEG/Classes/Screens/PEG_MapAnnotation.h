//
//  PEG_MapAnnotation.h
//  PEG
//
//  Created by 10_200_11_120 on 29/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PEG_MapAnnotation :NSObject <MKAnnotation> {
    
	NSString *title;
	CLLocationCoordinate2D coordinate;
    NSString *subtitle;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)p_title andSubtitle:(NSString *)p_subtitle andCoordinate:(CLLocationCoordinate2D)c2d;

@end
