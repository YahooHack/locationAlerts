//
//  DateTimeUtility.m
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  This utility class is used for access datetime function

#import "DateTimeUtility.h"


@implementation DateTimeUtility

// this function return date in current time
+ (NSDate*) dateInCurrentTimeZone
{
    //[NSTimeZone resetSystemTimeZone];
    //[NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//[NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    
    NSDate* currentDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
                                      
    return currentDate;
}

// this function return device time string
+ (NSString*) getDeviceTimeString
{
	NSDate *date = [DateTimeUtility dateInCurrentTimeZone];
	
	return [date description];
}

// this function takes date object in parameter and return millisec string of this date
+ (NSString *) getMilliSecFromDate:(NSDate*)date
{
    NSTimeZone* currentTimeZone = [NSTimeZone localTimeZone]; // get current device timezone
	NSInteger currentGMTOffset = [currentTimeZone secondsFromGMT]; // get gmt offset	
	[date addTimeInterval:currentGMTOffset]; // add gmt offset in date object
    
	NSTimeInterval timeInterval = [date timeIntervalSince1970]; // get time interval from posted date
	
	long dateTimeSec = timeInterval;  // get date time sec from time interval
	
	long long dateTimeMilliSec = dateTimeSec; // get milli sec from date sec
	
	dateTimeMilliSec = dateTimeMilliSec * 1000;
	
	return [NSString stringWithFormat:@"%lld",dateTimeMilliSec];
}

// this function convert date string to date object
+ (NSDate *) getDateObjectFromString:(NSString*)dateString withFormat:(NSString*)formatString
{
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//[NSTimeZone systemTimeZone];

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease]; // create NSDate formatter object
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
	[dateFormatter setTimeZone:systemTimeZone];
    [dateFormatter setDateFormat:formatString];
    
	NSDate *dateObject = [dateFormatter dateFromString:dateString];
    
	return dateObject;
}

// this function convert date object to date string
+ (NSString *) getStringObjectFromDate:(NSDate*)dateObject withFormat:(NSString*)formatString
{
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; //[NSTimeZone systemTimeZone];
    
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease]; // create NSDate formatter object
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [dateFormatter setTimeZone:systemTimeZone];
    [dateFormatter setDateFormat:formatString];
	
	return [dateFormatter stringFromDate:dateObject];
}

// this function convert one string datetime into the specific one
+ (NSString *) getConvertedDateStringFromString:(NSString*)dateString withCurrentFormat:(NSString*)currentFormatString withNewFormat:(NSString*)newFormatString
{
    NSString *convertedDateString = @"";
    
    NSDate *convertedDateObject = [DateTimeUtility getDateObjectFromString:dateString withFormat:currentFormatString]; // get converted date object from date string
    if(convertedDateObject)
        convertedDateString = [DateTimeUtility getStringObjectFromDate:convertedDateObject withFormat:newFormatString]; // get converted date strign from converted date object
    
    return convertedDateString;
}

// this function convert one date object into the new format date object
+ (NSDate *) getConvertedDateObjectFromDate:(NSDate*)dateObject withNewFormat:(NSString*)newFormatString
{
    return [self getDateObjectFromString:[self getStringObjectFromDate:dateObject withFormat:newFormatString] withFormat:newFormatString];
}

