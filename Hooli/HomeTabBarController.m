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
@interface HomeTabBarController ()

@end

@implementation HomeTabBarController
@synthesize needViewController,needNavigationController;
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item  {
    
    if(item.tag == 2){
        
        UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
        MyCameraViewController *cameraVC = [mainSb instantiateViewControllerWithIdentifier:@"MyCameraViewController"];
//        cameraVC.navigationController.navigationBarHidden = YES;
//        cameraVC.navigationItem.hidesBackButton = YES;
        
        [cameraVC initCameraPickerWithCompletionBlock:^(BOOL succeeded) {
            
        
            [self.navigationController pushViewController:cameraVC animated:NO];
            
            
        
        }];

        
    }
    
}

-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    NSLog(@"selected %d",tabBarController.selectedIndex);
    
    if(tabBarController.selectedIndex == 3){
        
        
        //   [self.needNavigationController pushViewController:self.needViewController animated:YES];
        
    }
    
}



@end
