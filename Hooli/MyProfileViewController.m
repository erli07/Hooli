//
//  MyProfileViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyProfileViewController.h"
#import "HLTheme.h"
#import "AccountManager.h"
#import "LoginViewController.h"
@interface MyProfileViewController ()
@property (nonatomic,strong) UIImageView *profilePictureView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *logoutButton;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUIElements];
    [self updateProfileData];
    //    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)addUIElements{
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Profile";
    self.profilePictureView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 80, 100, 100)];
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height/2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 180, 200, 50)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.nameLabel setFont: [UIFont fontWithName:[HLTheme mainFont] size:17.0f]];
    [self.view addSubview:self.profilePictureView];
    [self.view addSubview:self.nameLabel];
    
}

- (void)logoutFB{
    
    [PFUser logOut];
    // Return to login view controller
    
    NSString * storyboardName = @"Login";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    LoginViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    // [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Data

// Set received values if they are not nil and reload the table
- (void)updateProfileData {
    

        [[AccountManager sharedInstance]loadAccountDataWithSuccess:^(id object) {
            
           
            self.nameLabel.text =[NSString stringWithFormat:@"Welcome %@！", [[AccountManager sharedInstance]getUserName]];
            self.profilePictureView.image = (UIImage *)object;
            
            
        } Failure:^(id error) {
            
            NSLog(@"%@",error);
            
        }];
    
    
}

#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 2){
        
        UIAlertView *logoutAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        logoutAlert.delegate = self;
        [logoutAlert show];
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        
        cell.textLabel.text = @"Help Center";
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"My Profile";
            
        }
        else{
            
            cell.textLabel.text = @"Settings";
            
        }
    }
    else{
        
        cell.textLabel.text = @"Log Out";
        
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 1;
    else if(section == 1)
        return 2;
    else
        return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}

#pragma mark alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
    }
    else{
        
        [self logoutFB];
    }
}
@end
