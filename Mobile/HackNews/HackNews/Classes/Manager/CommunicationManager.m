//
//  CommunicationManager.m
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for providing communication functions, which are useful for performing HTTP communication with server in this application.

#import "CommunicationManager.h"

@interface CommunicationManager (Private)

// this function remove comm container object from local array
- (void) removeCommContainerObjectFromArray:(CommContainer*)commContainer;

@end

@implementation CommunicationManager

#pragma mark Singleton Implementation

// start singleton implementation.
static CommunicationManager *oSharedCommunicationManager = nil;

+ (CommunicationManager *)sharedCommunicationManager
{
	@synchronized (self)
	{
		if (oSharedCommunicationManager == nil)
		{
			oSharedCommunicationManager = [[self alloc] init];
		}
	}
	
	return oSharedCommunicationManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (oSharedCommunicationManager == nil) {
			oSharedCommunicationManager = [super allocWithZone:zone];
			return oSharedCommunicationManager;	//assigment and return on first allocation.
		}
	}
	return nil;		// on subsquent allocation attempts return nil.
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (unsigned)retainCount
{
	return UINT_MAX;	//denotes an object that cannot be released.
}

- (void) release
{
	//do nothing.
	[oSharedCommunicationManager dealloc];
	oSharedCommunicationManager = nil;
}

- (id)autorelease
{
	return self;
}
// end singleton implementation.

#pragma mark Initialization
- (id) init
{
    self = [super init];
	if(self)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseReceivedNotification:) name:[CommunicationEvent responseReceivedNotification] object:nil]; // add response received notification observer
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(httpErrorReceivedNotification:) name:[CommunicationEvent httpErrorReceivedNotification] object:nil]; // add http error received notification observer
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failureOccuredReceivedNotification:) name:[CommunicationEvent failureOccuredNotification] object:nil]; // add failure occured notification observer
        
		_oCommunicationEngine = [CommunicationEngine sharedCommunicationEngine]; // create communication engine object
		_oCommunicationEngine.hostName = strServerURL; // assign server url in host name
		
		_oResponseParserEngine = [[ResponseParserEngine alloc] init]; // create response parsing engine object
		
		_arrCommunicationContainer = [[NSMutableArray alloc] initWithCapacity:10]; // create array for holding communication contianer object
	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self]; // remove notification observer
	
	[_oCommunicationEngine release];
	
	[_oResponseParserEngine release];
	
	[_arrCommunicationContainer release];
    
	[super dealloc];
}

#pragma mark Private Function
// this function remove comm container object from local array
- (void) removeCommContainerObjectFromArray:(CommContainer*)oCommunicationContainer
{
	if(oCommunicationContainer) // this check execute if comm container object is not null
	{
		NSPredicate *oPredicate = [NSPredicate predicateWithFormat:@"UUidString == %@",oCommunicationContainer.UUidString];
        
        // remove communication object from comm container array
		NSMutableArray *arrFindCommunicationContainer = [NSMutableArray arrayWithCapacity:10];
        [arrFindCommunicationContainer setArray:[_arrCommunicationContainer filteredArrayUsingPredicate:oPredicate]];
        
		if ((arrFindCommunicationContainer) && ([arrFindCommunicationContainer count] > 0)) // this check execute if communication container object found based on UUID
        {
            [_arrCommunicationContainer removeObjectsInArray:arrFindCommunicationContainer]; // remove find communication continer objects from local array
            
            [arrFindCommunicationContainer removeAllObjects]; // delete find communication continer objects
        }
	}
}

