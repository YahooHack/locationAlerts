//
//  ResponseParserEngine.m
//  HackNews
//
//  Created by Furqan Kamani on 9/29/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for providing response parsing functions, which are useful for parsing server response related to this application.

#import "ResponseParserEngine.h"

@interface ResponseParserEngine (Private)

// Response Parsing Function
- (void) processLocationResponse:(Request*)oRequest withResponseBody:(NSData*)oResponseBodyData; // this function process location server response

@end

@implementation ResponseParserEngine

#pragma mark Initialization Function
- (id) init
{
    self = [super init];
	if(self)
	{
		
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	[super dealloc];
}

#pragma mark Private (Response Parsing) Function
// this function process login driver server response
- (void) processLocationResponse:(Request*)oRequest withResponseBody:(NSData*)oResponseBodyData
{
    NSString *strResponseBody = [[[NSString alloc] initWithData:oResponseBodyData encoding:NSASCIIStringEncoding] autorelease];
    NSLog(@"Location response body string = %@",strResponseBody);
    
    NSNotification *oNotification = nil; // create notification object
    
    if ((strResponseBody) && ([strResponseBody length] > 0))
    {
        
    }
    
    if(oNotification) // this check execute if notification object is not null
        [[NSNotificationQueue defaultQueue] enqueueNotification:oNotification postingStyle:NSPostNow]; // add notification in NSNotificationQueue
}

#pragma mark Public Function
// this function takes communication container object in parameter and process server data response
- (void) processDataResponse:(CommContainer*)oCommunicationContainer
{
    NSDictionary *dictCustomObject = [oCommunicationContainer.request getCustomObject]; // get dict custom object
    if(dictCustomObject) // this check execute if is not null
    {
        if(oCommunicationContainer.response.isBodyAvailable) // this check execute if response body available
        {
            NSLog(@"file path = %@",[DataPersistence getCompleteFilePath:@"LastResponseFile.txt" withDPFolderType:CACHES_DP_FOLDER_TYPE]);
            
            [[oCommunicationContainer.response getResponseBody] writeToFile:[DataPersistence getCompleteFilePath:@"LastResponseFile.txt" withDPFolderType:CACHES_DP_FOLDER_TYPE] atomically:YES];
        }
        
        NSNumber *oRequestTypeNumber = [dictCustomObject objectForKey:strServerRequestTypeEnumValueKey]; // get server request type enum value number from custom object dict
        if(oRequestTypeNumber) // this check execute if request type number is not null
        {
            SERVER_REQUEST_TYPE_ENUM iServerRequestTypeEnumValue = [oRequestTypeNumber integerValue]; // get server request type enum value.
            
            switch (iServerRequestTypeEnumValue)
            {
                case LOCATION_REQUEST:
                {
                    [self processLocationResponse:oCommunicationContainer.request withResponseBody:[oCommunicationContainer.response getResponseBody]]; // process location server response
                    break;
                }
                default:
                    break;
            }
        }
    }
}

// this function takes communication container object in parameter and process server image data response
- (void) processImageResponse:(CommContainer*)oCommunicationContainer
{
    NSDictionary *dictCustomObject = [oCommunicationContainer.request getCustomObject]; // get dict custom object from communication container
    if(dictCustomObject) // this check execute if is not null
    {
        NSNumber *oRequestTypeNumber = [dictCustomObject objectForKey:strServerRequestTypeEnumValueKey]; // get server request type enum value number from custom object dict
        if(oRequestTypeNumber) // this check execute if request type number is not null
        {
            SERVER_REQUEST_TYPE_ENUM iServerRequestTypeEnumValue = [oRequestTypeNumber integerValue]; // get server request type enum value.
            
            switch (iServerRequestTypeEnumValue)
            {
                default:
                    break;
            }
        }
    }
}

// this function takes communication container object in parameter and process HTTP error received from server
- (void) processHttpError:(CommContainer*)oCommunicationContainer
{
    NSDictionary *dictCustomObject = [oCommunicationContainer.request getCustomObject]; // get dict custom object from communication container
    if(dictCustomObject) // this check execute if is not null
    {
        NSMutableDictionary *dictError = [NSMutableDictionary dictionaryWithCapacity:4];
        [dictError setObject:[NSNumber numberWithInteger:HTTP_ERROR_TYPE] forKey:strServerErrorTypeEnumValueKey]; // create failure error type dict
        [dictError setObject:[NSNumber numberWithInteger:oCommunicationContainer.response.statusCode] forKey:strServerHTTPErrorCodeValueKey]; // add http error code in dict error
        
        NSNumber *oRequestTypeNumber = [dictCustomObject objectForKey:strServerRequestTypeEnumValueKey]; // get server request type enum value number from custom object dict
        if(oRequestTypeNumber) // this check execute if request type number is not null
        {
            NSNotification *oNotification = nil;
            
            SERVER_REQUEST_TYPE_ENUM iServerRequestTypeEnumValue = [oRequestTypeNumber integerValue]; // get server request type enum value.
            
            switch (iServerRequestTypeEnumValue)
            {
                case LOCATION_REQUEST:
                {
                    break;
                }
                default:
                    break;
            }
            
            if(oNotification) // this check execute if notification object is not null
                [[NSNotificationQueue defaultQueue] enqueueNotification:oNotification postingStyle:NSPostNow]; // add notification in NSNotificationQueue
        }
    }
}

// this function takes communication container object in parameter and process failure occured during server communication
- (void) processFailureOccured:(CommContainer*)oCommunicationContainer
{
    NSDictionary *dictCustomObject = [oCommunicationContainer.request getCustomObject]; // get dict custom object from communication container
    if(dictCustomObject) // this check execute if is not null
    {
        NSMutableDictionary *dictError = [NSMutableDictionary dictionaryWithCapacity:4]; // create dict error object
        [dictError setObject:[NSNumber numberWithInteger:FAILURE_ERROR_TYPE] forKey:strServerErrorTypeEnumValueKey]; // create failure error type dict
        NSNumber *oRequestTypeNumber = [dictCustomObject objectForKey:strServerRequestTypeEnumValueKey]; // get server request type enum value number from custom object dict
        if(oRequestTypeNumber) // this check execute if request type number is not null
        {
            NSNotification *oNotification = nil;
            
            SERVER_REQUEST_TYPE_ENUM iServerRequestTypeEnumValue = [oRequestTypeNumber integerValue]; // get server request type enum value.
            
            switch (iServerRequestTypeEnumValue)
            {
                case LOCATION_REQUEST:
                {
                    break;
                }
                default:
                    break;
            }
            
            if(oNotification) // this check execute if notification object is not null
                [[NSNotificationQueue defaultQueue] enqueueNotification:oNotification postingStyle:NSPostNow]; // add notification in NSNotificationQueue
        }
    }
}

@end
