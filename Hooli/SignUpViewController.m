//
//  SignUpViewController.m
//  Hooli
//
//  Created by Er Li on 11/23/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "SignUpViewController.h"
#import "HLTheme.h"
#import "AccountManager.h"
#import "MBProgressHUD.h"
@interface SignUpViewController (){
    
    MBProgressHUD *HUD;
}

@end

const CGFloat duration = 0.3;

@implementation SignUpViewController
@synthesize nameLabel,nameText,emailLabel,emailText,passwordLabel,passwordText,rePasswordLabel,rePasswordText,portraitImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboards)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.nameLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
    
    self.emailLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];

    self.passwordLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];

    self.rePasswordLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];

    // Do any additional setup after loading the view.
}




-(void)dismissKeyboards{
    
    [self.nameText resignFirstResponder];
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.rePasswordText resignFirstResponder];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = -135;
        self.view.frame = viewFrame;
        
        
    }];

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0;
        self.view.frame = viewFrame;
        
        
    }];
    
}

-(BOOL)checkPassword{
    
    if ([self.passwordText.text isEqualToString: self.rePasswordText.text]) {
        
        return YES;
    }
    
    return NO;
    
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(id)sender {
    

    
    
    if ([self.emailText.text isEqualToString: @""] || [self.nameText.text isEqualToString:@""] || [self.passwordText.text isEqualToString:@""]) {
        
        UIAlertView *pwNotMatchedAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"User info is missing." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [pwNotMatchedAlert show];
        
        return;

    }
    
    if(![self NSStringIsValidEmail:self.emailText.text]){
        
        UIAlertView *pwNotMatchedAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Email format not correct." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [pwNotMatchedAlert show];
        
        return;
        
    }
    

    
    if(![self checkPassword]){
        
        UIAlertView *pwNotMatchedAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"Password not matched." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [pwNotMatchedAlert show];
        
        return;
    }
    
    
    UserModel *userModel = [[UserModel alloc]initUserWithEmail:self.emailText.text userName:self.nameText.text password:self.passwordText.text portraitImage:self.portraitImage.image];
    
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    
    [[AccountManager sharedInstance]checkIfUserExistedWithUser:userModel block:^(BOOL succeeded, NSError *error) {
        
        
        if(!succeeded){
            
            [[AccountManager sharedInstance]submitUserProfileWithUser:userModel Success:^{
                
                [HUD hide:YES];
                
                UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                [self presentViewController:vc animated:YES completion:^{
                    
                    NSLog(@"Submit success");

                }];
              //  [self.navigationController pushViewController:vc animated:YES];
                
                
            } Failure:^(id error) {
                
                [HUD hide:YES];
                
                NSLog(@"Submit failure");
                
            }];
            

        }
        else{
            
            [HUD hide:YES];

            NSString *alertMsg = [NSString stringWithFormat:@"User with email:%@ already registered", emailText.text];
            
            UIAlertView *userExistsAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [userExistsAlert show];
            
            
        }
    }];
        
    
    

    
    
}
@end