// this function take time value in sec and return time in string format
+ (NSString*)getTimeStringFromInteger:(NSInteger)timeValueInSec withTimeFormat:(TIME_FORMAT_ENUM)timeFormatValue
{
	NSInteger iHour, iMin, iSec;
	
	if(timeValueInSec == 0) // this check execute if time is 0
	{
		iHour = 0;
		iMin = 0;
		iSec = 0;
	}
	else // this check execute if time is greater then zero
	{
		if(timeValueInSec < 60) // this check execute if time is less the 60, means total have only sec
		{
			iHour = 0;
			iMin = 0;
			iSec = timeValueInSec;
		}
		else 
		{
			iSec = timeValueInSec % 60; // get sec from time
			
			NSInteger div = timeValueInSec / 60; // get div of total time for finding min and hour
			
			if(div < 60) // this check execute if remaining time is less the 60, means div has only min
			{
				iHour = 0;
				iMin = div;
			}
			else 
			{
				iMin = div % 60; // get min from div time
				
				iHour = div / 60; // surely remaining div has hour
			}
		}
	}
	
	NSString *strHour = (iHour < 10) ? [NSString stringWithFormat:@"0%d",iHour] : [NSString stringWithFormat:@"%d",iHour];
	NSString *strMin = (iMin < 10) ? [NSString stringWithFormat:@"0%d",iMin] : [NSString stringWithFormat:@"%d",iMin];
	NSString *strSec = (iSec < 10) ? [NSString stringWithFormat:@"0%d",iSec] : [NSString stringWithFormat:@"%d",iSec];
	
    switch (timeFormatValue) 
    {
        case COMPLETE_TIME_FORMAT:
            return [NSString stringWithFormat:@"%@:%@:%@",strHour, strMin, strSec];
            break;
        
        case ONLY_HOUR_AND_MIN_FORMAT:
            return [NSString stringWithFormat:@"%@:%@",strHour, strMin];
            break;
            
        case ONLY_MIN_AND_SEC_FORMAT:
            return [NSString stringWithFormat:@"%@:%@",strMin, strSec];
            break;
        
        case ONLY_HOUR_FORMAT:
            return [NSString stringWithFormat:@"%@",strHour];
            break;
        
        case ONLY_MIN_FORMAT:
            return [NSString stringWithFormat:@"%@",strMin];
            break;
        
        case ONLY_SEC_FORMAT:
            return [NSString stringWithFormat:@"%@",strSec];
            break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@:%@:%@",strHour, strMin, strSec];
}

// this fucntion take time time valie in sec in parameter and return min
+ (float) getMinFromInteger:(NSInteger)timeValueInSec
{
    NSInteger hour, min, sec;
	
	if(timeValueInSec == 0) // this check execute if time is 0
	{
		hour = 0;
		min = 0;
		sec = 0;
	}
	else // this check execute if time is greater then zero
	{
		if(timeValueInSec < 60) // this check execute if time is less the 60, means total have only sec
		{
			hour = 0;
			min = 0;
			sec = timeValueInSec;
		}
		else 
		{
			sec = timeValueInSec % 60; // get sec from time
			
			NSInteger div = timeValueInSec / 60; // get div of total time for finding min and hour
			
			if(div < 60) // this check execute if remaining time is less the 60, means div has only min
			{
				hour = 0;
				min = div;
			}
			else 
			{
				min = div % 60; // get min from div time
				
				hour = div / 60; // surely remaining div has hour
			}
		}
	}
    
    float minValue = (float)sec/60 + min + hour*60;
    
    return minValue;
}

// this function take current date in parameter and return week start date
+ (NSDate*) getWeekBeginDate:(NSDate*)date
{
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    [gregorian setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[gregorian setTimeZone:systemTimeZone]; // add time zone in calendar
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    /*
     Create a date components to represent the number of days to subtract
     from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so
     subtract 1 from the number
     of days to subtract from the date in question.  (If today's Sunday,
     subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */
    if([weekdayComponents weekday] == 1) // this check execute if current date is sunday
    {
        [componentsToSubtract setDay:-6];
    }
    else
    {
        [componentsToSubtract setDay: - ([weekdayComponents weekday] - ([gregorian firstWeekday] + 1))];
    }
    
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the
     original date (today).
     To normalize to midnight, extract the year, month, and day components
     and create a new date from those components.
     */
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate: beginningOfWeek];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    beginningOfWeek = [gregorian dateFromComponents: components];
    
    return beginningOfWeek;
}

// this function take current date in parameter and return week end date
+ (NSDate*) getWeekEndDate:(NSDate*)date
{
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    [gregorian setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[gregorian setTimeZone:systemTimeZone]; // add time zone in calendar
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    
    if([weekdayComponents weekday] > 1) // this check execute if current date is greater then sunday
    {
        [componentsToAdd setDay:7 - ([weekdayComponents weekday] - 1)];
    }
    
    NSDate *endingOfWeek = [gregorian dateByAddingComponents:componentsToAdd toDate:date options:0];
    
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate: endingOfWeek];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    
    endingOfWeek = [gregorian dateFromComponents: components];
    
    return endingOfWeek;
}

// this function take date object in parameter and retun number of days in month
+ (NSInteger) getNumberOfDaysInMonth:(NSDate*)date
{
    NSInteger numberOfDays = 0;
    
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *gregorian = [NSCalendar currentCalendar]; // get calender object
    [gregorian setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[gregorian setTimeZone:systemTimeZone]; // add time zone in calendar
    
    NSRange range = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    if(range.length != NSNotFound)
    {
        numberOfDays = range.length;
    }
    
    return numberOfDays;
}

// this function take date object in parameter and return number of weeks in month
+ (NSInteger) getNumberOfWeeksInMonth:(NSDate*)date
{
    NSInteger numberOfWeeks = 0;
    
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *gregorian = [NSCalendar currentCalendar]; // get calender object
    [gregorian setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[gregorian setTimeZone:systemTimeZone]; // add time zone in calendar
    
    NSRange range = [gregorian rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    if(range.length != NSNotFound)
    {
        numberOfWeeks = range.length;
    }
    
    return numberOfWeeks;
}

// this function take date in parameter and return month number
+ (NSInteger) getMonthNumber:(NSDate*)date
{
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *gregorian = [NSCalendar currentCalendar]; // get calender object
    [gregorian setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[gregorian setTimeZone:systemTimeZone]; // add time zone in calendar
    
    NSDateComponents *dateComponent = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
 
    return [dateComponent month];
}

// this function take date in parameter and return year number
+ (NSInteger) getYearNumber:(NSDate*)date
{
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *gregorian = [NSCalendar currentCalendar]; // get calender object
    [gregorian setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[gregorian setTimeZone:systemTimeZone]; // add time zone in calendar
    
    NSDateComponents *dateComponent = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:date];
    
    return [dateComponent year];
}

// this function take from date in parameter and return date component
+ (NSDateComponents*) getDateComponentFromDate:(NSDate*)fromDate
{
    NSTimeZone* systemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *gregorian = [NSCalendar currentCalendar]; // get calender object
    [gregorian setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[gregorian setTimeZone:systemTimeZone]; // add time zone in calendar
    
    return [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:fromDate];
}

// this function take date component in parameter and return date object
+ (NSDate*) getDateFromComponent:(NSDateComponents*)dateComponent
{
    NSTimeZone *oSystemTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; // get universal system time zone
    
    NSCalendar *oCalendar = [NSCalendar currentCalendar]; // get calender object
    [oCalendar setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]]; // add locale in calendar
	[oCalendar setTimeZone:oSystemTimeZone]; // add time zone in calendar
    
    NSDate *oDate = [oCalendar dateFromComponents:dateComponent]; // get day end time from day component
    
    return oDate;
}

// this function return true if 24 hour time set inside setting screen
+ (BOOL) isTimeIn24HourFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = amRange.location == NSNotFound && pmRange.location == NSNotFound;
    [formatter release];
    return is24Hour;
}

@end
