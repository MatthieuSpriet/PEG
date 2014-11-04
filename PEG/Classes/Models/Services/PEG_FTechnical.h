//
//  PEG _FTechnical.h
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEG_BeanPoint.h"

@interface PEG_FTechnical : NSObject

#pragma mark Gestion Date
+(NSDate*) GetDateMinValue;
+(NSDate*) GetDate2090;
+(NSDate*) GetDateYYYYMMDDFromString:(NSString*) p_YYYYMMDD;
+(NSDate*) GetDateYYYYMMDDFromDate:(NSDate*) p_Date;
+(NSString*) GetLibelleDDMMYYYYFromDateString:(NSDate*) p_Date;
+(NSDate*) getDateFromJson:(NSString*) p_datejson;
+(NSString*) getJsonFromDate:(NSDate*) p_date;
+(NSNumber*) GetSemaineEntreDeuxDatesWithDate1:(NSDate*) p_date1 AndDate2:(NSDate*) p_date2;
+(int) GetNbJourEntreDeuxDatesWithDate1:(NSDate*) p_date1 AndDate2:(NSDate*) p_date2;
+(PEG_BeanPoint*) GetCoordActuel;
+ (NSString *)paddingLeftForValue:(int)value forDigits:(int)zeros ;
+ (NSString *)genererGUID;

+(UITableViewCell*) getTableViewCellFromUI:(UITextField*)p_UITextField;

+(void) traceErrorWithMessage:(NSString*)p_Message;
+(void) traceErrorWithError:(NSError*)p_Error;
@end
