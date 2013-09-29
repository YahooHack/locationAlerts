//
//  Event.m
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for access the notification type.

#import "Event.h"

@implementation Event

#pragma mark - GPS Location Updated Event Function
// this function return GPS location updated notification name
+ (NSString *) gpsLocationUpdatedNotification
{
    return @"GPS_LOCATION_UPDATED_NOTIFICATION";
}

#pragma mark - New Fetch Event Function
// this function return news successfully fetch notification name
+ (NSString *) newsSuccessfullyFetchNotification
{
    return @"NEWS_SUCCESSFULLY_FETCH_NOTIFICATION";
}

@end
