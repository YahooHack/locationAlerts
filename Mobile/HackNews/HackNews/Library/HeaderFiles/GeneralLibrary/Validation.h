//
//  Validation.h
//  GeneralLibrary
//
//  Created by Furqan Kamani on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Validation : NSObject {

}

+ (BOOL) emailAddressValidation:(NSString*)emailString; // this function take email string in parameter and validate email address according to regular expression

@end
