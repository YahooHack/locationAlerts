//
//  Response.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Response.h"


@implementation Response

@synthesize statusCode;
@synthesize isBodyAvailable;
@synthesize requestCreationErrorTypeEnum;

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{
		statusCode = -1;
		headersDictionary = [ [NSMutableDictionary alloc] initWithCapacity:10];
		bodyData = [[NSMutableData alloc] initWithLength:0];
		isBodyAvailable = FALSE;
		requestCreationErrorTypeEnum = UnknownRequestCreationError;
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	[headersDictionary removeAllObjects];
	[headersDictionary release];
	
	[bodyData release];
	requestCreationErrorTypeEnum = UnknownRequestCreationError;
	[super dealloc];
}

#pragma mark Clear Data Function
// this function clear response local data member 
- (void) clearResponse
{
	// set http status code to -1, means status code not received from server
	statusCode = -1;

	// remore all response headers
	[headersDictionary removeAllObjects];
	
	// set body available to false
	isBodyAvailable = FALSE;
	
	// create temp NSData, size of that data is zero
	NSData *tempData = [NSData data];
	
	// set tempdata in response body data 
	[bodyData setData:tempData];
	
	// set "UnknownRequestCreationError" state in "request Creation Error Type Enum" Variable
	requestCreationErrorTypeEnum = UnknownRequestCreationError;
}

#pragma mark Set Data Function
// these functions set response local data member

- (void) addAllHeaders:(NSDictionary*)allHeadersDict
{
	[headersDictionary setDictionary:allHeadersDict];
}

- (void) addBody:(NSData *)responseBodyData
{
	isBodyAvailable = TRUE;		
	[bodyData appendData:responseBodyData];
}

#pragma mark Get Data Function
// these functions retrive response local data member

- (NSString*) getHeaderValueForKey:(NSString *)aHeaderKey
{
	id headerValue = [headersDictionary valueForKey:aHeaderKey];
	if(headerValue != nil)
	{
		NSString *zHeaderValue = headerValue;
		return zHeaderValue;
	}
	return @"";
}

- (NSMutableDictionary*) getAllHeaders
{
	return headersDictionary;
}

- (NSMutableData *) getResponseBody
{
	return bodyData;
}
@end
