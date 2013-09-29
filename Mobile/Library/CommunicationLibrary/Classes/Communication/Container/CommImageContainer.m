//
//  CommImageContainer.m
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommImageContainer.h"

@implementation CommImageContainer

@synthesize imageView1 = _imageView1;

#pragma mark Initialization
- (id) init
{
	if(self = [super init])
	{

	}
	return self;
}

#pragma mark Memory Management
- (void) dealloc
{	
    [_imageView1 release];
    
	[super dealloc];
}

@end
