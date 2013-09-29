//
//  AppDelegate.m
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used as a starting point of application.

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // add GPS location updated notification observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsLocationUpdatedNotification:) name:[Event gpsLocationUpdatedNotification] object:nil];
    
    _oLocationManager = [LocationManager sharedLocationManager]; // get location manager object
    
    id aLocationValue = [launchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]; // getting app launch reason is location
	if (aLocationValue)
	{
        //[_oLocationManager startUpdatingLocation]; // start location update
        
        [_oLocationManager startMonitoringSignificantLocationChanges]; // start monitoring significant location changes
	}
    else
    {
        [_oLocationManager startUpdatingLocation]; // start location updating
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RegisterViewController *oRegisterViewController = [[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil] autorelease];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:oRegisterViewController];
    [self.navController setNavigationBarHidden:TRUE];
    
    [_window setRootViewController:self.navController];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //[_oLocationManager stopUpdatingLocation]; // stop location updating
    
    [_oLocationManager startMonitoringSignificantLocationChanges]; // start monitoring significant location changes
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [_oLocationManager stopMonitoringSignificantLocationChanges]; // stop location updating
    
    [_oLocationManager startUpdatingLocation]; // start location updating
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark Memory Management
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; // remove all notification observer
    
    [_oLocationManager release];
    [_oCommunicationManager release];
    
    [_window release];
    [_navController release];
    [_managedObjectContext release];
    [_managedObjectModel release];
    [_persistentStoreCoordinator release];
    
    [super dealloc];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HackNews" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HackNews.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// this function execute when GPS location updated notification received
-(void) gpsLocationUpdatedNotification:(NSNotification *)notification
{
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState; // get application state object
    
    CLLocation *locationObject = [notification object]; // get object from notification
    
    if(locationObject) // this check execute if location object is not null
    {
        if((applicationState == UIApplicationStateBackground) || (applicationState == UIApplicationStateInactive)) // this check execute if application is background or inactive state
        {
            UIBackgroundTaskIdentifier bgTask = [[UIApplication sharedApplication]
                                                 beginBackgroundTaskWithExpirationHandler:
                                                 ^{
                                                     [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                                                 }];
            
            NSLog(@"location update in background");
            
            _oCommunicationManager = [CommunicationManager sharedCommunicationManager]; // create communication manager instance
            [_oCommunicationManager sendLocationCoordinatesRequestToServer:2.2f withLongitude:2.3f];

            if (bgTask != UIBackgroundTaskInvalid)
            {
                [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
            
        }
        else // this check execute if application is foreground or active state
        {
            NSLog(@"location update in forground");
            _oCommunicationManager = [CommunicationManager sharedCommunicationManager]; // create communication manager instance
            [_oCommunicationManager sendLocationCoordinatesRequestToServer:2.2f withLongitude:2.3f];
        }
    }
}

#pragma mark - Push Notification Delegate
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *strDeviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    strDeviceToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
	NSLog(@"strDeviceToken is: %@", strDeviceToken);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState; // get application state object
    
    if(applicationState == UIApplicationStateActive) // this check execute if application is active state
    {
        NSDictionary *dictApsInfo = [userInfo objectForKey:@"aps"];
        
        if( [dictApsInfo objectForKey:@"alert"] != NULL)
        {
            NSString *strAlertMsg = [dictApsInfo objectForKey:@"alert"];
            
            UIAlertView *oAlertView = [[[UIAlertView alloc] initWithTitle:@"Alert" message:strAlertMsg delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
            [oAlertView show];
        }
    }
}

@end
