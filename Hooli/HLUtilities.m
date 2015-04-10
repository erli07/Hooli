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
#import "LoginWelcomeViewController.h"

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

+ (void)saveFirstLaunchStatus:(BOOL)status{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:status forKey:FIRST_LAUNCH_KEY];
    [ud synchronize];
    
}

+ (BOOL)getFirstLaunchStatus{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:FIRST_LAUNCH_KEY];
    
}


+ (void)saveAddressToLocal:(NSMutableDictionary *)dictionary{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:dictionary forKey:@"MY_ADDRESS"];
    [ud synchronize];
    
}

+ (NSDictionary *)getAddressBook{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"MY_ADDRESS"];
    
}


+ (BOOL)checkIfUserLoginWithCurrentVC:(UIViewController *)vc{
    
    if(![PFUser currentUser]){
        
        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginWelcomeViewController *loginVC = [loginSb instantiateViewControllerWithIdentifier:@"LoginWelcomeViewController"];        
        [vc.navigationController pushViewController:loginVC animated:NO];
        
        return NO;
        
    }
    
    return YES;
    
}



@end
