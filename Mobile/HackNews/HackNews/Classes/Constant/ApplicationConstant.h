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
#define strServerURL @"http://projects.redirectme.net:8081/labexpdev/service.svc/"

// request uri
#define strLocationRequestURI @"CheckLoginCredentials?username=fkamani&password=fkamani"

// global dictionary key string
#define strServerRequestTypeEnumValueKey @"SERVER_REQUEST_TYPE_ENUM_VALUE_KEY"
#define strServerErrorTypeEnumValueKey @"SERVER_ERROR_TYPE_ENUM_VALUE_KEY"
#define strServerHTTPErrorCodeValueKey @"SERVER_HTTP_ERROR_CODE_VALUE_KEY"

@end
