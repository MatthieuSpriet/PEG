//
//  PEG _FTechnical.m
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_FTechnical.h"
#import "PEGAppDelegate.h"
#import "PEGSession.h"
#import "BeanLogError.h"
#import "PEG_FMobilitePegase.h"

@implementation PEG_FTechnical

+(NSDate*) GetDateMinValue
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *myDate = [df dateFromString: @"0001-01-01 00:00:00"];
    return myDate;
}

+(NSDate*) GetDate2090
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *myDate = [df dateFromString: @"2090-12-31 00:00:00"];
    return myDate;
}

+(NSDate*) GetDateYYYYMMDDFromString:(NSString*) p_YYYYMMDD
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    [df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *myDate = [df dateFromString: p_YYYYMMDD];
    return myDate;
}
+(NSDate*) GetDateYYYYMMDDFromDate:(NSDate*) p_Date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:p_Date];
    return [calendar dateFromComponents:components];
}

+(NSString*) GetLibelleDDMMYYYYFromDateString:(NSDate*) p_Date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString* v_retour = [formatter stringFromDate:p_Date];
    return v_retour;
}


+(NSDate*) getDateFromJson:(NSString*) p_datejson
{
    if([p_datejson isEqualToString:@""])
        return nil;
    else if(p_datejson == nil)
        return  nil;
    else
    {
        NSInteger localOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
        
        NSInteger startPosition = [p_datejson rangeOfString:@"("].location + 1; //start of the date value
        
        NSTimeInterval unixTime = [[p_datejson substringWithRange:NSMakeRange(startPosition, 13)] doubleValue] / 1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
        
        NSInteger v_originalOffset = 0;
        if(p_datejson.length >= startPosition+17)
        {
            //Si un offset est indiqué dans le JSON, on le deduit de l'unixTime, pour repasser en UTC
            
            /*NSString* v_mmm  =[p_datejson substringWithRange:NSMakeRange(startPosition+13, 1)];
            v_mmm  =[p_datejson substringWithRange:NSMakeRange(startPosition+14, 2)];
            v_mmm  =[p_datejson substringWithRange:NSMakeRange(startPosition+16, 2)];*/
            v_originalOffset += [[p_datejson substringWithRange:NSMakeRange(startPosition+14, 2)] integerValue] * 3600;
            v_originalOffset += [[p_datejson substringWithRange:NSMakeRange(startPosition+16, 2)] integerValue] * 60;
            if([[p_datejson substringWithRange:NSMakeRange(startPosition+13, 1)] isEqualToString:@"+"])
            {
                v_originalOffset*= -1;
            }
        }
        
        NSDate* v_date = [[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:(v_originalOffset+localOffset) ];
        
        return v_date;
    }     
    
    
    
}

static NSDateFormatter* _formatter_Z;
+(NSString*) getJsonFromDate:(NSDate*) p_date
{
    NSString* v_jsonDate = nil;
    if(p_date != nil)
    {
        if(_formatter_Z == nil)
        {
            _formatter_Z =[[NSDateFormatter alloc] init];
            [_formatter_Z setDateFormat:@"Z"]; //for getting the timezone part of the date only.
        }
        //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"Z"]; //for getting the timezone part of the date only.
        v_jsonDate = [NSString stringWithFormat:@"/Date(%.0f000%@)/", [p_date timeIntervalSince1970],[_formatter_Z stringFromDate:p_date]];
    }
    return v_jsonDate;
    
}

+(NSNumber*) GetSemaineEntreDeuxDatesWithDate1:(NSDate*) p_date1 AndDate2:(NSDate*) p_date2
{
    NSNumber* v_retour = nil;
    if(p_date1 != nil && p_date2 != nil)
    {
        NSCalendarUnit calendrier = NSWeekCalendarUnit | NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:calendrier fromDate:p_date1 toDate:p_date2 options:0];
        NSInteger v_week = [difference week];
        v_retour = [[NSNumber alloc] initWithInteger:v_week];
    }
    return v_retour;
    //NSLog(@"Différence entre les deux dates : %i mois et %i jours.", mois,jours);
}

