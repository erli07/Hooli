//
//  HomeTabBarController.h
//  Hooli
//
//  Created by Er Li on 12/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeedTableViewController.h"
@interface HomeTabBarController : UITabBarController<UITabBarControllerDelegate,UITabBarDelegate>
@property (nonatomic, strong) NeedTableViewController *needViewController;
@property (nonatomic, strong) UINavigationController *needNavigationController;
@end
