//
//  LoginViewController.h
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ChattingManager.h"
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
- (IBAction)signUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *login;
- (IBAction)login:(id)sender;

@end
