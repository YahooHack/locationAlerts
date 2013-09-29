//
//  CommunicationEngine.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// This class is used for accessing the singleton communication function

#import "UIKit/UIKit.h"

#import "CommunicationEngine.h"

// Open Framework (Reachability)
#import "Reachability.h"

// Communication
#import "Request.h"
#import "Response.h"

#import "CommContainer.h"

// Event
#import "CommunicationEvent.h"

@interface CommunicationEngine (priavte)

// Communication Function
- (void) initializeIdleTimer;
- (void) processASAPCommunication;
- (void) startCommunication:(CommContainer*)newCommunicationObject;
- (void) stopCommunication;

// Reachability Function 
- (BOOL) checkNetworkReachability; // this function return true if network is reachable otherwise false, means return true if wifi or gprs connected
- (BOOL) checkIsConnectionRequired; // this function return true if connection is required otherwise return false, means return true if wifi or gprs is connected but not working
- (void) handleNetworkChangesProcess:(BOOL)isNetworkReachable; // this function takes is network reachable bool in parameter and send notification based on value
@end

@implementation CommunicationEngine

@synthesize hostName;

static CommunicationEngine* sharedCommunicationEngineInstance = nil;

#pragma mark Singleton Start
+ (CommunicationEngine*) sharedCommunicationEngine
{
	@synchronized(self)
	{
		if (sharedCommunicationEngineInstance == nil) 
		{ 
			sharedCommunicationEngineInstance = [[super allocWithZone:NULL] init]; 
		}
	}
	return sharedCommunicationEngineInstance; 	
}

+ (id)allocWithZone:(NSZone *)zone 
{ 
    return [[self sharedCommunicationEngine] retain]; 
} 

- (id)copyWithZone:(NSZone *)zone 
{ 
    return self; 
} 

- (id)retain 
{ 
    return self; 
} 

- (NSUInteger)retainCount 
{ 
    return NSUIntegerMax;  //denotes an object that cannot be released 
} 

- (oneway void)release 
{ 
    //do nothing 
	[self dealloc];
	sharedCommunicationEngineInstance = nil;
} 

- (id)autorelease 
{ 
    return self; 
} 
#pragma mark Singleton Finish

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{
		requestCreation = [[RequestCreation alloc] init]; // create RequestCreation object
		requestCreation.delegate = self;
		httpCommunication = [[HttpCommunication alloc] init]; // create HttpCommunication object
		httpCommunication.delegate = self;
		idleTimerNotifier = [[IdleTimerNotifier alloc] init]; // create IdleTimerNotifier object
		idleTimerNotifier.delegate = self;
		priorityQueue = [[NSMutableArray alloc] initWithCapacity:10];
		hostName = [[NSString alloc] init];
		
		queueLock = [[NSLock alloc] init]; // create queue lock
		[queueLock setName:@"PriorityQueueLock"];
		
        reachability = [[Reachability reachabilityForInternetConnection] retain]; // create reachability object
        [reachability startNotifier]; // start reachability change notifier
        
        // add reachability change notification in notification observer
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChangedNotificationReceived:) name:kReachabilityChangedNotification object: nil];
        
		[self initializeIdleTimer]; // initailize idle notifier timer
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // remove all notification observer
    
	[requestCreation release];
	[httpCommunication release];
	[idleTimerNotifier release];
	
	[priorityQueue release];
	[hostName release];
	
	[queueLock release];
	
	[reachability stopNotifier]; // stop reachability change notifier
	[reachability release]; // release reachability object
    
	[super dealloc];
}

#pragma mark Public (Communication) Function
// this function add container object on priority queue
- (BOOL) startProcessObject:(id)containerObject 
{
	if([self getNetworkReachabilityStatus] == NETWORK_REACHABLE) // this check execute if network is reachable
	{
		CommContainer *commContainer = containerObject;
	
		// checking if the length of host name in requet object is 0, then assign "Comm Container Queue" host name
		if([[commContainer.request getHostName] length] == 0)
			[commContainer.request setHostName:hostName];
	
		// start Thread, this thread called "Send for Request Creation" function and passed "Communication Container" Object in "Request Creation" class
		[NSThread detachNewThreadSelector:@selector(sendForRequestCreation:) toTarget:requestCreation withObject:commContainer]; 
		
		return TRUE;
	}
	
	return FALSE;
}

