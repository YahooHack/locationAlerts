//
//  Request.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	UnknownHTTPRequest = -1,
	GetRequest = 0,
	PostRequest = 1,
	PutRequest = 2,
	DeleteRequest = 3
} HTTPRequestMethodEnum;

@interface Request : NSObject {
	NSMutableString *hostName; // this variable contain host name
	NSMutableString *handlerName; // this variable contain request handler name
	NSMutableString *intermediateFolder; // this variable contain intermediate folder between host name and handler name
	NSMutableDictionary* headersDictionary; // this variable contain request header dictionary
	NSMutableArray *bodyDataArray; // this variable contain request body data array
	NSMutableURLRequest *mutableURLRequest; // this variable contain request in string, that application send for communication
	HTTPRequestMethodEnum httpRequestMethodEnumValue; // this enum contain HTTP request method type 
	
	NSMutableDictionary *customObjectDict; // this variable contain request specfic custom object dict
}

@property (nonatomic, retain) NSMutableURLRequest *mutableURLRequest;
@property (nonatomic, assign) HTTPRequestMethodEnum httpRequestMethodEnumValue;

// this function clear request local data member, 
- (void) clearRequest;

// these functions set request local data member
- (void) setHostName:(NSString *)hostNameString;
- (void) setHandlerName:(NSString *)handlerNameString;
- (void) setIntermediateFolder:(NSString *)intermediateFolderString;
- (void) addHeader:(NSString *)headerNameString withHeaderValue:(id)headerValueString;
- (BOOL) removeHeader:(NSString *)headerNameString;
- (void) addBody:(NSData *)bodyData;
- (void) addCustomObject:(NSString *)customObjectNameString withValue:(id)customObjectValueString; // this function add new custom object in dict
- (BOOL) removeCustomObject:(NSString *)customObjectNameString; // this function custom object from dict

// these functions retrive request local data member
- (NSString *) getHostName;
- (NSString *) getHandlerName;
- (NSString *) getIntermediateFolder;
- (NSMutableDictionary*) getAllHeaders;
- (NSData *) getBodyData:(NSUInteger)bodyIndex;
- (NSUInteger) getNumberOfBody;

- (NSMutableDictionary*) getCustomObject; // this method return custom object dictionary

@end

