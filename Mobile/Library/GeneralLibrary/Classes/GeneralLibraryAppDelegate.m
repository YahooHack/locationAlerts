//
//  GeneralLibraryAppDelegate.m
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 5/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "GeneralLibraryAppDelegate.h"

@implementation GeneralLibraryAppDelegate

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
