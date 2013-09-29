//
//  SchedulerNotifier.m
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SchedulerNotifier.h"

#import "SchedulerNotifierEvent.h"

@implementation SchedulerNotifier

@synthesize timerInSec, isRepeatable, userInfoDict, notificationNameString;

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{
		userInfoDict = [[NSMutableDictionary alloc] initWithCapacity:10];
		
		notificationNameString = [[NSMutableString alloc] initWithCapacity:10];
		[notificationNameString setString:[SchedulerNotifierEvent schedulerNotifierCycleCompletedNotification]];
		
		isRepeatable = YES;
		timerInSec = 60.0; // 1 min
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{	
	if([notifierTimer isValid]) // this check execute if notifier is valiid 
		[notifierTimer invalidate]; // invalidated notifier timer
	
	[notifierTimer release];
	[userInfoDict release];
	[notificationNameString release];
	[super dealloc];
}

#pragma mark Public Function
// this function start notifier timer
- (void) startNotifierTimer
{
	NSTimeInterval timeInterval = timerInSec;
	notifierTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval] interval:timeInterval target:self selector:@selector(cycleCompletedFunction:) userInfo:userInfoDict repeats:isRepeatable];
	[[NSRunLoop currentRunLoop] addTimer:notifierTimer forMode:NSDefaultRunLoopMode]; 
}

// this function stop notifier timer
- (void) stopNotifierTimer
{
	if([notifierTimer isValid]) // this check execute if notifier is valid 
		[notifierTimer invalidate]; // invalidated notifier timer
}

// this function return true if timer is running
- (BOOL) isNotifierTimerRunning
{
    if([notifierTimer isValid]) // this check execute if notifier is valid
        return TRUE;
    return FALSE;
}

#pragma mark Callback Function
- (void) cycleCompletedFunction:(NSTimer *)timer
{
	// send scheduler notifier cycle completed notification
	NSNotification *notification = [NSNotification notificationWithName:notificationNameString object:userInfoDict];
	
	// add notification in NSNotificationQueue
	[[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP]; 
}
 
@end