#pragma mark Public Function
// this function takes latitude and longitude in parameters and send request to server
- (NSString*) sendLocationCoordinatesRequestToServer:(CGFloat)fLatitude withLongitude:(CGFloat)fLongitude
{
    BOOL bIsRequestSuccessfullySend = FALSE; // create boolean for storing is request successfully send.
    @try
    {
        CommDataContainer *oCommunicationDataContainer = [[[CommDataContainer alloc] init] autorelease]; // create comm data container object
		if (oCommunicationDataContainer) // this check execute if communication data container is not null
        {
            [oCommunicationDataContainer.request clearRequest];
            
            [oCommunicationDataContainer.request addCustomObject:strServerRequestTypeEnumValueKey withValue:[NSNumber numberWithInteger:LOCATION_REQUEST]]; // send location request type enum value in custom object
            
            oCommunicationDataContainer.containerPriorityEnum = MediumPriorityContainer;
            
            oCommunicationDataContainer.request.httpRequestMethodEnumValue = GetRequest;
            
            [oCommunicationDataContainer.request setHandlerName:strLocationRequestURI];
            
            [oCommunicationDataContainer.request addHeader:@"Content-Type" withHeaderValue:@"application/x-www-form-urlencoded"];
            
            if([_oCommunicationEngine startProcessObject:oCommunicationDataContainer]) // this function return true if connection is reachable and add communication data container object in communication engine for processing
            {
                [_arrCommunicationContainer addObject:oCommunicationDataContainer]; // add commDataContainer object in local array
                
                bIsRequestSuccessfullySend = true;
                
                return oCommunicationDataContainer.UUidString;
            }
        }
    }
    @catch (NSException * e)
    {
        UIAlertView *oAlertView = [[[UIAlertView alloc] initWithTitle:[e name] message:[e reason] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease];
		[oAlertView show];
    }
    @finally
    {
        if (!bIsRequestSuccessfullySend) {
			return nil;
		}
    }
    
    return nil;
}

// this function takes UUID string in parameter and remove communication container object from an array.
- (void) removeCommContainerObjectfromQueue:(NSString*)strUUID
{
	[_oCommunicationEngine stopProcessObject:strUUID]; // stop object communication in library
	
	NSPredicate *oPredicate = [NSPredicate predicateWithFormat:@"UUidString == %@",strUUID];
	
    // remove communication object from comm container array
	NSMutableArray *arrFindCommunicationContainer = [NSMutableArray arrayWithCapacity:10];
	[arrFindCommunicationContainer setArray:[_arrCommunicationContainer filteredArrayUsingPredicate:oPredicate]];
    
    if ((arrFindCommunicationContainer) && ([arrFindCommunicationContainer count] > 0)) // this check execute if communication container object found based on UUID
    {
        [_arrCommunicationContainer removeObjectsInArray:arrFindCommunicationContainer]; // remove find communication continer objects from local array
        
        [arrFindCommunicationContainer removeAllObjects]; // delete find communication continer objects
    }
}

// this function return is network connected
- (BOOL) isNetworkConnected
{
    if([_oCommunicationEngine getNetworkReachabilityStatus] == NETWORK_REACHABLE)
        return TRUE;
    return FALSE;
}

#pragma mark Notification Function
// add response received notification observer
- (void) responseReceivedNotification:(NSNotification*)notification
{
	//NSLog(@"response received");
	
	NSDictionary *dictNotification = [notification object]; // get notification dict object
	
	if(dictNotification) // this check execute if notification object dict is not null
	{
		CommContainer *oCommContainer = [dictNotification objectForKey:strContainerObjectKey];
		
		if(oCommContainer) // this check execute if comm container object is not null
		{
			if([oCommContainer isKindOfClass:[CommDataContainer class]])
			{
                [_oResponseParserEngine processDataResponse:oCommContainer]; // send process data response
			}
			else if([oCommContainer isKindOfClass:[CommImageContainer class]])
			{
                if(oCommContainer.response.isBodyAvailable) // this check execute if response body available
                {
                    [_oResponseParserEngine processImageResponse:oCommContainer]; // process download image response
                }
			}
		}
		
		[self removeCommContainerObjectFromArray:oCommContainer]; // remove container object from array
	}
}

// add http error received notification observer
- (void) httpErrorReceivedNotification:(NSNotification*)notification
{
	//NSLog(@"http error received");
	
	NSDictionary *dictNotification = [notification object]; // get notification dict object
	
	if(dictNotification) // this check execute if notification object dict is not null
	{
		CommContainer *oCommContainer = [dictNotification objectForKey:strContainerObjectKey];
		
		if(oCommContainer) // this check execute if comm container object is not null
		{
            [_oResponseParserEngine processHttpError:oCommContainer]; // process http error
		}
		
		[self removeCommContainerObjectFromArray:oCommContainer]; // remove container object from array
	}
}

// add failure occured notification observer
- (void) failureOccuredReceivedNotification:(NSNotification*)notification
{
    //NSLog(@"failure received");
    
	NSDictionary *dictNotification = [notification object]; // get notification dict object
	
	if(dictNotification) // this check execute if notification object dict is not null
	{
		CommContainer *oCommContainer = [dictNotification objectForKey:strContainerObjectKey];
		
		if(oCommContainer) // this check execute if comm container object is not null
		{
            [_oResponseParserEngine processFailureOccured:oCommContainer]; // process failure occured
		}
		
		[self removeCommContainerObjectFromArray:oCommContainer]; // remove container object from array
	}
}

@end
