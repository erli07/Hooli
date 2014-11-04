//
//  HomeTabBarController.m
//  Hooli
//
//  Created by Er Li on 10/30/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HomeTabBarController.h"
#import "MyCameraViewController.h"
@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 2){
        
//        MyCameraViewController *cameraVC = [[MyCameraViewController alloc]init];
//        [self.navigationController pushViewController:cameraVC animated:YES];
//        
//        
//        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
//        UIViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"camera"];
//        // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self presentViewController:vc animated:YES completion:^{
//            
//        }];

    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
