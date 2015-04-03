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
#import "FollowListViewController.h"
#import "NeedTableViewCell.h"
#import "NeedTableViewController.h"
#import "NeedDetailViewController.h"
#import "MyRelationshipViewController.h"
#import "MyProfileDetailViewController.h"
#import "LoginWelcomeViewController.h"
#import "HLUtilities.h"
#import "MyActivitiesViewController.h"
@interface MyProfileViewController ()
@property (nonatomic,strong) UIImageView *profilePictureView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *logoutButton;
@property (nonatomic) NeedTableViewController *needsViewController;
@property (nonatomic,strong) NSString *myCredtis;
@property (nonatomic) NSArray* imagesArray;

@end

@implementation MyProfileViewController
@synthesize needsViewController,myCredtis,imagesArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"star"], [UIImage imageNamed:@"item"],[UIImage imageNamed:@"user"],[UIImage imageNamed:@"group"],[UIImage imageNamed:@"setting"],nil];
    
    [[HLSettings sharedInstance]setCurrentPageIndex:3];    

    [self addUIElements];
    

    //    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated{
    
    if(![HLUtilities checkIfUserLoginWithCurrentVC:self]){
        
        return;
        
    }
    else{
        
        [self updateProfileData];
        
    }
    
}

-(void)addUIElements{
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Profile";
    self.profilePictureView = [[UIImageView alloc]initWithFrame:CGRectMake(120, 80, 80, 80)];
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height/2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 160, 200, 30)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.nameLabel setFont: [UIFont fontWithName:[HLTheme mainFont] size:14.0f]];
    [self.view addSubview:self.profilePictureView];
    [self.view addSubview:self.nameLabel];
    
}


#pragma mark -
#pragma mark Data

// Set received values if they are not nil and reload the tabl ta
- (void)updateProfileData {
    
    PFUser *user = [PFUser currentUser];
    PFFile *theImage = [user objectForKey:kHLUserModelKeyPortraitImage];
    NSData *imageData = [theImage getData];
    self.nameLabel.text =[NSString stringWithFormat:@"Welcome %@！", user.username];
    self.profilePictureView.image = [UIImage imageWithData:imageData];
    [self.settingTableView reloadData];
    
//    [[AccountManager sharedInstance]loadAccountDataWithSuccess:^(id object) {
//        
//        PFUser *user = [PFUser currentUser];
//        PFFile *theImage = [user objectForKey:kHLUserModelKeyPortraitImage];
//        NSData *imageData = [theImage getData];
//        self.nameLabel.text =[NSString stringWithFormat:@"Welcome %@！", user.username];
//        self.profilePictureView.image = [UIImage imageWithData:imageData];
//        self.myCredtis = [user objectForKey:kHLUserModelKeyCredits];
//        [self.settingTableView reloadData];
//
//    } Failure:^(id error) {
//        
//        PFUser *user = [PFUser currentUser];
//        PFFile *theImage = [user objectForKey:kHLUserModelKeyPortraitImage];
//        NSData *imageData = [theImage getData];
//        self.nameLabel.text =[NSString stringWithFormat:@"Welcome %@！", user.username];
//        self.profilePictureView.image = [UIImage imageWithData:imageData];
//        self.myCredtis = [user objectForKey:kHLUserModelKeyCredits];
//        [self.settingTableView reloadData];
//
//    }];
    
}

#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(indexPath.section == 0){
        
//        if(indexPath.row == 0){
//            
//            [self performSegueWithIdentifier:@"myCredits" sender:self];
//            
//        }
//        else
            if(indexPath.row == 0){
            
                UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                HomeViewViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeVC"];
                vc.hidesBottomBarWhenPushed = YES;
                // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self.navigationController pushViewController:vc animated:YES];
       //     [self performSegueWithIdentifier:@"myItems" sender:self];
       
        }

        else if(indexPath.row == 1){
            
            UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyActivitiesViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"MyActivitiesViewController"];
            vc.aUser = [PFUser currentUser];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
