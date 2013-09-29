//
//  CommunicationEvent.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// This class is used for accessing the communication event

#import "CommunicationEvent.h"


@implementation CommunicationEvent


#pragma mark Communication Event Function
// this function return success notification name
+ (NSString *) responseReceivedNotification
{
	return @"RESPONSE_RECEIVED_NOTIFICATION";
}

// this function return http error notification name
+ (NSString *) httpErrorReceivedNotification
{
	return @"HTTP_ERROR_RECEIVED_NOTIFICATION";
}

// this function return failure notification name
+ (NSString *) failureOccuredNotification
{
	return @"FAILURE_OCCURED_NOTIFICATION";
}

#pragma mark Reachability Event Function
// this function return network connected notification name
+ (NSString *) networkConnectedNotification
{
    return @"NETWORK_CONNECTED_NOTIFICATION";    
}

// this function return network disconnected notification name
+ (NSString *) networkDisconnectedNotification
{
    return @"NETWORK_DISCONNECTED_NOTIFICATION";
}

@end
