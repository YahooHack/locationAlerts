//
//  CommContainer.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 1/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommContainer.h"

// Communication
#import "Request.h"
#import "Response.h"

// Utility
#import "CommunicationUtility.h"

@implementation CommContainer

@synthesize request;

@synthesize containerPriorityEnum;

@synthesize response;
@synthesize UUidString;

@synthesize isCommunicatingWithServer;

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{
		request = [[Request alloc] init];	
		
		containerPriorityEnum = UnknownPriorityContainer;
		
		response = [[Response alloc] init];
		UUidString = [[NSString alloc] initWithString:[CommunicationUtility getGUIDString]];
		
		isCommunicatingWithServer = FALSE; // by default set false value
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	[request release];
	
	[UUidString release];
	
	[response release];
	
	[super dealloc];
}

@end
