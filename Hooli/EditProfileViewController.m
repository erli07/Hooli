//
//  EditProfileViewController.m
//  Hooli
//
//  Created by Er Li on 11/9/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AccountManager.h"
#import "UserModel.h"
#import "MBProgressHUD.h"
#import "HomeViewViewController.h"
#import "HLTheme.h"
@interface EditProfileViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) UIImagePickerController *picker;

@end

@implementation EditProfileViewController
@synthesize portraitImage,username,userNameTextField,email,emailTextField,picker;

- (void)viewDidLoad {
    
    [super viewDidLoad];


    self.username.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
    self.email.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
    self.portraitImage.layer.cornerRadius = self.portraitImage.frame.size.height/2;
    self.portraitImage.layer.masksToBounds = YES;
    self.navigationController.navigationBar.hidden = NO;

    [self getUserInfo];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboards)];
    
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

-(void)getUserInfo{
    
    NSString *userName =[[PFUser currentUser]objectForKey:kHLUserModelKeyUserName];
    NSString *emailAddress = [[PFUser currentUser]objectForKey:kHLUserModelKeyEmail];
    PFFile *portraitFile = [[PFUser currentUser]objectForKey:kHLUserModelKeyPortraitImage];
    NSData *imageData = [portraitFile getData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.userNameTextField.text = userName;
    
    self.emailTextField.text = emailAddress;
    
    self.portraitImage.image = image;
    
}

-(void)viewWillAppear:(BOOL)animated{
    

    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [chosenImage drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.02f);
    
    self.portraitImage.image = [UIImage imageWithData:imageData];
        
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)submitUser:(id)sender {
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    if(![self.userNameTextField.text isEqualToString:@""] || ![self.emailTextField.text isEqualToString:@""]){
        

        UserModel *user = [[UserModel alloc]initUserWithEmail:self.emailTextField.text userName:self.userNameTextField.text password:nil portraitImage:self.portraitImage.image userID:[[PFUser currentUser]objectId]];

        
        [[AccountManager sharedInstance]updateUserProfileWithUser:user Success:^{
            
            [HUD hide:YES];

            UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
            // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        } Failure:^(id error) {
            
            [HUD hide:YES];
            
        }];
        
    }
    
    
}

- (IBAction)uploadPhoto:(id)sender {
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    

}

-(void)dismissKeyboards{
    
    [self.emailTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    
}

@end