// this function remove cntainer object from priority queue if exist
- (void) stopProcessObject:(NSString*)containerUUid 
{
	if((httpCommunication.httpCommunicationStateEnum == CommunicatingState) && ([containerUUid isEqualToString:[httpCommunication.containerObject UUidString]]))
	{
		[self stopCommunication];
	}
	
	NSPredicate *findCommContainerPredicate = [NSPredicate predicateWithFormat:@"UUidString == %@",containerUUid];
	
	NSMutableArray *deleteCommContainerObjectArray = [NSMutableArray arrayWithCapacity:10];
	[deleteCommContainerObjectArray setArray:[priorityQueue filteredArrayUsingPredicate:findCommContainerPredicate]];
	if([deleteCommContainerObjectArray count] > 0)
	{
		[priorityQueue removeObjectsInArray:deleteCommContainerObjectArray];
		[deleteCommContainerObjectArray removeAllObjects];
	}
	
	[self processASAPCommunication]; // check if any container object is in queue then start processing
}

#pragma mark Public (Reachability) Function 
// this function return network reachability enum
- (NETWORK_REACHABILITY_ENUM) getNetworkReachabilityStatus
{
    if(![self checkNetworkReachability]) // this function execute when hardware is not reachable
        return HARDWARE_NOT_REACHABLE;
    else if([self checkIsConnectionRequired]) // this function execute when connection is not reachable
        return CONNECTION_NOT_REACHABLE;
    return NETWORK_REACHABLE;
}

#pragma mark Private (Communication) Function
- (void) initializeIdleTimer
{
	// start Thread, this thread called "Start Notification Timer" function which is in "Idle Timer Notifier" class
	[NSThread detachNewThreadSelector:@selector(startNotificationTimer) toTarget:idleTimerNotifier withObject:nil]; 
}

- (void) processASAPCommunication
{
	NSLog(@"Communication Library: processASAPCommunication function start");
	@synchronized(queueLock) // make this synchronized
	{
		NSUInteger count = [priorityQueue count];
		NSLog(@"Communication Library: priority count = %d",count);
		if(count > 0)
		{
			CommContainer *topCommContainerObject = [priorityQueue objectAtIndex:0]; // get top queue object
			if(topCommContainerObject.isCommunicatingWithServer == FALSE) // this check execute if this comm container object not communicating with server
			{
				NSLog(@"Communication Library: top queue object is not communicating with server");
				if(topCommContainerObject.containerPriorityEnum == HighPriorityContainer) // this check execute if comm container object has high priority
				{
					NSLog(@"Communication Library: this is high priority object");
					if(httpCommunication.httpCommunicationStateEnum == CommunicatingState) // this check execute if http communication is in progress
					{
						[self stopCommunication]; // stop current object communication
					}
					[self startCommunication:topCommContainerObject]; // start current object communication
				}
				else if(topCommContainerObject.containerPriorityEnum == MediumPriorityContainer) // this check execute if comm container object has medium priority
				{
					NSLog(@"Communication Library: this is medium priority object");
					if(httpCommunication.httpCommunicationStateEnum == CommunicatingState) // this check execute if http communication is in progress
					{
						NSLog(@"Communication Library: http class is doing communication");
						CommContainer *inCommunicationContainerObject = httpCommunication.containerObject; // get commContainer object from http class
						if(inCommunicationContainerObject) // this check execute if comm container object is not null
						{
							NSLog(@"Communication Library: container object found");
							if(inCommunicationContainerObject.containerPriorityEnum == LowPriorityContainer) // this check execute if low priority object is running
							{
								NSLog(@"Communication Library: container object is low priority");
								[self stopCommunication]; // stop communication object
								[self startCommunication:topCommContainerObject]; //  start current object communication
							}
						}
					}
					else if(httpCommunication.httpCommunicationStateEnum == WaitingState)
					{
						NSLog(@"Communication Library: http class is in waiting state");
						
						CommContainer *inCommunicationContainerObject = httpCommunication.containerObject; // get commContainer object from http class
						if(!inCommunicationContainerObject) // this check execute if comm container object is not null
						{
							NSLog(@"container object not found in communication");
							[self startCommunication:topCommContainerObject]; // start current object communication
						}
					}
					else if(httpCommunication.httpCommunicationStateEnum == UnknownState)
					{
						NSLog(@"Communication Library: http class is in unknown state");
						[self startCommunication:topCommContainerObject]; // start current object communication
					}
				}
				else if(topCommContainerObject.containerPriorityEnum == LowPriorityContainer) // this check execute if comm container object has low priority
				{
					NSLog(@"Communication Library: this is low priority comm object");
					if((httpCommunication.httpCommunicationStateEnum == WaitingState) || (httpCommunication.httpCommunicationStateEnum == UnknownState)) // checking is "HTTP Communication" is in waiting state
					{
						NSLog(@"Communication Library: communication is in waiting state");
						[self startCommunication:topCommContainerObject]; // start current object communication
					}
					else {
						NSLog(@"Communication Library: communication is in another state");
					}

				}
			}
			else {
				NSLog(@"Communication Library: top queue object is communicating with server");
			}
			
		}
	}
}

