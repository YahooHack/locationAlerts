//
//  LoggingUtility.m
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoggingUtility.h"

#import "DataPersistence.h" // this is used for access file handling function
#import "DateTimeUtility.h" // this is used for getting date time function
#import "GeneralConstant.h" // this is used for getting log file name 

@implementation LoggingUtility

 // this function check log file existence, if not exist then create one
+ (BOOL) checkFileExistence
{
    NSString *strLogFileSize = [DataPersistence getFileSize:logFileName withDPFolderType:CACHES_DP_FOLDER_TYPE]; // get log file size
    
    if ((strLogFileSize) && ([strLogFileSize integerValue] > (1024 * 1024))) // if log file greater then 2kb then delete and create new one
    {
        [LoggingUtility deleteLogFile]; // delete log file
    }
    
	if(![DataPersistence checkFileExistance:logFileName withDPFolderType:CACHES_DP_FOLDER_TYPE])
	{
		if(![DataPersistence createFile:logFileName withDPFolderType:CACHES_DP_FOLDER_TYPE])
			return FALSE;
	}
	
	return TRUE;
}

// this function append log string in debug file
+ (void) logText:(NSString*)logString
{
    @try
    {
        if([LoggingUtility checkFileExistence]) // this check execute if file exe
        {
            NSString *completeFilePath = [DataPersistence getCompleteFilePath:logFileName withDPFolderType:CACHES_DP_FOLDER_TYPE]; // get complete cache file path
            if(completeFilePath) // this check execute if complete file path is not null
            {
                NSError *error = nil;
			
                NSMutableString *fileData = [[NSMutableString alloc] initWithCapacity:10];
	
                [fileData setString:[NSString stringWithContentsOfFile:completeFilePath encoding:NSASCIIStringEncoding error:NULL]];
	
                [fileData appendFormat:@"\r\n%@: %@",[DateTimeUtility getDeviceTimeString],logString];
	
                [fileData writeToFile:completeFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
			
                if (error) {
                    NSString *errorString = [NSString stringWithFormat:@"An error occured while saving : %@",[error description]];
                    [fileData appendFormat:@"\r\n%@: %@",[DateTimeUtility getDeviceTimeString],errorString];
                    [fileData writeToFile:completeFilePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
                }
			
                [fileData release];
			
                NSLog(@"%@",logString);
            }
            else
                NSLog(@"logging file path is null");
        }
        else 
            NSLog(@"logging file not exist");
    }
    @catch (NSException * e)
    {
        [LoggingUtility deleteLogFile]; // delete log file
    }
}

// this function log application start event
+ (void) applicationLaunch
{
	[LoggingUtility logText:@"------------------------------------------"];
	[LoggingUtility logText:@"<---------- Application Launch ---------->"];
	[LoggingUtility logText:@"------------------------------------------"];
}

// this function log application close event
+ (void) applicationTerminate
{
	[LoggingUtility logText:@"---------------------------------------------"];
	[LoggingUtility logText:@"<---------- Application Terminate ---------->"];
	[LoggingUtility logText:@"---------------------------------------------"];
}

// this function log application enter in BG Event
+ (void) applicationEnterInBG
{
	[LoggingUtility logText:@"-----------------------------------------------"];
	[LoggingUtility logText:@"<---------- Application Enter in BG ---------->"];
	[LoggingUtility logText:@"-----------------------------------------------"];
}

// this function log application enter in FG Event
+ (void) applicationEnterInFG
{
	[LoggingUtility logText:@"-----------------------------------------------"];
	[LoggingUtility logText:@"<---------- Application Enter in FG ---------->"];
	[LoggingUtility logText:@"-----------------------------------------------"];
}

// this function log application enter in Active Event
+ (void) applicationEnterInActive
{
    [LoggingUtility logText:@"-----------------------------------------------"];
	[LoggingUtility logText:@"<---------- Application Enter in Active ------->"];
	[LoggingUtility logText:@"-----------------------------------------------"];
}

// this function log application enter in unactive Event
+ (void) applicationEnterInUnactive
{
    [LoggingUtility logText:@"-----------------------------------------------"];
	[LoggingUtility logText:@"<---------- Application Enter in UnActive ---->"];
	[LoggingUtility logText:@"-----------------------------------------------"];
}

// this function delete log file
+ (void) deleteLogFile
{
    [DataPersistence removeFile:logFileName withDPFolderType:CACHES_DP_FOLDER_TYPE]; // delete log file
}

@end
