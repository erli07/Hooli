//
//  AccountManager.m
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager

+(AccountManager *)sharedInstance{
    
    static AccountManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AccountManager alloc] init];
    });
    
    return _sharedInstance;
}


- (void)loadAccountData {

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
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}



- (NSString *)getUserName{
    
    [self loadAccountData];
    
    return [PFUser currentUser][@"profile"][@"name"];
    
}

- (void)setUserProfilePicture:(UIImageView *)profileImageView{
    
    [self loadAccountData];
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       
                                       profileImageView.image = [UIImage imageWithData:data];
                                       
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
    
}

@end
