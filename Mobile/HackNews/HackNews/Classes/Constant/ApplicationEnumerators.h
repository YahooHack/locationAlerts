//
//  ApplicationEnumerators.h
//  HackNews
//
//  Created by Furqan Kamani on 9/29/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for access application enumerations.

#import <Foundation/Foundation.h>

// this is used for identify communication error type
typedef enum {
	UNKNOWN_COMM_ERROR_TYPE = -1,
	SERVER_ERROR_TYPE = 0,
	RESPONSE_PARSING_ERROR_TYPE = 1,
	HTTP_ERROR_TYPE = 2,
	FAILURE_ERROR_TYPE = 3
} SERVER_ERROR_TYPE_ENUM;

// this is used for identify server request type
typedef enum {
	UNKNOWN_SERVER_REQUEST = -1,
	LOCATION_REQUEST = 0
} SERVER_REQUEST_TYPE_ENUM;