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
#import "HomeViewViewController.h"
#import "HLSettings.h"
//#import "EaseMob.h"
#import "AccountManager.h"
#import "HLUtilities.h"
#import "NotificationsViewController.h"
#import "Reachability.h"
@interface AppDelegate ()
@property (nonatomic, strong) NotificationsViewController *activityViewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [HLTheme customizeTheme];
    
    [Parse setApplicationId:@"nLiRBbe4xwev8pUXbvD3x8Q2eQAuSg8NRQWsoo9y" clientKey:@"WIJGRQoKLR1ascXnVZMyrFGX8y9F0tfBRDJr0YdX"];
    [PFFacebookUtils initializeFacebook];
    
    [[LocationManager sharedInstance]startLocationUpdate];
    
    // Register for Push Notitications
    application.applicationIconBadgeNumber = 0;
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    NSString *apnsCertName = @"PushTest";
//    [[EaseMob sharedInstance] registerSDKWithAppKey:@"catalina#hooli" apnsCertName:apnsCertName];
//    //    [[EaseMob sharedInstance] enableBackgroundReceiveMessage];
//    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    // PFUser *currentUser = [[HLSettings sharedInstance]getCurrentUser];
    
    if ( [PFUser currentUser]) {
        
        [[ChattingManager sharedInstance]loginChattingSDK:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
            
        }];
        
    }
    
    
    if(![HLUtilities getFirstLaunchStatus]){
        
        [HLUtilities saveFirstLaunchStatus:YES];
        UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
        UINavigationController *introNav = [mainSb instantiateViewControllerWithIdentifier:@"IntroNav"];
        introNav.navigationBar.hidden = YES;
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.window.rootViewController = introNav;
        [self.window makeKeyAndVisible];
    }
    else{
        
        UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *homeNav = [mainSb instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
        homeNav.navigationBar.hidden = YES;
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        self.window.rootViewController = homeNav;
        [self.window makeKeyAndVisible];
        
    }
    
    
    //    if ( [PFUser currentUser]) {
    //
    //        [[ChattingManager sharedInstance]loginChattingSDK:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
    //
    //        }];
    //
    //
    //        UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //        UINavigationController *homeNav = [mainSb instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    //        homeNav.navigationBar.hidden = YES;
    //        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    //        self.window.rootViewController = homeNav;
    //        [self.window makeKeyAndVisible];
    //
    //
    //
    //    }
    //    else{
    //
    //        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //        UINavigationController *loginNav = [loginSb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    //
    //        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    //
    //        self.window.rootViewController = loginNav;
    //        [self.window makeKeyAndVisible];
    //
    //    }
    //
    
    return YES;

}

- (BOOL)isParseReachable {
    return self.networkStatus != NotReachable;
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    
 //   [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
  //  [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
    
    [PFPush handlePush:userInfo];
    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
 //   [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
  //  [[EaseMob sharedInstance] applicationWillResignActive:application];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    
 //   [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
 //   [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
 //   [[EaseMob sharedInstance] applicationDidBecomeActive:application];
    
    [FBAppEvents activateApp];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
  //  [[EaseMob sharedInstance] applicationWillTerminate:application];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
