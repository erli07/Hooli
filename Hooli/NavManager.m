//
//  NavManager.m
//  Hooli
//
//  Created by Er Li on 2/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "NavManager.h"
#import <Parse/Parse.h>
#import "UserCartViewController.h"
@implementation NavManager

+(NavManager *)sharedInstance{
    
    static NavManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[NavManager alloc] init];
    });
    
    return _sharedInstance;
}

-(void)goToUserProfile:(PFUser *)aUser{
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userCart"];
    vc.userID = aUser.objectId;
    vc.hidesBottomBarWhenPushed = YES;
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIViewController *currentVc=[window.rootViewController.navigationController visibleViewController];
    [currentVc.navigationController pushViewController:vc animated:YES];
    
}

@end
