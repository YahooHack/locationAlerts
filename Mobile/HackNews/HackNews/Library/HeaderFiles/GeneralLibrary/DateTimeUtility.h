//
//  DateTimeUtility.h
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This utility class is used for access datetime function

#import <Foundation/Foundation.h>

// this enum is used for time format identification
typedef enum {
	UNKNOWN_TIME_FORMAT = -1,
	COMPLETE_TIME_FORMAT = 0,
    ONLY_HOUR_AND_MIN_FORMAT = 1,
	ONLY_MIN_AND_SEC_FORMAT = 2,
    ONLY_HOUR_FORMAT = 3,
    ONLY_MIN_FORMAT = 4,
    ONLY_SEC_FORMAT = 5
} TIME_FORMAT_ENUM;

@interface DateTimeUtility : NSObject {

}

+ (NSDate*) dateInCurrentTimeZone; // this function return date in current time

+ (NSString*) getDeviceTimeString; // this function return device time string

+ (NSString *) getMilliSecFromDate:(NSDate*)date; // this function takes date object in parameter and return millisec string of this date

+ (NSDate *) getDateObjectFromString:(NSString*)dateString withFormat:(NSString*)formatString; // this function convert date string to date object // yyyyMMddHHmmss
+ (NSString *) getStringObjectFromDate:(NSDate*)dateObject withFormat:(NSString*)formatString; // this function convert date object to date string
+ (NSString *) getConvertedDateStringFromString:(NSString*)dateString withCurrentFormat:(NSString*)currentFormatString withNewFormat:(NSString*)newFormatString; // this function convert one string datetime into the specific one
+ (NSDate *) getConvertedDateObjectFromDate:(NSDate*)dateObject withNewFormat:(NSString*)newFormatString; // this function convert one date object into the new format date object

+ (NSString*) getTimeStringFromInteger:(NSInteger)timeValueInSec withTimeFormat:(TIME_FORMAT_ENUM)timeFormatValue; // this function take time value in sec and return time in string format
+ (float) getMinFromInteger:(NSInteger)timeValueInSec; // this fucntion take time time valie in sec in parameter and return min

+ (NSDate*) getWeekBeginDate:(NSDate*)date; // this function take current date in parameter and return week start date
+ (NSDate*) getWeekEndDate:(NSDate*)date; // this function take current date in parameter and return week end date

+ (NSInteger) getNumberOfDaysInMonth:(NSDate*)date; // this function take date object in parameter and retun number of days in month
+ (NSInteger) getNumberOfWeeksInMonth:(NSDate*)date; // this function take date object in parameter and return number of weeks in month

+ (NSInteger) getMonthNumber:(NSDate*)date; // this function take date in parameter and return month number
+ (NSInteger) getYearNumber:(NSDate*)date; // this function take date in parameter and return year number

+ (NSDateComponents*) getDateComponentFromDate:(NSDate*)fromDate; // this function take from date in parameter and return date component
+ (NSDate*) getDateFromComponent:(NSDateComponents*)dateComponent; // this function take date component in parameter and return date object

+ (BOOL) isTimeIn24HourFormat; // this function return true if 24 hour time set inside setting screen

@end
