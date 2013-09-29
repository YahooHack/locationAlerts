//
//  HttpCommunication.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HttpCommunication.h"

// Communication
#import "Request.h"
#import "Response.h"

// Container
#import "CommContainer.h"

@implementation HttpCommunication

@synthesize httpCommunicationStateEnum;
@synthesize containerObject;

@synthesize delegate;

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{
		httpCommunicationStateEnum = UnknownState;
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	[httpConnection cancel];
	[httpConnection release];
	httpConnection = nil;
	
	containerObject = nil;
	delegate = nil;
	
	[super dealloc];
}

#pragma mark Start Async Communication Function
- (void) startAsyncCommunication
{
	NSLog(@"Request URL = %@",[[containerObject.request.mutableURLRequest URL] absoluteString]);
	httpCommunicationStateEnum = CommunicatingState;
	
	// Start the status bar network activity indicator. We'll turn it off when the connection finishes or get an error.
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	httpConnection = [[NSURLConnection alloc] initWithRequest:containerObject.request.mutableURLRequest delegate:self];
}

#pragma mark Stop Async Communication Function
- (void) stopAsyncCommunication
{
	// Stop the status bar network activity indicator.
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if(httpConnection)
		[httpConnection cancel];
	httpCommunicationStateEnum = WaitingState;
}

#pragma mark NSURLConnection delegate functions
- (void) connection:(NSURLConnection *)aNSURLConnection didReceiveResponse:(NSHTTPURLResponse *)aNSURLResponse
{
	//NSLog(@"response received from server in HTTP Communication class");
	if(aNSURLResponse)
	{
		NSNumber* zHTTPStatusCode = [NSNumber numberWithInteger:[aNSURLResponse statusCode]];
		NSInteger httpStatusCode;
		httpStatusCode = [zHTTPStatusCode intValue];
		//NSLog(@"httpStatusCode = %d",httpStatusCode);
		if(httpStatusCode == 200)
		{
			// use for testing
			/*NSDictionary* iAllHeaders = [aNSURLResponse allHeaderFields];
			NSEnumerator* headersEnumeration = [iAllHeaders keyEnumerator];
			NSString *headerString;
			while (headerString = [headersEnumeration nextObject]) 
			{
				NSString *headerValueString = [iAllHeaders valueForKey:headerString];
				NSLog(@"header = %@, value = %@",headerString,headerValueString);
			}*/
			[containerObject.response addAllHeaders:[aNSURLResponse allHeaderFields]];
		}
		containerObject.response.statusCode = httpStatusCode;
	}
}
 
- (void) connection:(NSURLConnection *)aNSURLConnection didReceiveData:(NSData *)aNSData
{
	[containerObject.response addBody:aNSData];
}
 
- (void) connection:(NSURLConnection *)aNSURLConnection didFailWithError:(NSError *)aNSError
{
	NSLog(@"response failed with error from server in HTTP Communication class");
	NSLog(@"error domian = %@, error code = %d, user info = %@",[aNSError domain],[aNSError code],[aNSError userInfo]);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[delegate httpResponseReceived:NO];	
	httpCommunicationStateEnum = WaitingState;
}
 
- (void) connectionDidFinishLoading:(NSURLConnection *)aNSURLConnection
{
	//NSLog(@"connection did finished from server in HTTP Communication class");
	if( (aNSURLConnection == httpConnection) && (aNSURLConnection != nil) )
	{
		[httpConnection cancel];
		httpConnection = nil;
 
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[delegate httpResponseReceived:YES];
		httpCommunicationStateEnum = WaitingState;
	}
	//httpCommunicationStateEnum = WaitingState;
}

@end
