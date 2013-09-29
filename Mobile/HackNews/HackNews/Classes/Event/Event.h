//
//  Event.h
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for access the notification type.

#import <Foundation/Foundation.h>

@interface Event : NSObject

#pragma mark - GPS Location Updated Event Function
+ (NSString *) gpsLocationUpdatedNotification; // this function return GPS location updated notification name

@end
