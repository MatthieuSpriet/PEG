//
//  PEG_MapCartoViewController.h
//  PEG
//
//  Created by 10_200_11_120 on 29/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PEG_MapCartoViewController : PEG_BaseUIViewController {
    
	MKMapView *mapView;
    
}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

-(void) setDetailItem:(NSNumber*)p_IdLieu;
@end