- (void) startCommunication:(CommContainer*)newCommunicationObject
{
	if([self getNetworkReachabilityStatus] == NETWORK_REACHABLE) // this check execute if network is reachable
	{
		//CommContainer *containerObject = [priorityQueue objectAtIndex:0]; // assign container object in communication
		newCommunicationObject.isCommunicatingWithServer = TRUE; // set this object is communicating
		
		httpCommunication.containerObject = newCommunicationObject; // assign container object in http communication
		[httpCommunication startAsyncCommunication]; // start sending request to this communication object
	}
}

- (void) stopCommunication
{
	CommContainer *containerObject = httpCommunication.containerObject; // get commContainer object from http class
	containerObject.isCommunicatingWithServer = FALSE; // set this object is communicating with server stop
	
	[httpCommunication stopAsyncCommunication]; // start sending request to this communication object
}

#pragma mark Private (Reachability) Function
// this function return true if network is reachable otherwise false, means return true if wifi or gprs connected
- (BOOL) checkNetworkReachability
{
    if([reachability isReachable])
		return TRUE;
	return FALSE;
}

// this function return true if connection is required otherwise return false, means return true if wifi or gprs is connected but not working
- (BOOL) checkIsConnectionRequired
{
    if([reachability isConnectionRequired])
        return TRUE;
    return FALSE;
}

// this function takes is network reachable bool in parameter and send notification based on value
- (void) handleNetworkChangesProcess:(BOOL)isNetworkReachable
{
    NSNotification *notification = nil; // create nil notification object
    
    if(isNetworkReachable) // this check execute if network is reachable
    {
        notification = [NSNotification notificationWithName:[CommunicationEvent networkConnectedNotification]  object:nil userInfo:nil];
    }
    else
    {
        notification = [NSNotification notificationWithName:[CommunicationEvent networkDisconnectedNotification]  object:nil userInfo:nil];
    }
    
    if(notification) // this check execute if notification is not null
        [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostNow]; // add notification in NSNotificationQueue
}

#pragma mark Notification Function
-(void) reachabilityChangedNotificationReceived:(NSNotification *)notification
{
	Reachability *localReachability = [notification object]; // get reachability object from notification
	if((localReachability) && ([localReachability isKindOfClass:[Reachability class]]))
	{
		if(([localReachability isReachable]) && (![localReachability isConnectionRequired])) // this check execute if network become reachable
        {
            [self handleNetworkChangesProcess:TRUE]; // this function execute network connected process
        }
        else
        {
            [self handleNetworkChangesProcess:FALSE]; // this function execute network disconnected process
        }
	}
}

#pragma mark RequestCreationDelegate Function
// this function called, when request creation object successfully completed request creation. 
- (void) requestCreationCompleted:(id)containerObject
{
	CommContainer *commContainer = containerObject;
	
	@synchronized(queueLock) // make this synchronized
	{
		switch (commContainer.containerPriorityEnum) // checking container priority enum
		{
			case LowPriorityContainer: // "Low Priority Container"
			{
				[priorityQueue addObject:containerObject];
				break;
			}
			case MediumPriorityContainer: // "Medium Priority Container"
			{
				BOOL isObjectInsertInQueue = NO;
				NSUInteger count = [priorityQueue count];
				for(NSUInteger loop=0; loop<count; loop++)
				{
					CommContainer *containerLocalObject = [priorityQueue objectAtIndex:loop];
					if((containerLocalObject.containerPriorityEnum == HighPriorityContainer) || (containerLocalObject.containerPriorityEnum == MediumPriorityContainer))
						continue;
					else 
					{
						[priorityQueue insertObject:containerObject atIndex:loop];
						isObjectInsertInQueue = YES;
						break;
					}
				}
				if(count == 0)
				{
					[priorityQueue insertObject:containerObject atIndex:0];
					isObjectInsertInQueue = YES;
				}
				else if(isObjectInsertInQueue == NO)
				{
					[priorityQueue addObject:containerObject];
					isObjectInsertInQueue = YES;
				}
				break;
			}
			case HighPriorityContainer: // "High Priority Container"
			{
				[priorityQueue insertObject:containerObject atIndex:0];
				break;
			}
			default:
				break;
		}
	}
	[self processASAPCommunication];
}

