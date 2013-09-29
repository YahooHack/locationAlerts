//
//  IdleTimerNotifier.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IdleTimerNotifier.h"


@implementation IdleTimerNotifier

@synthesize delegate;

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{
		
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	delegate = nil;
	[super dealloc];
}

#pragma mark Start Timer function
- (void) startNotificationTimer
{
	NSAutoreleasePool * pool =[[NSAutoreleasePool alloc] init];
	
	NSLog(@"initialize timer");
	
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	NSTimeInterval timeInterval = 1.0 * 60.0;
	[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(cycleCompletedFunction:) userInfo:nil repeats:YES];
	[runLoop run];
	
	[pool release];
}

- (void) cycleCompletedFunction:(NSTimer *)timer
{
	NSLog(@"time cycle completed");
	
	[self performSelectorOnMainThread:@selector(sendIdleTimeNotification) withObject:nil waitUntilDone:NO];
	
}

#pragma mark Selector Function
- (void) sendIdleTimeNotification
{
	[delegate idleTimeNotification];
}
@end
