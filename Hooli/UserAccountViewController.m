//
//  UserAccountViewController.m
//  Hooli
//
//  Created by Er Li on 2/10/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "UserAccountViewController.h"
#import "AccountManager.h"
#import "UserModel.h"
#import "HLTheme.h"
#import "UserCartViewController.h"
#import "ActivityManager.h"
#import "MyProfileDetailViewController.h"
#import "NeedTableViewController.h"
#import "messages.h"
#import "ChatView.h"

@interface UserAccountViewController ()
@property (nonatomic, strong) PFUser *user;
@property (nonatomic) NSArray *userInfoArray;
@property (nonatomic, assign) RelationshipType followStatus;
@property (nonatomic) NSArray* imagesArray;
@end

@implementation UserAccountViewController
@synthesize user, userNameLabel, userID, tableView, userInfoArray,followButton,contactButton,followStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userInfoArray = @[@"Items", @"Profile"];
    
    self.imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"item"],[UIImage imageNamed:@"user"],nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    
    self.profileImageView.layer.masksToBounds = YES;
    
    [self updateProfileData];
    
   // self.tableView.scrollEnabled = NO;
    

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
   // [self.tableView setFrame:CGRectMake(0, 200, 320, 200)];
    
}

- (void)updateProfileData {
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:self.userID Success:^(id object) {
        
        self.user = (PFUser *)object;
        
        UserModel *userModel =  [[UserModel alloc]initUserWithPFObject:object];
        
        self.userNameLabel.text = userModel.username;
        
        self.title = userModel.username;
        
        [self.userNameLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:16.0f]];
        
        self.profileImageView.image = userModel.portraitImage;
        
        [self.view addSubview:self.profileImageView];
        
        [self updateRelationship];

        
    } Failure:^(id error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.userInfoArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text =[self.userInfoArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:14.0f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userCart"];
        vc.userID = self.userID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if(indexPath.row == 2){
        
        NeedTableViewController *needsViewController = [[NeedTableViewController alloc]init];
        needsViewController.user = self.user;
        needsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:needsViewController animated:YES];
        
    }
    else if(indexPath.row == 1){
        
        MyProfileDetailViewController *profileDetailVC = [[MyProfileDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
        profileDetailVC.user = self.user;
        profileDetailVC.tableView.allowsSelection = NO;
        profileDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:profileDetailVC animated:YES];

    }
    
}


- (IBAction)followTheUser:(id)sender {
    
    if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWED || self.followStatus == HL_RELATIONSHIP_TYPE_NONE){
        
        [[ActivityManager sharedInstance]followUserInBackground:self.user block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                
                NSLog(@"Follow success!!!");
                
                [self updateRelationship];
                
                
            }
            
        }];
        
    }
    else{
        
        [[ActivityManager sharedInstance]unFollowUserInBackground:self.user block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                
                NSLog(@"UnFollow success!!!");
                
                [self updateRelationship];
                
            }
            
        }];
        
    }
    
}

- (IBAction)contactUser:(id)sender {
    
    [[AccountManager sharedInstance]fetchUserWithUserId:self.user.objectId success:^(id object) {
        
        PFUser *user1 = [PFUser currentUser];
        PFUser *user2 = (PFUser *)object;
        NSString *groupId = StartPrivateChat(user1, user2);
        ChatView *chatView = [[ChatView alloc] initWith:groupId];
        chatView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatView animated:YES];
    
    } failure:^(id error) {
        
    }];
      
}

-(void)updateRelationship{
    
    if([self.user.objectId isEqual:[[PFUser currentUser]objectId]]){
        
        self.followButton.hidden = YES;
    }
    else{
        
        self.followButton.hidden = NO;
        
    }
    
    
    [[ActivityManager sharedInstance]getUserRelationshipWithUserOne:[PFUser currentUser] UserTwo:self.user WithBlock:^(RelationshipType relationType, NSError *error) {
        
        self.followStatus = relationType;
        
        NSLog(@"Get relationship %u", relationType);
        
        if(self.followStatus == HL_RELATIONSHIP_TYPE_FRIENDS || self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWING ){
            
            [self.followButton setTitle:@"Followed" forState:UIControlStateNormal] ;
            [self.followButton setBackgroundColor:[HLTheme mainColor]];
            [self.followButton setTintColor:[UIColor whiteColor]];
            
        }
        else{
            
            [self.followButton setTitle:@"Follow" forState:UIControlStateNormal] ;
            [self.followButton setBackgroundColor:[HLTheme mainColor]];
            [self.followButton setTintColor:[UIColor whiteColor]];
            
        }
        
        [self updateUserFollowCounts];
        
        
    }];
}

-(void)updateUserFollowCounts{
    
    
    
    [[ActivityManager sharedInstance]getFollowedUsersByUser:self.user block:^(NSArray *array, NSError *error) {
        
        if(array){
            
            //self.followersCount.text = [NSString stringWithFormat:@"%d", [array count]];
            
        }
        
    }];
    
    [[ActivityManager sharedInstance]getFollowersByUser:self.user block:^(NSArray *array, NSError *error) {
        
        if(array){
            
           // self.followingCount.text = [NSString stringWithFormat:@"%d", [array count]];
        }
    }];
    
    [[ActivityManager sharedInstance]getFriendsByUser:self.user block:^(NSArray *array, NSError *error) {
        
        if(array){
            
            //self.friendsCount.text = [NSString stringWithFormat:@"%d", [array count]];
        }
    }];
    
}



@end
