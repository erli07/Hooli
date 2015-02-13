//
//  HomeTabBarController.m
//  Hooli
//
//  Created by Er Li on 12/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//
#import "NeedTableViewController.h"
#import "HomeTabBarController.h"
#import "HLConstant.h"
#import "CameraOverlayViewController.h"
#import "HomeViewViewController.h"
#import "MyCameraViewController.h"
#import "MessagesView.h"
#import "NotificationFeedViewController.h"
#import <AudioToolbox/AudioToolbox.h>
@interface HomeTabBarController ()

@end

@implementation HomeTabBarController
@synthesize needViewController,needNavigationController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveRemoteNotification:) name:kHLAppDelegateApplicationDidReceiveRemoteNotification object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item  {
    
    
    if(item.tag == TAB_BAR_INDEX_NOTIFICATION){
        
        UITabBarItem *tabBarItem = [[self.viewControllers objectAtIndex:TAB_BAR_INDEX_NOTIFICATION] tabBarItem];
        tabBarItem.badgeValue = 0;
        
        // [self.needNavigationController pushViewController:self.needViewController animated:YES];
        
    }
    else if(item.tag == TAB_BAR_INDEX_MESSAGES){
        
        UITabBarItem *tabBarItem = [[self.viewControllers objectAtIndex:TAB_BAR_INDEX_MESSAGES] tabBarItem];
        tabBarItem.badgeValue = 0;
    }
    

    
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
//    NSLog(@"selected %d",tabBarController.selectedIndex);
//    
//    if(tabBarController.selectedIndex == TAB_BAR_INDEX_NOTIFICATION){
//        
//        UITabBarItem *tabBarItem = [[self.viewControllers objectAtIndex:TAB_BAR_INDEX_NOTIFICATION] tabBarItem];
//        tabBarItem.badgeValue = 0;
//        
//        // [self.needNavigationController pushViewController:self.needViewController animated:YES];
//        
//    }
//    else if(tabBarController.selectedIndex == TAB_BAR_INDEX_MESSAGES){
//        
//        UITabBarItem *tabBarItem = [[self.viewControllers objectAtIndex:TAB_BAR_INDEX_MESSAGES] tabBarItem];
//        tabBarItem.badgeValue = 0;
//    }
    
}

- (void)applicationDidReceiveRemoteNotification:(NSNotification *)note {
    
    NSLog(@"notification userinfo :%@",     [[note.userInfo objectForKey:kAPNSKey]objectForKey:kAPNSAlertKey]);
    NSString *payloadType = [note.userInfo objectForKey:kHLPushPayloadPayloadTypeKey];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    if(payloadType){
        
        if([payloadType isEqualToString:kHLPushPayloadPayloadTypeNotificationFeedKey]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kHLLoadFeedObjectsNotification object:self];
            
            UITabBarItem *tabBarItem = [[self.viewControllers objectAtIndex:TAB_BAR_INDEX_NOTIFICATION] tabBarItem];
            
            NSString *currentBadgeValue = tabBarItem.badgeValue;
                        
            if (currentBadgeValue && currentBadgeValue.length > 0) {
                
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
                NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
                tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
            } else {
                tabBarItem.badgeValue = @"1";
            }

        }
        else if([payloadType isEqualToString:kHLPushPayloadPayloadTypeMessagesKey]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kHLLoadMessageObjectsNotification object:self];
            
            UITabBarItem *tabBarItem = [[self.viewControllers objectAtIndex:TAB_BAR_INDEX_MESSAGES] tabBarItem];
            
            NSString *currentBadgeValue = tabBarItem.badgeValue;
            
            if (currentBadgeValue && currentBadgeValue.length > 0) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                NSNumber *badgeValue = [numberFormatter numberFromString:currentBadgeValue];
                NSNumber *newBadgeValue = [NSNumber numberWithInt:[badgeValue intValue] + 1];
                tabBarItem.badgeValue = [numberFormatter stringFromNumber:newBadgeValue];
            } else {
                tabBarItem.badgeValue = @"1";
            }
        }
    }
    
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLAppDelegateApplicationDidReceiveRemoteNotification object:nil];
    
}


@end
