//
//  RequestCreation.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Forward Declaration
@class CommContainer;

@protocol RequestCreationDelegate

- (void) requestCreationCompleted:(id)containerObject;
- (void) requestCreationFailed:(id)containerObject;

@end

@interface RequestCreation : NSObject {
	id<RequestCreationDelegate> delegate;
}

@property (nonatomic, assign) id<RequestCreationDelegate> delegate;

// Start Creation
- (void) sendForRequestCreation:(id)containerObject;

@end
