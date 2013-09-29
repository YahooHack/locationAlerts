//
//  CommunicationUtility.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommunicationUtility.h"


@implementation CommunicationUtility

#pragma mark Create Guid Function
+ (NSString*) getGUIDString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

@end
