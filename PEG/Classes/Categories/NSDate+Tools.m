//
//  NSDate+Tools.m
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 16/07/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "NSDate+Tools.h"

@implementation NSDate (Tools)

+ (NSDate *)firstDayOfWeekForDay:(NSDate *)_day
{
	NSCalendar *gregorian = [NSCalendar currentCalendar];
	NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_day];
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: - ([weekdayComponents weekday] - [gregorian firstWeekday])];
	
	NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:_day options:0];
	NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: beginningOfWeek];
	beginningOfWeek = [gregorian dateFromComponents: components];
	
	return beginningOfWeek;
}

@end
