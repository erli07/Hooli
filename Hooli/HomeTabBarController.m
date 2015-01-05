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
@interface HomeTabBarController ()

@end

@implementation HomeTabBarController
@synthesize needViewController,needNavigationController;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.delegate = self;
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.needViewController = [[storyboard instantiateViewControllerWithIdentifier:@"NeedTableViewController"]initWithStyle:UITableViewStylePlain];
   // [self.needViewController setParseClassName:kHLCloudNeedClass];
//    self.needViewController = [[NeedTableViewController alloc]initWithStyle:UITableViewStylePlain];
//    self.needNavigationController = [[UINavigationController alloc] initWithRootViewController:self.needViewController];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    NSLog(@"selected %d",tabBarController.selectedIndex);
    
    if(tabBarController.selectedIndex == 3){
        
        
     //   [self.needNavigationController pushViewController:self.needViewController animated:YES];
        
    }
    
}

@end
