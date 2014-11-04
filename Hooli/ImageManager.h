//
//  ImageManager.h
//  Hooli
//
//  Created by Er Li on 11/2/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageManager : NSObject
+(ImageManager *)sharedInstance;
- (UIImage *)loadImageWithName:(NSString *)imageName;
- (void)saveImage: (UIImage*)image WithName:(NSString *)imageName;
@end
