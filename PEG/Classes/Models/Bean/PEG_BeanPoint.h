//
//  PEG_BeanPoint.h
//  PEG
//
//  Created by 10_200_11_120 on 13/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanPoint : NSObject
@property (nonatomic, strong) NSNumber* Long;
@property (nonatomic, strong) NSNumber* Lat;
@property (nonatomic, strong) NSNumber* CoordFiable;

-(id) initWithLong:(NSNumber*)p_Long AndLat:(NSNumber*)p_Lat;
-(id) initWithLong:(NSNumber*)p_Long AndLat:(NSNumber*)p_Lat AndFiable:(BOOL)p_CoordFiable;
@end
