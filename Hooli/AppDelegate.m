//
//  AppDelegate.m
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "AppDelegate.h"
#import "HLTheme.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "LocationManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [HLTheme customizeTheme];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
//                                                         bundle: nil];
//    UITabBarController *tabController = [storyboard instantiateViewControllerWithIdentifier:@"HomeTabBar"];
//    [HLTheme customizeTabBar:tabController.tabBar];
    [Parse setApplicationId:@"y2TZrSLwWAnuGkMxW8uie1rbFw4X5rHtE39WJrrU" clientKey:@"bn35QolQBYVdLiNRHGUfm79lBzA2MukoBnN1I16k"];
    [PFFacebookUtils initializeFacebook];
    
    [[LocationManager sharedInstance]startLocationUpdate];
    
    
//    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
//        [HLTheme customizeTabBar:tabController.tabBar];
//   }

//    UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
//    [HLTheme customizeTabBar:tabController.tabBar];
//    self.window.rootViewController = [[LoginViewController alloc]init];


    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