+(int) GetNbJourEntreDeuxDatesWithDate1:(NSDate*) p_date1 AndDate2:(NSDate*) p_date2
{
    int v_retour = 0;
    if(p_date1 != nil && p_date2 != nil)
    {
        NSCalendarUnit calendrier = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:calendrier fromDate:p_date1 toDate:p_date2 options:0];
        NSInteger v_day = [difference day];
        v_retour = v_day;
    }
    return v_retour;
    //NSLog(@"Différence entre les deux dates : %i mois et %i jours.", mois,jours);
}

+(PEG_BeanPoint*) GetCoordActuel
{
    PEGAppDelegate* appDelegate = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    
    CLLocationManager* v_loc = appDelegate.principalLocationManager;
    //[v_loc startUpdatingLocation];
    
    NSDate* eventDate = v_loc.location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    PEG_BeanPoint* v_retour = nil;
    int v_Presicion = v_loc.location.horizontalAccuracy;
    // Precision < 50m et mesure il y a moins de 15s, on considère comme fiable
    if (v_Presicion < 50 && abs(howRecent) < 15.0
        && v_loc.location.coordinate.longitude != 0
        && v_loc.location.coordinate.latitude != 0) {
    v_retour = [[PEG_BeanPoint alloc] initWithLong:[[NSNumber alloc] initWithDouble:v_loc.location.coordinate.longitude ] AndLat:[[NSNumber alloc] initWithDouble:v_loc.location.coordinate.latitude] AndFiable:true];
    }
    else {
        v_retour = [[PEG_BeanPoint alloc] initWithLong:[[NSNumber alloc] initWithDouble:v_loc.location.coordinate.longitude ] AndLat:[[NSNumber alloc] initWithDouble:v_loc.location.coordinate.latitude] AndFiable:false];
    }
    return v_retour;
}

+ (NSString *)paddingLeftForValue:(int)value forDigits:(int)zeros {
    NSString *format = [NSString stringWithFormat:@"%%0%dd", zeros];
    return [NSString stringWithFormat:format,value];
}

+ (NSString *)genererGUID {
      
    //CFUUIDRef UUID = CFUUIDCreate(kCFAllocatorDefault);
    //CFStringRef UUIDString = CFUUIDCreateString(kCFAllocatorDefault,UUID);
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyMMddhhmmss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    NSString* v_Matricule = [[PEGSession sharedPEGSession] matResp]; 
    NSString *GUID = [NSString stringWithFormat:@"%@-6c96-40be-a7ca-%@",v_Matricule,stringFromDate];
    return GUID;
}

+(UITableViewCell*) getTableViewCellFromUI:(UITextField*)p_UITextField
{
    UITableViewCell* v_cell = nil;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // Load resources for iOS 6.1 or earlier
        v_cell = (UITableViewCell*) p_UITextField.superview.superview;
        
    } else {
        // Load resources for iOS 7 or later
        v_cell = (UITableViewCell*) p_UITextField.superview.superview.superview;
    }
    return v_cell;
}

+(void) traceErrorWithMessage:(NSString*)p_Message
{
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    BeanLogError* v_NewBean = [NSEntityDescription insertNewObjectForEntityForName:@"BeanLogError" inManagedObjectContext:app.managedObjectContext];
    [v_NewBean setDate:[NSDate date]];
    [v_NewBean setMessage:p_Message];
    [[PEG_FMobilitePegase CreateCoreData] Save];
    
    //[[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:p_Message andExparams:[NSString stringWithFormat:@""]];
}

+(void) traceErrorWithError:(NSError*)p_Error
{
    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
    BeanLogError* v_NewBean = [NSEntityDescription insertNewObjectForEntityForName:@"BeanLogError" inManagedObjectContext:app.managedObjectContext];
    [v_NewBean setDate:[NSDate date]];
    [v_NewBean setMessage:p_Error.description];
    [v_NewBean setCodeError:[[NSNumber alloc] initWithInt:p_Error.code]];
    [v_NewBean setDomainError:p_Error.domain];
    [[PEG_FMobilitePegase CreateCoreData] Save];
    
    //[[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:p_Error.description andExparams:[NSString stringWithFormat:@""]];
}
@end
