//
//  MyProfileViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyProfileViewController.h"
#import "HLTheme.h"
@interface MyProfileViewController ()
@property (nonatomic,strong) UIImageView *profilePictureView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *logoutButton;
@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUIElements];
    [self loadData];
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
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    // [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark Data

- (void)loadData {
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self updateProfileData];
    }
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            NSString *name = userData[@"name"];
            if (name) {
                userProfile[@"name"] = name;
            }
            
            userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            [self updateProfileData];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

// Set received values if they are not nil and reload the table
- (void)updateProfileData {
    
    NSString *name = [PFUser currentUser][@"profile"][@"name"];
    if (name) {
        self.nameLabel.text =[NSString stringWithFormat:@"Welcome %@！", name];
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       
                                       self.profilePictureView.image = [UIImage imageWithData:data];
                                       
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
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
