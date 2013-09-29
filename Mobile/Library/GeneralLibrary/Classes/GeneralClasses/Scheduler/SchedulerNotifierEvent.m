//
//  SchedulerNotifierEvent.m
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SchedulerNotifierEvent.h"


@implementation SchedulerNotifierEvent

#pragma mark Scheduler Notifier Cycle Complete Event Function
+ (NSString *) schedulerNotifierCycleCompletedNotification
{
	return @"SCHEDULER_NOTIFIER_CYCLE_COMPLETED_NOTIFICATION";
}

@end
