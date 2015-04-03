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
#import "camera.h"
#import "SelectGenderViewController.h"
#import "HLConstant.h"
@interface SignUpViewController ()<HLSelectGenderDelegate>{
    
    MBProgressHUD *HUD;
}

@end

const CGFloat duration = 0.3;

@implementation SignUpViewController
@synthesize nameLabel,nameText,emailLabel,emailText,passwordLabel,passwordText,rePasswordLabel,rePasswordText,portraitImage,genderTextField,genderSegmentControl;

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
    
    self.genderTableView.scrollEnabled = NO;
    // Do any additional setup after loading the view.
}




-(void)dismissKeyboards{
    
    [self.nameText resignFirstResponder];
    [self.emailText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.rePasswordText resignFirstResponder];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == self.genderTextField){
        
        SelectGenderViewController *vc = [[SelectGenderViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        [textField resignFirstResponder];

    }
    else{
        
        
        [UIView animateWithDuration:duration animations:^{
            
            CGRect viewFrame = self.view.frame;
            viewFrame.origin.y = -170;
            self.view.frame = viewFrame;
            
            
        }];
        
    }
    
}

//delegate method

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"genderCell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"genderCell"];
    }
    
    cell.textLabel.text= @"Select Gender";
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        SelectGenderViewController *vc = [[SelectGenderViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}

-(void)didSelectGender:(NSString *)gender{
    
   // self.genderTextField.text = gender;
    
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
    
    if ([self.emailText.text isEqualToString: @""] || [self.nameText.text isEqualToString:@""] || [self.passwordText.text isEqualToString:@""] || [self.genderTextField.text isEqualToString:@""]) {
        
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
    
    NSString *gender;
    
    if(self.genderSegmentControl.selectedSegmentIndex == 0){
        
        gender = USER_GENDER_MALE;
    }
    else{
        
        gender = USER_GENDER_FEMALE;
        
    }
    
    UserModel *userModel = [[UserModel alloc]initUserWithEmail:self.emailText.text userName:self.nameText.text password:self.passwordText.text portraitImage:self.portraitImage.image gender:gender];
    
    
    [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    
    [[AccountManager sharedInstance]checkIfUserExistedWithUser:userModel block:^(BOOL succeeded, NSError *error) {
        
        
        if(!succeeded){
            
            [[AccountManager sharedInstance]submitUserProfileWithUser:userModel Success:^{
                
                [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                
                UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                [self presentViewController:vc animated:YES completion:^{
                    
                    NSLog(@"Submit success");
                    
                }];
                //  [self.navigationController pushViewController:vc animated:YES];
                
                
            } Failure:^(id error) {
                
                [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                
                NSLog(@"Submit failure");
                
            }];
            
            
        }
        else{
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            
            NSString *alertMsg = [NSString stringWithFormat:@"User with email:%@ already registered", emailText.text];
            
            UIAlertView *userExistsAlert = [[UIAlertView alloc]initWithTitle:@"Oops" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [userExistsAlert show];
            
            
        }
    }];
    
    
    
    
    
    
}
- (IBAction)editPhoto:(id)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    [action showInView:self.view];
}


#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    
    self.portraitImage.image = picture;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == 0)	ShouldStartCamera(self, YES);
        if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
    }
}

@end
