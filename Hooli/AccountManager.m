//
//  AccountManager.m
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "AccountManager.h"
#import "UserModel.h"
@implementation AccountManager
@synthesize uploadFailure = _uploadFailure;
@synthesize uploadSuccess = _uploadSuccess;
@synthesize downloadSuccess = _dowloadSuccess;
@synthesize downloadFailure = _downloadFailure;
+(AccountManager *)sharedInstance{
    
    static AccountManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AccountManager alloc] init];
    });
    
    return _sharedInstance;
}


- (void)loadFaceBookAccountDataWithSuccess:(DownloadSuccessBlock)success
                           Failure:(DownloadFailureBlock)failure{
    
    _dowloadSuccess = success ;
    _downloadFailure = failure;
    
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
            
            NSString *email = userData[@"email"];
            if (email) {
                userProfile[@"email"] = email;
            }
            
            NSString *gender = userData[@"gender"];
            if (gender) {
                userProfile[@"gender"] = gender;
            }
            
            userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            _dowloadSuccess(nil);
            
        } else {
            
            _downloadFailure(error);
            
        }
    }];
}

- (void)loadAccountDataWithSuccess:(DownloadSuccessBlock)success
                                Failure:(DownloadFailureBlock)failure{
    
    _dowloadSuccess = success ;
    _downloadFailure = failure;
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudUserClass];
    [query whereKey:kHLUserModelKeyUserId equalTo:[[PFUser currentUser]objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
            _downloadFailure(error);
        }
        else{
            PFFile *theImage = [object objectForKey:kHLUserModelKeyPortraitImage];
            NSData *imageData = [theImage getData];
            UIImage *portraitImage = [UIImage imageWithData:imageData];
            [PFUser currentUser][@"profile"][@"email"] = [object objectForKey:kHLUserModelKeyEmail];
            [PFUser currentUser][@"profile"][@"name"] = [object objectForKey:kHLUserModelKeyUserName];
            _dowloadSuccess(portraitImage);

        }
    }];
    
}

- (void)loadAccountDataWithUserId:(NSString *)userId
                          Success:(DownloadSuccessBlock)success
                          Failure:(DownloadFailureBlock)failure{
    
    _dowloadSuccess = success ;
    _downloadFailure = failure;
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudUserClass];
    [query whereKey:kHLUserModelKeyUserId equalTo:userId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
            _downloadFailure(error);
        }
        else{
            PFFile *theImage = [object objectForKey:kHLUserModelKeyPortraitImage];
            NSData *imageData = [theImage getData];
            UIImage *portraitImage = [UIImage imageWithData:imageData];
            [PFUser currentUser][@"profile"][@"email"] = [object objectForKey:kHLUserModelKeyEmail];
            [PFUser currentUser][@"profile"][@"name"] = [object objectForKey:kHLUserModelKeyUserName];
            _dowloadSuccess(portraitImage);
            
        }
    }];
    
}

- (NSString *)getUserName{
    
   //[self loadAccountData];
    
    return [PFUser currentUser][@"profile"][@"name"];
    
}


-(NSString *)getEmail{
    
  // [self loadAccountData];
    
    return [PFUser currentUser][@"profile"][@"email"];

}

-(NSString *)getGender{
    
  //  [self loadAccountData];
    
    return [PFUser currentUser][@"profile"][@"gender"];
    
}

-(void)setInfomationFromFaceBookWithEmail{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            
        }
    }];
}


-(UIImage *)getFBPortraitImage{
    
   __block UIImage  *portraitImage = nil;
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       
                                       portraitImage = [UIImage imageWithData:data];
                                       
                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
    return portraitImage;
}



- (void)setUserFacebookProfilePicture:(UIImageView *)profileImageView{
    
  //  [self loadAccountData];
    
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


- (void)setUserProfilePicture:(UIImageView *)profileImageView{

    PFQuery *query = [PFQuery queryWithClassName:kHLCloudUserClass];
    [query whereKey:kHLUserModelKeyUserId equalTo:[[PFUser currentUser]objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);

        }
        else{
            PFFile *theImage = [object objectForKey:kHLUserModelKeyPortraitImage];
            NSData *imageData = [theImage getData];
            profileImageView.image = [UIImage imageWithData:imageData];

            
        }
    }];
    
}
-(void)submitUserProfileWithUser:(UserModel *)userModel
                        Success:(UploadSuccessBlock)success
                        Failure:(UploadFailureBlock)failure{
    
    _uploadSuccess = success ;
    _uploadFailure = failure;
    
    PFObject *userClassObject = [PFObject objectWithClassName:kHLCloudUserClass];
    
    NSData *imageData = UIImagePNGRepresentation(userModel.portraitImage);
    PFFile *image = [PFFile fileWithName:@"portrait.jpg" data:imageData];
    [userClassObject setObject:image forKey:kHLUserModelKeyPortraitImage];
    [userClassObject setObject:userModel.email forKey:kHLUserModelKeyEmail];
    [userClassObject setObject:userModel.username forKey:kHLUserModelKeyUserName];
    [userClassObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _uploadSuccess();
                
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _uploadFailure(error);
                
            });
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
    
}

-(void)updateUserProfileWithUser:(UserModel *)userModel
                         Success:(UploadSuccessBlock)success
                         Failure:(UploadFailureBlock)failure{
    
    _uploadSuccess = success ;
    _uploadFailure = failure;
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudUserClass];
    [query whereKey:kHLUserModelKeyUserId equalTo:[[PFUser currentUser]objectId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
            
            PFObject *userClassObject = [PFObject objectWithClassName:kHLCloudUserClass];
            
            NSData *imageData = UIImagePNGRepresentation(userModel.portraitImage);
            PFFile *image = [PFFile fileWithName:@"portrait.jpg" data:imageData];
            [userClassObject setObject:image forKey:kHLUserModelKeyPortraitImage];
            [userClassObject setObject:userModel.email forKey:kHLUserModelKeyEmail];
            [userClassObject setObject:userModel.username forKey:kHLUserModelKeyUserName];
            [userClassObject setObject:userModel.userID forKey:kHLUserModelKeyUserId];

            [userClassObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _uploadSuccess();
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _uploadFailure(error);
                        
                    });
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            
            
        } else {
            
            NSData *imageData = UIImagePNGRepresentation(userModel.portraitImage);
            PFFile *image = [PFFile fileWithName:@"portrait.jpg" data:imageData];
            [object setObject:image forKey:kHLUserModelKeyPortraitImage];
            [object setObject:userModel.email forKey:kHLUserModelKeyEmail];
            [object setObject:userModel.username forKey:kHLUserModelKeyUserName];
            [object setObject:userModel.userID forKey:kHLUserModelKeyUserId];

            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _uploadSuccess();
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _uploadFailure(error);
                        
                    });
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
            }
        
    }];
    
    
    
}
@end
