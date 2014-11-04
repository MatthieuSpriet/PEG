//
//  PEG_BeanPoint.m
//  PEG
//
//  Created by 10_200_11_120 on 13/08/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanPoint.h"

@implementation PEG_BeanPoint

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {Long :%@,Lat :%@,CoorFiable :%@}",
            NSStringFromClass([self class]),
            self,
            self.Long,
            self.Lat,
            self.CoordFiable
            ];
    
}

-(id) initWithLong:(NSNumber*)p_Long AndLat:(NSNumber*)p_Lat
{
    self = [super init];    // pm_06
    self.Long = p_Long;
    self.Lat = p_Lat;
    
    return self;
}
-(id) initWithLong:(NSNumber*)p_Long AndLat:(NSNumber*)p_Lat AndFiable:(BOOL)p_CoordFiable
{
    self = [super init];    // pm_06
    self.Long = p_Long;
    self.Lat = p_Lat;
    self.CoordFiable = [[NSNumber alloc] initWithBool:p_CoordFiable];
    
    return self;
}



@end
