//
//  ChatViewController.m
//  Hooli
//
//  Created by Er Li on 4/24/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ChatViewController.h"
#import "RCIM.h"
#import "UserCartViewController.h"
@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RCIM sharedRCIM] setUserPortraitClickEvent:^(UIViewController *viewController, RCUserInfo *userInfo) {
        
        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userAccount"];
        vc.userID = self.currentTarget;
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        //导航和的配色保持一直
        UIImage *image= [viewController.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        //[nav.navigationBar setBackgroundImage:self.navigationController.navigationBar. forBarMetrics:UIBarMetricsDefault];
        
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