//            MyActivitiesViewController *myAc = [[MyActivitiesViewController alloc]initWithUser:[PFUser currentUser]];
//            
//            myAc.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:myAc animated:YES];

        }
        else if(indexPath.row == 2){
            
            [self performSegueWithIdentifier:@"myItems" sender:self];
            
        }

    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            MyProfileDetailViewController *profileDetailVC = [[MyProfileDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
            profileDetailVC.user = [PFUser currentUser];
            profileDetailVC.tableView.allowsSelection = YES;
            profileDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profileDetailVC animated:YES];
            
        }
        else if(indexPath.row == 1){
            
            MyRelationshipViewController *vc = [[MyRelationshipViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
//            FollowListViewController *vc = [[FollowListViewController alloc] init];
//            vc.followStatus =  HL_RELATIONSHIP_TYPE_IS_FOLLOWING;
//            vc.fromUser = [PFUser currentUser];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            
        }
//        else if(indexPath.row == 2){
//            
//            FollowListViewController *vc = [[FollowListViewController alloc] init];
//            vc.followStatus =  HL_RELATIONSHIP_TYPE_IS_FOLLOWING;
//            vc.fromUser = [PFUser currentUser];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }
//        else if(indexPath.row == 3){
//            
//            FollowListViewController *vc = [[FollowListViewController alloc] init];
//            vc.followStatus =  HL_RELATIONSHIP_TYPE_IS_FOLLOWED;
//            vc.fromUser = [PFUser currentUser];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
//
//        }
        
    }
    else if(indexPath.section == 2){
        
        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditProfileViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"settings"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
//        UIAlertView *logoutAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//        logoutAlert.delegate = self;
//        [logoutAlert show];
        
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
        
//        if(indexPath.row == 0){
//            
//            cell.textLabel.text =[NSString stringWithFormat:@"%@ (%@)",@"My Credits",self.myCredtis];
//            cell.imageView.image = [self.imagesArray objectAtIndex:0];
//
//        }
//        else
        
        if(indexPath.row == 0){
            
          //     cell.textLabel.text = @"My Items";
            
            cell.textLabel.text = @"二手市场";

            cell.imageView.image = [UIImage imageNamed:@"shopping"];

        }
        else if(indexPath.row == 1){
            
            //     cell.textLabel.text = @"My Items";
            
            cell.textLabel.text = @"我的活动";
            
            cell.imageView.image = [self.imagesArray objectAtIndex:0];
            
        }
        else if(indexPath.row == 2){
            
            //     cell.textLabel.text = @"My Items";
            
            cell.textLabel.text = @"我的物品";
            
            cell.imageView.image = [self.imagesArray objectAtIndex:1];
            
        }
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
           // cell.textLabel.text = @"My Profile";
            cell.textLabel.text = @"个人资料";

            cell.imageView.image = [self.imagesArray objectAtIndex:2];
            
        }
        else if(indexPath.row == 1){
            
          //  cell.textLabel.text = @"My Relations";

            cell.textLabel.text = @"我的朋友";
            cell.imageView.image = [self.imagesArray objectAtIndex:3];
            
        }

    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = @"设置";
        
       // cell.textLabel.text = @"Settings";

        cell.imageView.image = [self.imagesArray objectAtIndex:4];

    }

    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 3;
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


//- (BOOL)checkIfUserLogin{
//    
//    
//    if(![PFUser currentUser]){
//        
//        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginWelcomeViewController *loginVC = [loginSb instantiateViewControllerWithIdentifier:@"LoginWelcomeViewController"];
//        self.navigationController.navigationBarHidden = NO;
//        loginVC.title = self.title;
//        [self.navigationController pushViewController:loginVC animated:YES];
//        return NO;
//        
//    }
//
//    
//    return YES;
//}


@end