// this function called, when request creation object failed during request creation.
- (void) requestCreationFailed:(id)containerObject
{
	UIAlertView *alert  = [[[UIAlertView alloc] initWithTitle:@"Request Creation Failed" message:@"Sorry it is my bad. i will check request creation code." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
	[alert show];
}

#pragma mark HttpCommunicationDelegate Function
- (void) httpResponseReceived:(BOOL)successStatus
{
	//if((priorityQueue) && ([priorityQueue count] > 0)) // this check execute if priorityQueue is not null and priorityQueue count is greater then zero
	//{
		//CommContainer *commContainerLocalObject = [priorityQueue objectAtIndex:0]; // get container object from "priority Queue" object
	@synchronized(queueLock) // make this synchronized
	{
		NSLog(@"Communication Library: HTTP Response received: start");
		
		CommContainer *commContainerLocalObject = httpCommunication.containerObject; // get commContainer object from http class
		commContainerLocalObject.isCommunicatingWithServer = FALSE; // set this object is communicating with server stop

		NSMutableDictionary *notificationObjectDict = [NSMutableDictionary dictionaryWithCapacity:2]; // create notification object dictionary
		
		[notificationObjectDict setObject:commContainerLocalObject forKey:strContainerObjectKey]; // add container object
		
		NSNotification *notification = nil; // this check execute if notification is null
		
		// check successStatus that is coming in parameter
		if(successStatus == YES) // response successfully received
		{
			if(commContainerLocalObject.response.statusCode == 200)
			{
				notification = [NSNotification notificationWithName:[CommunicationEvent responseReceivedNotification] object:notificationObjectDict userInfo:nil];
			}
			else {
				notification = [NSNotification notificationWithName:[CommunicationEvent httpErrorReceivedNotification] object:notificationObjectDict userInfo:nil];
			}
		}
		else if(successStatus == NO) // response received with error
		{			
			notification = [NSNotification notificationWithName:[CommunicationEvent failureOccuredNotification]  object:notificationObjectDict userInfo:nil];
		}
		
		if(notification) // this check execute if notification is not null
			[[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostNow]; // add notification in NSNotificationQueue
		
		NSInteger removeIndex = [priorityQueue indexOfObject:commContainerLocalObject]; // get index of object
		NSLog(@"Communication Library: HTTP Response received: removeIndex = %d",removeIndex);
		[priorityQueue removeObjectAtIndex:removeIndex];
		
		httpCommunication.containerObject = nil;
		httpCommunication.httpCommunicationStateEnum = WaitingState;
	}
	
	//[priorityQueue removeObjectAtIndex:0];
	[self processASAPCommunication];
}

#pragma mark IdleTimerNotifierDelegate Function
- (void) idleTimeNotification
{
	NSLog(@"Communication Library: idle timer notification received");
	
	[self processASAPCommunication];
	
	/*if(httpCommunication.httpCommunicationStateEnum == WaitingState) // checking is "HTTP Communication" is in waiting state
	{
		NSLog(@"Communication Library: communication is in waiting");
		NSUInteger count = [priorityQueue count]; // getting "Priority Queue" count
		NSLog(@"Communication Library: queue count = %d",count);
		if(count > 0) // if count greater then zero, then this means "Priority Queue" contain container object
		{
			[self processASAPCommunication];
			CommContainer *commContainerLocalObject = [priorityQueue objectAtIndex:0]; // getting container object at top index
			if(commContainerLocalObject.isCommunicatingWithServer == FALSE)
			{
				if(commContainerLocalObject.containerPriorityEnum == LowPriorityContainer) // checking container object priority, if it is "LowPriorityContainer" then check executes
				{
					[self startCommunication]; // start communicating low request
				}
			}
		}
	}*/
}
@end
