//
//  HLUtilities.m
//  Hooli
//
//  Created by Er Li on 11/13/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLUtilities.h"
#import <Parse/Parse.h>
#import "HLConstant.h"
#import "HLCache.h"

#define systemSoundID    1104
@implementation HLUtilities


+ (NSData *)compressImage:(UIImage *)image WithCompression: (CGFloat) compressionQuality{
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [image drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(smallImage, compressionQuality);
        
    return imageData;
    
}
+ (void)playSound{
    
    AudioServicesPlaySystemSound(1003);
    
}
+ (void)playViberation{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}
+ (void)playSoundPlusViberation{
    
    AudioServicesPlaySystemSound(1012);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}




@end
