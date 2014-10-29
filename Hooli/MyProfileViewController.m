//
//  MyProfileViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyProfileViewController.h"

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

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)addUIElements{
    
    
    self.profilePictureView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 100, 100, 100)];
    self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.height/2;
    self.profilePictureView.layer.masksToBounds = YES;
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 200, 200, 50)];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.logoutButton  addTarget:self
                           action:@selector(logoutFB)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.logoutButton  setTitle:@"Log out" forState:UIControlStateNormal];
    self.logoutButton.frame = CGRectMake(110, 380, 100, 40);

    [self.view addSubview:self.logoutButton];
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

@end
