//
//  CommunicationLibraryAppDelegate.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/12/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "CommunicationLibraryAppDelegate.h"

@implementation CommunicationLibraryAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch
	
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
