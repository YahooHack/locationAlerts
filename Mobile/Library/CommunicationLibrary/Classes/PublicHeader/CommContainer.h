//
//  CommContainer.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 1/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommunicationEnumeration.h"

// Forward Declaration
@class Request;
@class Response;

@interface CommContainer : NSObject {
	Request *request; // this variable contain user request content, that need to be send to any server
	
	ContainerPriorityEnum containerPriorityEnum; // this variable contain priority of container object
	
	Response *response; // this variable contain response that is coming from server
	NSString *UUidString; // this variable contain distinct id of container object
	
	BOOL isCommunicatingWithServer; // this variable contain is this object communicating with server, if not then communicaton engine process comm object, otherwise wait
}

@property (nonatomic, retain) Request *request;

@property (nonatomic,assign) ContainerPriorityEnum containerPriorityEnum;

@property (nonatomic, retain) Response *response;
@property (nonatomic, readonly) NSString *UUidString;

@property (nonatomic, assign) BOOL isCommunicatingWithServer;

@end
