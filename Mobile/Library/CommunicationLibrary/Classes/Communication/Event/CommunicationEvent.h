//
//  CommunicationEvent.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// This class is used for accessing the communication event

#import <Foundation/Foundation.h>


@interface CommunicationEvent : NSObject {

}

#pragma mark Communication Event Function
+ (NSString *) responseReceivedNotification; // this function return response notification name
+ (NSString *) httpErrorReceivedNotification; // this function return http error notification name
+ (NSString *) failureOccuredNotification; // this function return failure notification name

#pragma mark Reachability Event Function
+ (NSString *) networkConnectedNotification; // this function return network connected notification name
+ (NSString *) networkDisconnectedNotification; // this function return network disconnected notification name

@end
