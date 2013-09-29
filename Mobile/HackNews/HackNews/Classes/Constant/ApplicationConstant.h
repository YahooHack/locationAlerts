//
//  ApplicationConstant.h
//  HackNews
//
//  Created by Furqan Kamani on 9/28/13.
//  Copyright (c) 2013 YahooHack. All rights reserved.
//
//  This class is used for access application constants.

#import <Foundation/Foundation.h>

@interface ApplicationConstant : NSObject

// server url string
#define strServerURL @"http://www.hackalerts.com"

// request uri
#define strLocationRequestURI @"sendLocation?latitude=%f&longitude=%f"

// global dictionary key string
#define strServerRequestTypeEnumValueKey @"SERVER_REQUEST_TYPE_ENUM_VALUE_KEY"
#define strServerErrorTypeEnumValueKey @"SERVER_ERROR_TYPE_ENUM_VALUE_KEY"
#define strServerHTTPErrorCodeValueKey @"SERVER_HTTP_ERROR_CODE_VALUE_KEY"

@end
