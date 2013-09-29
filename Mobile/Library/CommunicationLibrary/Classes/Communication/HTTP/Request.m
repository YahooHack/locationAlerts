//
//  Request.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Request.h"

@implementation Request

@synthesize mutableURLRequest;
@synthesize httpRequestMethodEnumValue;

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{
		hostName = [[NSMutableString alloc] initWithCapacity:10];
		handlerName = [[NSMutableString alloc] initWithCapacity:10];
		intermediateFolder = [[NSMutableString alloc] initWithCapacity:10];
		headersDictionary = [ [NSMutableDictionary alloc] initWithCapacity:10];
		bodyDataArray = [[NSMutableArray alloc] initWithCapacity:10];
		mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:nil cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
		httpRequestMethodEnumValue = UnknownHTTPRequest;
		
		customObjectDict = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	[hostName release];
	[handlerName release];
	[intermediateFolder release];
	
	[headersDictionary removeAllObjects];
	[headersDictionary release];
	
	[bodyDataArray removeAllObjects];
	[bodyDataArray release];

	[mutableURLRequest release];
	
	[customObjectDict removeAllObjects];
	[customObjectDict release];

	[super dealloc];
}

#pragma mark Clear Data Function
// this function clear request local data member, 
- (void) clearRequest
{
	[hostName setString:@""];
	[handlerName setString:@""];
	[intermediateFolder setString:@""];
	
	[headersDictionary removeAllObjects];
	[bodyDataArray removeAllObjects];
	
	httpRequestMethodEnumValue = UnknownHTTPRequest;
}

#pragma mark Set Data Function
- (void) setHostName:(NSString *)hostNameString
{
	[hostName setString:hostNameString];
}

- (void) setHandlerName:(NSString *)handlerNameString
{
	[handlerName setString:handlerNameString];
}

- (void) setIntermediateFolder:(NSString *)intermediateFolderString
{
	[intermediateFolder setString:intermediateFolderString];
}

- (void) addHeader:(NSString *)headerNameString withHeaderValue:(id)headerValueString
{
	[headersDictionary setObject:headerValueString forKey:headerNameString];		
}

- (BOOL) removeHeader:(NSString *)headerNameString
{
	NSString* headerValue = [headersDictionary objectForKey:headerNameString];
	
	if (headerValue == nil)
		return FALSE;
	
	[headersDictionary removeObjectForKey:headerNameString];
	return TRUE;
}

- (void) addBody:(NSData *)bodyData
{
	[bodyDataArray addObject:bodyData];
}

// this function add new custom object in dict
- (void) addCustomObject:(NSString *)customObjectNameString withValue:(id)customObjectValueString 
{
	[customObjectDict setObject:customObjectValueString forKey:customObjectNameString];
}

// this function custom object from dict
- (BOOL) removeCustomObject:(NSString *)customObjectNameString 
{
	NSString* objectValue = [customObjectDict objectForKey:customObjectNameString];
	
	if (objectValue == nil)
		return FALSE;
	
	[customObjectDict removeObjectForKey:customObjectNameString];
	return TRUE;
}

#pragma mark Get Data Function
- (NSString *) getHostName
{
	return hostName;
}

- (NSString *) getHandlerName
{
	return handlerName;
}

- (NSString *) getIntermediateFolder
{
	return intermediateFolder;
}

- (NSMutableDictionary*) getAllHeaders
{
	return headersDictionary;
}

- (NSData *) getBodyData:(NSUInteger)bodyIndex
{
	return [bodyDataArray objectAtIndex:bodyIndex];
}

- (NSUInteger) getNumberOfBody
{
	return [bodyDataArray count];
}

// this method return custom object dictionary
- (NSMutableDictionary*) getCustomObject
{
	return customObjectDict;
}

@end

