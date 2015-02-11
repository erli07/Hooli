//
//  HLUtilities.h
//  Hooli
//
//  Created by Er Li on 11/13/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfferModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Parse/Parse.h>
@interface HLUtilities : NSObject


+ (NSData *)compressImage:(UIImage *)image WithCompression: (CGFloat) compressionQuality;

+ (void)playSound;
+ (void)playViberation;
+ (void)playSoundPlusViberation;

+ (void)saveFirstLaunchStatus:(BOOL)status;
+ (BOOL)getFirstLaunchStatus;

+ (BOOL)checkIfUserLogin;
@end
