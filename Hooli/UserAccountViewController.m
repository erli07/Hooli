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
#import "MyActivitiesViewController.h"
#import <MessageUI/MessageUI.h>

@interface UserAccountViewController ()<MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) PFUser *user;
@property (nonatomic) NSArray *userInfoArray;
@property (nonatomic, assign) RelationshipType followStatus;
@property (nonatomic) NSArray* imagesArray;
@end

@implementation UserAccountViewController
@synthesize user, userNameLabel, userID, tableView, userInfoArray,followButton,contactButton,genderImage,followStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.userInfoArray = @[@"Activities", @"Items"];
    
    self.imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"star"],[UIImage imageNamed:@"item"],nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    
    self.profileImageView.layer.masksToBounds = YES;
    
    [self updateProfileData];
    
    self.title = @"Account";
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Report"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(reportUser)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    // self.tableView.scrollEnabled = NO;
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    // [self.tableView setFrame:CGRectMake(0, 200, 320, 200)];
    
}

- (void)updateProfileData {
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:self.userID Success:^(id object) {
        
        self.user = (PFUser *)object;
        
        if([self.user.objectId isEqualToString:[[PFUser currentUser]objectId]]){
            
            self.followButton.hidden = YES;
            
            self.contactButton.hidden = YES;
            
        }
        
        UserModel *userModel =  [[UserModel alloc]initUserWithPFObject:object];
        
        if([[object objectForKey:kHLUserModelKeyGender] isEqualToString:USER_GENDER_MALE]){
            
            self.genderImage.image = [UIImage imageNamed:@"male_symbol"];
            
        }
        else{
            
            self.genderImage.image = [UIImage imageNamed:@"female_symbol"];
            
        }
        
        NSDate *jointDate = [object createdAt];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"MMM yyyy"];
        NSString *joinDateStr = [dateFormatter stringFromDate:jointDate];
        
        self.joinDateLabel.text = [NSString stringWithFormat:@"Joined at %@", joinDateStr];
        
        NSString *signature = [object objectForKey:kHLUserModelKeySignature];
        
        if(signature){
            
            self.selfIntroLabel.text = signature;

        }
        else{
            
            self.selfIntroLabel.text = @"This guy is lazy, nothing left here...";
        }
        
        self.userNameLabel.text = userModel.username;
        
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0)
        return 1;
    else
        return 2;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    if(indexPath.section == 0){
        
       // cell.textLabel.text = @"个人资料";
        cell.textLabel.text = @"Profile";
        
        cell.imageView.image = [UIImage imageNamed:@"user"];
        
    }
    else{
        
        cell.textLabel.text =[self.userInfoArray objectAtIndex:indexPath.row];
        
        cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:14.0f];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            MyProfileDetailViewController *profileDetailVC = [[MyProfileDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
            profileDetailVC.user = self.user;
            profileDetailVC.tableView.allowsSelection = NO;
            profileDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:profileDetailVC animated:YES];
            
        }
        
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 1){
            UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
            UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userCart"];
            vc.userID = self.userID;
            vc.title =[NSString stringWithFormat:@"%@'s items",self.user.username];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            
            UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyActivitiesViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"MyActivitiesViewController"];
            vc.aUser = self.user;
            vc.title =[NSString stringWithFormat:@"%@'s items",self.user.username];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }
    
}


- (IBAction)followTheUser:(id)sender {
    
    if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWED || self.followStatus == HL_RELATIONSHIP_TYPE_NONE){
        
        [[ActivityManager sharedInstance]followUserInBackground:self.user block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Follow success!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
                [self updateRelationship];
                
                
            }
            
        }];
        
    }
    else{
        
        [[ActivityManager sharedInstance]unFollowUserInBackground:self.user block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Cancel following" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                
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
    
    //    if([self.user.objectId isEqual:[[PFUser currentUser]objectId]]){
    //
    //        self.followButton.hidden = YES;
    //    }
    //    else{
    //
    //        self.followButton.hidden = NO;
    //
    //    }
    //
    
    [[ActivityManager sharedInstance]getUserRelationshipWithUserOne:[PFUser currentUser] UserTwo:self.user WithBlock:^(RelationshipType relationType, NSError *error) {
        
        self.followStatus = relationType;
        
        NSLog(@"Get relationship %u", relationType);
        
        if(self.followStatus == HL_RELATIONSHIP_TYPE_FRIENDS || self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWING ){
            
            [self.followButton setTitle:@"Followed" forState:UIControlStateNormal] ;
            [self.followButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
            [self.followButton setTitleColor:[HLTheme buttonColor] forState:UIControlStateNormal];
            
        }
        else{
            
            [self.followButton setTitle:@"Follow" forState:UIControlStateNormal] ;
            [self.followButton setBackgroundImage:[UIImage imageNamed:@"button-pressed"] forState:UIControlStateNormal];
            [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
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

#pragma mark MFMail delegate

-(void)reportUser{
    
    MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setSubject:[NSString stringWithFormat:@"Report user %@ %@",self.user.objectId,self.user.username]];
    [mailVC setMessageBody:[NSString stringWithFormat:@"Hi, this user : %@, %@ generates inapropriate content. Please help to stop him asap.",self.user.objectId,self.user.username] isHTML:NO];
    [mailVC setToRecipients:[NSArray arrayWithObject:@"hoolihelp@gmail.com"]];
    
    if (mailVC)
        
        [self presentViewController:mailVC animated:YES completion:^{
            
        }];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
