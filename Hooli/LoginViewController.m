
//
//  LoginViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewViewController.h"
#import "MBProgressHUD.h"
#import "AccountManager.h"
#import "EditProfileViewController.h"

@interface LoginViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton  addTarget:self
                          action:@selector(loginFB)
                forControlEvents:UIControlEventTouchUpInside];
   // [self.loginButton  setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    self.loginButton.frame = CGRectMake(60, 380, 214, 41);
//    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    self.loginButton.center = CGPointMake(160, 420);
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"LoginWithFacebook"] forState:UIControlStateNormal];
    self.loginButton.layer.masksToBounds = YES;
    self.tabBarController.tabBar.hidden=YES;
    self.navigationController.navigationBar.hidden = YES;
    [self.view addSubview:self.loginButton];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {

        [self loginSuccess];

    }
}

- (void)loginFB {
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_location"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD show:YES];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        [HUD hide:YES];
        
        if (!user) {
            
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
            
        } else {
            

            [self performSegueWithIdentifier:@"loginSuccess" sender:self];
          
            
            
        }
    }];
    
}

-(void)loginSuccess{
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:^{
    
    }];

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
