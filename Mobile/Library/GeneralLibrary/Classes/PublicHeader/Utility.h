//
//  Utility.h
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 7/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:1]
#define RGBCOLORWITHALPHA(r,g,b,a) [UIColor colorWithRed:r/256.0 green:g/256.0 blue:b/256.0 alpha:a]

@interface Utility : NSObject {

}

#pragma mark Array Manipulation Function
// This function return sorted array
+ (NSArray*) sortArray:(NSArray*)unsortedArray withSortDescriptorArray:(NSArray*)sortDescriptorsArray;

#pragma mark String Manipulation Function
// This function remove white space and extra charaters
+ (NSString *) removeWhitespaceAndExtraCharacters:(NSString*)sourceString;

// this function return url encoded string, (use this function for sending url to server in body or in xml or json). this function encode every special character in url
+ (NSString *) urlEncodedString:(NSString*)urlNotEncodedString;

// this function return url escape string, (use this function for removing white space in url)
+ (NSString *) urlEscapeString:(NSString*)urlNotEscapeString;

#pragma mark Device Information Function
// This function return device UDID string 
+ (NSString *) getDeviceUDID; 

// This function return device Name string 
+ (NSString *) getDeviceName;

// This function check is multi tasking suppported in application, if yes then this function return "TRUE" otherwise "FALSE"
+ (BOOL) isMultitaskingSupported;

// this function check is os version at least to the parameter
+ (BOOL) osVersionIsAtLeast:(float)version;

// this function return language code running in device
+ (NSString*) getCurrentLanguageCode;

#pragma mark Create Guid Function
// this function generate unique guid
+ (NSString*) getGUIDString;

#pragma mark Create MD5 Function
// This function generate MD5 hash from source string
+ (NSData*) getMD5:(NSString*)sourceString;

#pragma mark Random Number Function
+ (NSInteger) getRandomNumber:(NSInteger)maxNumber; // this function take max number in parameter and generate random number which should be between 0 to maxNumber-1

#pragma mark Sound Effect Function
// this function takes sound file path and vibration bool in parameter, this function search this file in bundle if found then play sound otherwise do nothing
+ (void) soundEffectWithContentsOfFile:(NSString *)soundWavPath withVibrate:(BOOL)isVibrate;

@end
