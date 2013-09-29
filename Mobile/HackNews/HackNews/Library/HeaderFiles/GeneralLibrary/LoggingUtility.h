//
//  LoggingUtility.h
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoggingUtility : NSObject {

}

+ (BOOL) checkFileExistence; // this function check log file existence, if not exist then create one
+ (void) logText:(NSString*)logString; // this function append log string in debug file

+ (void) applicationLaunch; // this function log application start event
+ (void) applicationTerminate; // this function log application close event

+ (void) applicationEnterInBG; // this function log application enter in BG Event
+ (void) applicationEnterInFG; // this function log application enter in FG Event

+ (void) applicationEnterInActive; // this function log application enter in Active Event
+ (void) applicationEnterInUnactive; // this function log application enter in unactive Event

+ (void) deleteLogFile; // this function delete log file

@end
