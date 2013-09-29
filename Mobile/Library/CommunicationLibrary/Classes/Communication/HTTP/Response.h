//
//  Response.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
	UnknownRequestCreationError = -1,
	HostNotFoundError = 0
} RequestCreationErrorTypeEnum;

@interface Response : NSObject {
	NSInteger statusCode; // this variable contain HTTP status code
	NSMutableDictionary* headersDictionary; // this variable contain request header dictionary
	NSMutableData *bodyData; // this variable contain response body data
	BOOL isBodyAvailable; // this variable contain bool, that is True if body is available otherwise False
	RequestCreationErrorTypeEnum requestCreationErrorTypeEnum;
}

@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, assign) BOOL isBodyAvailable;
@property (nonatomic, assign) RequestCreationErrorTypeEnum requestCreationErrorTypeEnum;

// this function clear response local data member 
- (void) clearResponse;

// these functions set response local data member
- (void) addAllHeaders:(NSDictionary*)allHeadersDict;
- (void) addBody:(NSData *)responseBodyData;

// these functions retrive response local data member
- (NSString*) getHeaderValueForKey:(NSString *)aHeaderKey;
- (NSMutableDictionary*) getAllHeaders;
- (NSMutableData *) getResponseBody;

@end
