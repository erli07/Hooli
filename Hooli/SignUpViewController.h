//
//  SignUpViewController.h
//  Hooli
//
//  Created by Er Li on 11/23/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface SignUpViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UILabel *rePasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordText;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
