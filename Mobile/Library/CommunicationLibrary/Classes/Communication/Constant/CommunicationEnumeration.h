//
//  CommunicationEnumeration.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// This class is used for accessing the communition enumeration constant

typedef enum {
	UnknownPriorityContainer = -1,
	LowPriorityContainer = 0,
	MediumPriorityContainer = 1,
	HighPriorityContainer = 2 
} ContainerPriorityEnum;

// this is used for identifying network reachability status
typedef enum {
	UNKNOWN_REACHABILITY_STATUS = -1,
	NETWORK_REACHABLE = 0, 
    HARDWARE_NOT_REACHABLE = 1,
	CONNECTION_NOT_REACHABLE = 2
} NETWORK_REACHABILITY_ENUM;