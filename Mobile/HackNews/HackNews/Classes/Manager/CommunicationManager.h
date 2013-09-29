//
//  CommunicationManager.h
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for providing communication functions, which are useful for performing HTTP communication with server in this application.

#import <Foundation/Foundation.h>

@interface CommunicationManager : NSObject
{
    // Private Variable
    CommunicationEngine *_oCommunicationEngine; // this object is used for processing communication container object
    
    ResponseParserEngine *_oResponseParserEngine; // this object is used for parsing server response
    
    NSMutableArray *_arrCommunicationContainer; // this array is used for holding all communication container object
}

#pragma mark Initialization
+ (CommunicationManager *) sharedCommunicationManager;

#pragma mark Public Function
- (NSString*) sendLocationCoordinatesRequestToServer:(CGFloat)fLatitude withLongitude:(CGFloat)fLongitude; // this function takes latitude and longitude in parameters and send request to server

- (void) removeCommContainerObjectfromQueue:(NSString*)strUUID; // this function takes UUID string in parameter and remove communication container object from an array.

- (BOOL) isNetworkConnected; // this function return is network connected
@end
