//
//  CommunicationEvent.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommunicationEvent : NSObject {

}

#pragma mark Communication Event Function
+ (NSString *) responseReceivedNotification; // this function return response notification name
+ (NSString *) httpErrorReceivedNotification; // this function return http error notification name
+ (NSString *) failureOccuredNotification; // this function return failure notification name

@end
