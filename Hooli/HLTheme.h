//
//  HLTheme.h
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HLTheme : NSObject

+ (NSString*)boldFont;
+ (NSString*)mainFont;
+ (UIColor*)mainColor;
+ (UIColor *)secondColor;
+ (UIColor*)foregroundColor;
+ (UIColor*)viewBackgroundColor;

+ (UIImage *)progressTrackImage;
+ (UIImage *)progressProgressImage;
+ (UIImage *)progressPercentTrackImage;
+ (UIImage *)progressPercentProgressImage;
+ (UIImage *)progressPercentProgressValueImage;

+(void)customizeTheme;
+(void)customizeTabBar:(UITabBar*)tabBar;

@end
