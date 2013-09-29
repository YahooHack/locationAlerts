//
//  LocationManager.m
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for access the location function

#import "LocationManager.h"

@implementation LocationManager

#pragma mark Singleton Implementation
// start singleton implementation.
static LocationManager *sharedLocationManagerInstance = nil;

+ (LocationManager *)sharedLocationManager
{
	@synchronized (self)
	{
		if (sharedLocationManagerInstance == nil)
		{
			sharedLocationManagerInstance = [[self alloc] init];
		}
	}
	
	return sharedLocationManagerInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (sharedLocationManagerInstance == nil) {
			sharedLocationManagerInstance = [super allocWithZone:zone];
			return sharedLocationManagerInstance;	//assigment and return on first allocation.
		}
	}
	return nil;		// on subsquent allocation attempts return nil.
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (unsigned)retainCount
{
	return UINT_MAX;	//denotes an object that cannot be released.
}

- (void) release
{
	//do nothing.
	[sharedLocationManagerInstance dealloc];
	sharedLocationManagerInstance = nil;
}

- (id)autorelease
{
	return self;
}
// end singleton implementation.

#pragma mark Initialization
- (id) init
{
    self = [super init];
	if(self)
	{
		_locationManager = [[CLLocationManager alloc] init]; // create location manager object
		_locationManager.delegate = self;
        _locationManager.distanceFilter = 10.0f;//kCLDistanceFilterNone; //3.0f;
		_locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;//kCLLocationAccuracyBestForNavigation;
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	[_locationManager release];
    
	[_location release];
    [_previousLocation release];
    
	[super dealloc];
}

#pragma mark public function
// this function return TRUE if location service is enabled otherwise return false
- (BOOL) isLocationServiceEnabled
{
    BOOL isLocationServiceEnabled = NO;
    
    if ([Utility osVersionIsAtLeast:4.0]) // this check execute if OS version is less then 4.0
    {
        isLocationServiceEnabled = [CLLocationManager locationServicesEnabled];	// OS4 and above.
        
        if(isLocationServiceEnabled)
        {
            if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined))
                isLocationServiceEnabled = YES;
            else
                isLocationServiceEnabled = NO;
        }
    }
    else
    {
        isLocationServiceEnabled = [_locationManager locationServicesEnabled];	// below OS4
    }
    
    return isLocationServiceEnabled;
}

// this function return location latitude
- (NSNumber*) getLatitude
{
    if(_location) // this check execute if location object is not null
    {
        NSNumber *latitude = [NSNumber numberWithDouble:_location.coordinate.latitude];
        
        return latitude;
    }
    
    return nil;
}

// this function return location longitude
- (NSNumber*) getLongitude
{
    if(_location) // this check execute if location object is not null
    {
        NSNumber *longitude = [NSNumber numberWithDouble:_location.coordinate.longitude];
        
        return longitude;
    }
    
    return nil;
}

// this function return location accuracy
- (NSNumber*) getAccuracy
{
    if(_location) // this check execute if location object is not null
    {
        return [NSNumber numberWithDouble:_location.horizontalAccuracy];
    }
    return nil;
}

// this function start updating location
- (void) startUpdatingLocation
{
    [_locationManager startUpdatingLocation];
}

// this function stop updating location
- (void) stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

// this function start updating location in background
- (void) startMonitoringSignificantLocationChanges
{
    [_locationManager startMonitoringSignificantLocationChanges];
}

// this function stop updating location in background
- (void) stopMonitoringSignificantLocationChanges
{
    [_locationManager stopMonitoringSignificantLocationChanges];
}

// this function return TRUE if region monitor is allowed by the user otherwise return false
- (BOOL) isRegionMonitorAllowedByTheUser
{
    BOOL isRegionMonitoringServiceEnabled = NO;
    
    if([CLLocationManager regionMonitoringAvailable]) // this check execute if region monitoring is available in device
    {
        if([CLLocationManager regionMonitoringEnabled]) // this check execute if region monitoring is enabled for this application in device setting
            isRegionMonitoringServiceEnabled = YES;
    }
    
    return isRegionMonitoringServiceEnabled;
}

// this function start region monitoring
- (void) startRegionMonitoring:(CLRegion *)region
{
    [_locationManager startMonitoringForRegion:region];
}

// this function start region monitoring with accuracy
- (void) startRegionMonitoring:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy
{
    [_locationManager startMonitoringForRegion:region desiredAccuracy:accuracy];
}

// this function stop region monitoring
- (void) stopRegionMonitoring:(CLRegion *)region
{
    [_locationManager stopMonitoringForRegion:region];
}

// this function return set of all monitored regions
- (NSSet*) getTotalMonitoredRegions
{
    return _locationManager.monitoredRegions;
}

// this function return maximum region monitoring distance
- (CLLocationDistance) getMaximumRegionMonitoringDistance
{
    return _locationManager.maximumRegionMonitoringDistance;
}

#pragma mark CLLocationManagerDelegate Functions
// this function tell when getting location successfully detected in device
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0)
        return;
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0)
        return;
    
    if(_location) // this check execute if _location object is not null
    {
        [_location release]; // release location object
    }
    
    //NSLog(@"Speed = %f",_location.speed);
    
    _location = [newLocation retain]; // save updated location in location object
    
    NSNotification *notificationObject  = [NSNotification notificationWithName:[Event gpsLocationUpdatedNotification] object:_location userInfo:nil]; // create GPS location updated notification
    if(notificationObject) // this check execute if notification object is not null
        [[NSNotificationQueue defaultQueue] enqueueNotification:notificationObject postingStyle:NSPostNow]; // add notification in NSNotificationQueue
}

// this function tell when getting location failed in device
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate (Responding to Authorization Changes) Functions
// this function tell when user change location status in device
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
}

#pragma mark CLLocationManagerDelegate (Responding to Region Events) Functions
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"Did Start monitoring for region");
}

@end