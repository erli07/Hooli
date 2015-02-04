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
#import "EditProfileViewController.h"
#import "MyCartViewController.h"
#import "HomeViewViewController.h"
#import "HLSettings.h"
#import "HLCache.h"
#import "AppDelegate.h"

@interface MyProfileViewController ()
@property (nonatomic,strong) UIImageView *profilePictureView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *logoutButton;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    
    
    if([self checkIfUserLogin]){
        
        [self addUIElements];
    
    }
    [super viewDidLoad];

    //    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[HLSettings sharedInstance]setCurrentPageIndex:4];

    
    if([self checkIfUserLogin]){
        
        [self updateProfileData];
        
    }
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


#pragma mark -
#pragma mark Data

// Set received values if they are not nil and reload the table
- (void)updateProfileData {
    
    
    PFUser *user = [PFUser currentUser];
    PFFile *theImage = [user objectForKey:kHLUserModelKeyPortraitImage];
    NSData *imageData = [theImage getData];
    self.nameLabel.text =[NSString stringWithFormat:@"Welcome %@！", user.username];
    self.profilePictureView.image = [UIImage imageWithData:imageData];
    
}

#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(indexPath.section == 0){
        
        [self performSegueWithIdentifier:@"myItems" sender:self];
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            EditProfileViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"editProfile"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            
            UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            EditProfileViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"settings"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    else if(indexPath.section == 2){
        
        UIAlertView *logoutAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        logoutAlert.delegate = self;
        [logoutAlert show];
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"myItems"])
    {
        MyCartViewController *cart = segue.destinationViewController;
        
        cart.hidesBottomBarWhenPushed = YES;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"My Items";
            
        }


        
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
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] logOut];
    }
}

- (BOOL)checkIfUserLogin{
    
    
    if(![PFUser currentUser]){
        
        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVC = [loginSb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVC.navigationController.navigationBarHidden = NO;
        loginVC.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:loginVC animated:NO];
        return NO;
        
    }
    
    return YES;
}
@end
