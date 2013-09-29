//
//  LocationManager.h
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for access the location function

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    // Private Variable
    CLLocationManager *_locationManager; // this is used for storing location manager object
	CLLocation *_location; // this is used for storing current location object
    CLLocation *_previousLocation; // this is used for storing previous location object
}

#pragma mark Initialization
+ (LocationManager *) sharedLocationManager;

#pragma mark public function
- (BOOL) isLocationServiceEnabled; // this function return TRUE if location service is enabled otherwise return false

- (NSNumber*) getLatitude; // this function return location latitude
- (NSNumber*) getLongitude; // this function return location longitude
- (NSNumber*) getAccuracy; // this function return location accuracy

- (void) startUpdatingLocation; // this function start updating location
- (void) stopUpdatingLocation; // this function stop updating location

- (void) startMonitoringSignificantLocationChanges; // this function start updating location in background
- (void) stopMonitoringSignificantLocationChanges; // this function stop updating location in background

- (BOOL) isRegionMonitorAllowedByTheUser; // this function return TRUE if region monitor is allowed by the user otherwise return false

- (void) startRegionMonitoring:(CLRegion *)region; // this function start region monitoring
- (void) startRegionMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy; // this function start region monitoring with accuracy
- (void) stopRegionMonitoring:(CLRegion *)region; // this function stop region monitoring
- (NSSet*) getTotalMonitoredRegions; // this function return set of all monitored regions
- (CLLocationDistance) getMaximumRegionMonitoringDistance; // this function return maximum region monitoring distance

@end
