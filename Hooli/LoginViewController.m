
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
#import "HLSettings.h"
#import "EditProfileViewController.h"
#import <Parse/Parse.h>
//#import "EaseMob.h"
#import "ChatListViewController.h"

@interface LoginViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong) IBOutlet UIButton *loginButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.hidden = YES;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"rsz_bkg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboards)];
    
    [self.view addGestureRecognizer:tap];
    
    //  self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.title = @"Login";
    
    [self.navigationController setNavigationBarHidden:NO];
    
    if ([PFUser currentUser] || [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        [self loginSuccessWithUser:[PFUser currentUser]];
        
    }
    else{
        
        [self.emailText becomeFirstResponder];
        
    }
}


-(void)dismissKeyboards{
    
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    
    
}
- (IBAction)loginWithEmail:(id)sender {
    
    if([self.emailText.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Email shall not be empty."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
        return;
    }
    
    if([self.passwordText.text isEqualToString:@""]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Password shall not be empty."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
        return;
    }
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:self.emailText.text];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if(object){
            
            [self.emailText resignFirstResponder];
            [self.passwordText resignFirstResponder];
            
            NSString *username = [object objectForKey:@"username"];
            [PFUser logInWithUsernameInBackground:username password:self.passwordText.text block:^(PFUser* user, NSError* error){
                
                if(user){
                    
                    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                    
                    [self loginSuccessWithUser:user];
//
//                    [[AccountManager sharedInstance]loadAccountDataWithSuccess:^(id object) {
//                        
//                        
//                    } Failure:^(id error) {
//                        
//                        [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
//                        
//                    }];
                    
                    
                    
                }
                else{
                    
                    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                                    message:@"Password is not correct. Please try again."
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                    [alert show];
                    
                    
                }
            }];
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                            message:@"Email does not exist. Please sign up."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            
            
        }
        
        
    }];
    
}


- (IBAction)loginButton:(id)sender {
    
    
    [self loginFB];
    
}

- (void)loginFB {
    
    
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me",@"email"];
    
    // Show the HUD while the provided method executes in a new thread
    [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        
        if (!user) {
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            
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
            
            [[AccountManager sharedInstance]saveFacebookAccountDataWithPFUser:user WithSuccess:^{
                
                [[ChattingManager sharedInstance]signUpChattingSDK:user block:^(BOOL succeeded, NSError *error) {
                    
                    
                    if(succeeded){
                        
                        [[ChattingManager sharedInstance]loginChattingSDK:user block:^(BOOL succeeded, NSError *error) {
                            
                            
                            
                            if(succeeded){
                                
                                [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                                
                                [self loginSuccessWithUser:[PFUser currentUser]];
                                
                                // [self performSegueWithIdentifier:@"loginSuccess" sender:self];
                                
                            }
                            else{
                                
                                [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                                
                                //                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                //                                                                                message:@"Log In Error"
                                //                                                                               delegate:nil
                                //                                                                      cancelButtonTitle:nil
                                //                                                                      otherButtonTitles:@"Dismiss", nil];
                                //                                [alert show];
                            }
                            
                            
                        }];
                        
                    }
                    
                }];
                
            } Failure:^(id error) {
                
                [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                
            }];
            
        }
    }];
    
}




-(void)loginSuccessWithUser:(PFUser *)currentUser{
    
    //  [[HLSettings sharedInstance]saveCurrentUser:currentUser];
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

- (IBAction)signUp:(id)sender {
    
}

@end
