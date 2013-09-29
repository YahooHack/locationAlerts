//
//  CommImageContainer.h
//  CommunicationLibrary
//
//  Created by Muhammad Furqan Kamani on 1/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CommContainer.h"

@interface CommImageContainer : CommContainer {
    UIImageView *_imageView1; // this is used for showing image data when downloaded
}

@property (nonatomic, retain) UIImageView *imageView1;

@end
