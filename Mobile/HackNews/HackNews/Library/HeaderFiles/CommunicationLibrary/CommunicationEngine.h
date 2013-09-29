//
//  CommunicationEngine.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 1/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constant
#import "CommunicationConstant.h"
#import "CommunicationEnumeration.h"

// Communication
#import "HttpCommunication.h"
#import "RequestCreation.h"
#import "IdleTimerNotifier.h"

// Forward Declaration
@class CommDataContainer;
@class CommImageContainer;
@class Reachability;

@interface CommunicationEngine : NSObject <HttpCommunicationDelegate, RequestCreationDelegate, IdleTimerNotifierDelegate> 
{
	RequestCreation *requestCreation; // this variable is used for creating request
	HttpCommunication *httpCommunication; // this variable is used for sending and receiving http request and response
	
	NSMutableArray *priorityQueue; // this variable is used for maintaining request queue
	NSString *hostName; // this variable contain host name, that is used for all request, if it is empty in request
	
	IdleTimerNotifier *idleTimerNotifier; // this is used for schedule queue request
	
	NSLock *queueLock; // this is used for handling queue lock
    
    Reachability *reachability; // this is used for storing reachability object
}

@property (nonatomic, assign) NSString *hostName;

// Singleton Function
+ (CommunicationEngine*) sharedCommunicationEngine;

#pragma mark Public (Communication) Function 
- (BOOL) startProcessObject:(id)containerObject; // this function add container object on priority queue
- (void) stopProcessObject:(NSString*)containerUUid; // this function remove cntainer object from priority queue if exist

#pragma mark Public (Reachability) Function 
- (NETWORK_REACHABILITY_ENUM) getNetworkReachabilityStatus; // this function return network reachability enum

@end
