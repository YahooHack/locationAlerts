//
//  Utility.m
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 7/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// this is used for access the general utility functions

#import "Utility.h"

#import <CommonCrypto/CommonDigest.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation Utility

#pragma mark Array Manipulation Function
// This function return sorted array
+ (NSArray*) sortArray:(NSArray*)unsortedArray withSortDescriptorArray:(NSArray*)sortDescriptorsArray
{
	return [unsortedArray sortedArrayUsingDescriptors:sortDescriptorsArray];
}

#pragma mark String Manipulation Function
// This function remove white space and extra charaters
+ (NSString *) removeWhitespaceAndExtraCharacters:(NSString*)sourceString
{
	NSMutableString* destString = [NSMutableString string];
	[destString setString:sourceString];
	[destString setString:[destString stringByReplacingOccurrencesOfString:@" " withString:@""]];
	[destString setString:[destString stringByReplacingOccurrencesOfString:@"<" withString:@""]];
	[destString setString:[destString stringByReplacingOccurrencesOfString:@">" withString:@""]];
	
	return destString;
}

// this function return url encoded string, (use this function for sending url to server in body or in xml or json). this function encode every special character in url
+ (NSString *) urlEncodedString:(NSString*)urlNotEncodedString
{
	CFStringRef urlEncodedString = CFURLCreateStringByAddingPercentEscapes(
																	NULL,
																	(CFStringRef)urlNotEncodedString,
																	NULL,
																	(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	kCFStringEncodingUTF8 );
    return [(NSString *)urlEncodedString autorelease];
}

// this function return url escape string, (use this function for removing white space in url)
+ (NSString *) urlEscapeString:(NSString*)urlNotEscapeString
{
	return [urlNotEscapeString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
}

#pragma mark Device Information Function
// This function return device UDID string  
+ (NSString *) getDeviceUDID 
{
	NSString *deviceUDIDString = [[UIDevice currentDevice] uniqueIdentifier];
	NSMutableString* destString = [NSMutableString string];
	[destString setString:deviceUDIDString];
	[destString setString:[destString stringByReplacingOccurrencesOfString:@" " withString:@""]];
	[destString setString:[destString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
	return destString;
}

// This function return device Name string 
+ (NSString *) getDeviceName
{
	NSString *deviceNameString = [[UIDevice currentDevice] name];
	return deviceNameString;
}

// This function check is multi tasking suppported in application, if yes then this function return "TRUE" otherwise "FALSE"
+ (BOOL) isMultitaskingSupported
{
	UIDevice* device = [UIDevice currentDevice];
	BOOL backgroundSupported = NO;
	if ([device respondsToSelector:@selector(isMultitaskingSupported)])
		backgroundSupported = device.multitaskingSupported;
	
	return backgroundSupported;
}

// this function check is os version at least to the parameter
+ (BOOL) osVersionIsAtLeast:(float)version
{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= [[NSNumber numberWithFloat:version] floatValue])
		return TRUE;
	return FALSE;
}

// this function return language code running in device
+ (NSString*) getCurrentLanguageCode
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

#pragma mark Create Guid Function
+ (NSString*) getGUIDString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

#pragma mark Create MD5 Function
+ (NSData*) getMD5:(NSString*)sourceString
{
	//const char* cStr = [sourceString cStringUsingEncoding:NSASCIIStringEncoding];
	const char* cStr = [sourceString cStringUsingEncoding:NSUTF8StringEncoding];
	if(cStr) // this check execute if char pointer is not null
	{
		unsigned char result[CC_MD5_DIGEST_LENGTH];
		CC_MD5( cStr, strlen(cStr), result);
		
		NSData* hashData = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
		return hashData;
	}
	
	return [NSData data];
}

#pragma mark Random Number Function
// this function take max number in parameter and generate random number which should be between 0 to maxNumber-1
+ (NSInteger) getRandomNumber:(NSInteger)maxNumber
{
    return arc4random() % maxNumber;
}


#pragma mark Sound Effect Function
// this function takes sound file path and vibration bool in parameter, this function search this file in NSBundle if found then play sound otherwise do nothing
+ (void) soundEffectWithContentsOfFile:(NSString *)soundWavPath withVibrate:(BOOL)isVibrate
{
	//Get the filename of the sound file:
	NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], soundWavPath];
	
	//declare a system sound id
	SystemSoundID soundID;
	
	//Get a URL for the sound file
	NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];

	//Use audio sevices to create the sound
	AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
	
	//Use audio services to play the sound
	AudioServicesPlaySystemSound(soundID);
	
	//Vibrate the phone.
	if (isVibrate) {
		AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
	}
}

@end
