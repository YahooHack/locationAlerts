//
//  SchedulerNotifier.h
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SchedulerNotifier : NSObject {
	NSTimer *notifierTimer;
	
	float timerInSec;
	BOOL isRepeatable;
	NSMutableDictionary *userInfoDict;
	NSMutableString *notificationNameString;
}

@property (nonatomic, assign) float timerInSec;
@property (nonatomic, assign) BOOL isRepeatable;
@property (nonatomic, retain) NSMutableDictionary *userInfoDict;
@property (nonatomic, retain) NSMutableString *notificationNameString;

#pragma mark Public Function
- (void) startNotifierTimer; // this function start notifier timer
- (void) stopNotifierTimer; // this function stop notifier timer
- (BOOL) isNotifierTimerRunning; // this function return true if timer is running

@end
