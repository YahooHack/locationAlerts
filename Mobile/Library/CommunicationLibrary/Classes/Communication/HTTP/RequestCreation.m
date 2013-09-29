//
//  RequestCreation.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RequestCreation.h"

// Communication
#import "Request.h"
#import "Response.h"

// Container
#import "CommContainer.h"

@interface RequestCreation (priavte)

// this function attach user specfied custom header in http request
- (void) attachRequestSpecificHeader:(CommContainer*)containerObject;

@end

@implementation RequestCreation

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

#pragma mark Start Request Creation
- (void) sendForRequestCreation:(CommContainer*)containerObject
{
	NSAutoreleasePool * pool =[[NSAutoreleasePool alloc] init];

	// getting request host name
	NSString *requestHostName = [containerObject.request getHostName];
	
	if([requestHostName length] != 0)
	{
		switch (containerObject.request.httpRequestMethodEnumValue) 
		{
			case GetRequest:
				[containerObject.request.mutableURLRequest setHTTPMethod:@"GET"];
				break;
			case PostRequest:
				[containerObject.request.mutableURLRequest setHTTPMethod:@"POST"];
				break;
			case PutRequest:
				[containerObject.request.mutableURLRequest setHTTPMethod:@"PUT"];
				break;
			case DeleteRequest:
				[containerObject.request.mutableURLRequest setHTTPMethod:@"DELETE"];
				break;	
			default:
				break;
		}
		
		 
		// getting request handler name
		NSString *requestHandlerName = [NSString stringWithString:[containerObject.request getHandlerName]];
		
		// getting request intermediate folder
		NSString *requestIntermediateFolder = [NSString stringWithString:[containerObject.request getIntermediateFolder]];
		
		// creating request URL string
		NSString *requestURLString = [NSString stringWithFormat:@"%@%@%@",requestHostName,requestIntermediateFolder,requestHandlerName];
		[containerObject.request.mutableURLRequest setURL:[NSURL URLWithString:requestURLString]];
		
		// set request specfic header
		[self attachRequestSpecificHeader:containerObject];
		
		// get request body count
		NSUInteger bodyArrayCount = [containerObject.request getNumberOfBody];
		if(bodyArrayCount == 0)
		{
			
		}
		else if(bodyArrayCount == 1)
		{
			[containerObject.request.mutableURLRequest setHTTPBody:[containerObject.request getBodyData:0]];
		}
		else if(bodyArrayCount > 1)
		{
			/*NSString *boundaryString = @"multipart/form-data; boundary=---------------------------41184676334";
			
			[containerObject.request.mutableURLRequest addValue:@"Content-Type" forHTTPHeaderField:boundaryString];
			
			NSMutableData *multiPartBodyData = [NSMutableData dataWithCapacity:10];
			
			for(NSUInteger loop = 0; loop < [containerObject.request getNumberOfBody]; loop++)
			{
				[multiPartBodyData setData:[NSData dataWithBytes:[boundaryString cStringUsingEncoding:NSASCIIStringEncoding] length:[boundaryString lengthOfBytesUsingEncoding:NSASCIIStringEncoding]]];
				[multiPartBodyData setData:[containerObject.request getBodyData:loop]];
			}*/
		}
		
		// send container object to main thread
		[self performSelectorOnMainThread:@selector(requestCreationCompleted:) withObject:containerObject waitUntilDone:NO];
	}
	else 
	{
		// set "HostNotFoundError" state in "request Creation Error Type Enum" Variable
		containerObject.response.requestCreationErrorTypeEnum = HostNotFoundError;
		
		// send container object to main thread
		[self performSelectorOnMainThread:@selector(requestCreationFailed:) withObject:containerObject waitUntilDone:NO];
	}


	[pool release];
}

#pragma mark Private Function
// this function attach user specfied custom header in http request
- (void) attachRequestSpecificHeader:(CommContainer*)containerObject
{
	// getting request all headers
	NSDictionary *requestHeaderDictionary = [containerObject.request getAllHeaders];
	NSEnumerator *requestHeadersEnumeration = [requestHeaderDictionary keyEnumerator];
	NSString *headerKeyString;
	while (headerKeyString = [requestHeadersEnumeration nextObject]) 
	{
		NSString *headerValueString = [requestHeaderDictionary valueForKey:headerKeyString];
		[containerObject.request.mutableURLRequest addValue:headerValueString forHTTPHeaderField:headerKeyString];
	}
}

#pragma mark Selector Function
- (void) requestCreationCompleted:(id)containerObject
{
	[delegate requestCreationCompleted:containerObject];
}

- (void) requestCreationFailed:(id)containerObject
{
	[delegate requestCreationFailed:containerObject];
}

@end

