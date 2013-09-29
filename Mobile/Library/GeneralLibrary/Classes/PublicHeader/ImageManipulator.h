//
//  ImageManipulator.h
//  GeneralLibrary
//
//  Created by Muhammad Furqan Kamani on 5/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageManipulator : NSObject {
}

+(UIImage *)makeRoundCornerImage:(UIImage*)img  width:(NSUInteger)cornerWidth height:(NSUInteger)cornerHeight;

@end
