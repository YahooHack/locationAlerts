//
//  Validation.m
//  GeneralLibrary
//
//  Created by Furqan Kamani on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Validation.h"


@implementation Validation

// this function take email string in parameter and validate email address according to regular expression
+ (BOOL) emailAddressValidation:(NSString*)emailString
{
	BOOL stricterFilter = YES; 
	NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:emailString];
}

@end
