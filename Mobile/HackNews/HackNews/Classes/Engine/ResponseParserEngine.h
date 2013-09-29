//
//  ResponseParserEngine.h
//  HackNews
//
//  Created by Furqan Kamani on 9/29/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for providing response parsing functions, which are useful for parsing server response related to this application.

#import <Foundation/Foundation.h>

@interface ResponseParserEngine : NSObject {
    
}

#pragma mark Public Function
- (void) processDataResponse:(CommContainer*)oCommunicationContainer; // this function takes communication container object in parameter and process server data response
- (void) processImageResponse:(CommContainer*)oCommunicationContainer; // this function takes communication container object in parameter and process server image data response

- (void) processHttpError:(CommContainer*)oCommunicationContainer; // this function takes communication container object in parameter and process HTTP error received from server

- (void) processFailureOccured:(CommContainer*)oCommunicationContainer; // this function takes communication container object in parameter and process failure occured during server communication

@end
