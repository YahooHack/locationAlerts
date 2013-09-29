//
//  IdleTimerNotifier.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IdleTimerNotifierDelegate

- (void) idleTimeNotification;

@end

@interface IdleTimerNotifier : NSObject {
	id<IdleTimerNotifierDelegate> delegate;
}

@property (nonatomic, assign) id<IdleTimerNotifierDelegate> delegate;

// Start Notification Timer
- (void) startNotificationTimer;

@end
