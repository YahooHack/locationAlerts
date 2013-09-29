//
//  HttpCommunication.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forward Declaration
@class CommContainer;

typedef enum {
	UnknownState = -1,
	WaitingState = 0,
	CommunicatingState = 1 
} HttpCommunicationStateEnum;

@protocol HttpCommunicationDelegate

- (void) httpResponseReceived:(BOOL)successStatus;

@end


@interface HttpCommunication : NSObject {
	NSURLConnection* httpConnection;
	HttpCommunicationStateEnum httpCommunicationStateEnum;
	
	CommContainer *containerObject;
	
	id<HttpCommunicationDelegate> delegate;
}

@property (nonatomic, assign, readonly) HttpCommunicationStateEnum httpCommunicationStateEnum;
@property (nonatomic, assign) CommContainer *containerObject;

@property (nonatomic, assign) id<HttpCommunicationDelegate> delegate;

// Class Function
- (void) startAsyncCommunication;
- (void) stopAsyncCommunication;

@end
