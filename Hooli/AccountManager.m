//
//  AccountManager.m
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "AccountManager.h"
#import "OfferModel.h"
#import "UserModel.h"
#import "ChatListCell.h"
#import "NSString+MD5.h"
@implementation AccountManager
@synthesize uploadFailure = _uploadFailure;
@synthesize uploadSuccess = _uploadSuccess;
@synthesize downloadSuccess = _dowloadSuccess;
@synthesize downloadFailure = _downloadFailure;
@synthesize profileImage,userName,email,chattingId;
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
            
            NSString *name = userData[@"name"];
            
            NSString *email = userData[@"email"];
            
            __block UIImage  *portraitImage = nil;
            
            NSString *userProfilePhotoURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
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
                                           
                                           [[PFUser currentUser] setObject:portraitImage forKey:kHLUserModelKeyPortraitImage];
                                           [[PFUser currentUser] setObject:email forKey:kHLUserModelKeyEmail];
                                           [[PFUser currentUser] setObject:name forKey:kHLUserModelKeyUserName];
                                           [[PFUser currentUser] setObject:[[[PFUser currentUser]objectId]MD5] forKey:kHLUserModelKeyUserIdMD5];
                                           [[PFUser currentUser] saveInBackground];
                                           _dowloadSuccess(nil);
                                           
                                       }];
            }
            
            
        } else {
            
            _downloadFailure(error);
            
        }
    }];
}

-(void)saveFacebookAccountDataWithPFUser:(PFUser *)user
                             WithSuccess:(UploadSuccessBlock)success
                                 Failure:(UploadFailureBlock)failure{
    
    _uploadSuccess = success ;
    _uploadFailure = failure;
    
    if (user) {
        
        // Parse the data received
        NSDictionary *userData =  user[@"profile"];
        
        NSString *facebookID = userData[@"facebookId"];
        
        NSString *name = userData[@"name"];
        
        NSString *email = userData[@"email"];
        
        //  __block UIImage  *portraitImage = nil;
        
        NSString *userProfilePhotoURLString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
        // Download the user's facebook profile picture
        if (userProfilePhotoURLString) {
            NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                       if (connectionError == nil && data != nil) {
                                           
                                           PFFile *image = [PFFile fileWithName:@"portrait.jpg" data:data];
                                           [[PFUser currentUser] setObject:image forKey:kHLUserModelKeyPortraitImage];
                                           [[PFUser currentUser] setObject:email forKey:kHLUserModelKeyEmail];
                                           [[PFUser currentUser] setObject:name forKey:kHLUserModelKeyUserName];
                                           [[PFUser currentUser] setObject:[[[PFUser currentUser]objectId]MD5] forKey:kHLUserModelKeyUserIdMD5];
                                           [[PFUser currentUser] saveInBackground];
                                           
                                           _uploadSuccess();
                                           
                                       } else {
                                           
                                           NSLog(@"Failed to load profile photo.");
                                           _uploadFailure(nil);
                                           
                                       }
                                       
                                       
                                   }];
        }
        
        
    } else {
        
        _uploadFailure(nil);
        
    }
    
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
            NSString *_email = [object objectForKey:kHLUserModelKeyEmail];
            NSString *_name = [object objectForKey:kHLUserModelKeyUserName];
            NSString *_chattingId = [object objectForKey:kHLUserModelKeyUserIdMD5];

            PFFile *_portraitImage = [PFFile fileWithName:@"portrait.jpg" data:imageData];
            [[PFUser currentUser] setObject:_portraitImage forKey:kHLUserModelKeyPortraitImage];
            [[PFUser currentUser] setObject:_email forKey:kHLUserModelKeyEmail];
            [[PFUser currentUser] setObject:_name forKey:kHLUserModelKeyUserName];
            [[PFUser currentUser] setObject:_chattingId forKey:kHLUserModelKeyUserIdMD5];

         
            _dowloadSuccess(_portraitImage);
            
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
            
            UserModel *userModel = [[UserModel alloc]initUserWithPFObject:object];
            
            _dowloadSuccess(userModel);
            
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
    
    
    PFUser *newUser = [PFUser user];
    newUser.username = userModel.username;
    newUser.email = userModel.email;
    newUser.password = userModel.password;
    
    NSData *imageData = UIImagePNGRepresentation(userModel.portraitImage);
    PFFile *image = [PFFile fileWithName:@"portrait.jpg" data:imageData];
    [newUser setObject:image forKey:kHLUserModelKeyPortraitImage];
    [newUser setObject:[newUser.email MD5] forKey:kHLUserModelKeyUserIdMD5];
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(!error){
            
            
            [[ChattingManager sharedInstance]signUpChattingSDK:newUser block:^(BOOL succeeded, NSError *error) {
                if(succeeded){
                    
                    [[ChattingManager sharedInstance]loginChattingSDK:newUser block:^(BOOL succeeded, NSError *error) {
                        
                        if(succeeded){
                            
                            _uploadSuccess(nil);
                            
                        }
                        else{
                            
                            _uploadFailure(error);
                            
                        }
                        
                    }];
                    
                }
                else{
                    
                    _uploadFailure(error);
                    
                }
            }];
            
            
        }
        else{
            
            NSString *alertMsg = [NSString stringWithFormat:@"Username %@ already taken", newUser.username];
            
            UIAlertView *userExistsAlert = [[UIAlertView alloc]initWithTitle:@"" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [userExistsAlert show];
            
            _uploadFailure(error);
        }
        
    }];
    
    
    
}

-(void)checkIfUserExistedWithUser:(UserModel *)userModel
                            block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:kHLUserModelKeyEmail equalTo:userModel.email];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
            if (completionBlock) {
                completionBlock(NO,error);
            }
            
        }
        else{
            
            if (completionBlock) {
                completionBlock(YES,error);
            }
            
        }
    }];
    
}
-(void)updateUserProfileWithUser:(UserModel *)userModel
                         Success:(UploadSuccessBlock)success
                         Failure:(UploadFailureBlock)failure{
    
    _uploadSuccess = success ;
    _uploadFailure = failure;
    
    NSData *imageData = UIImagePNGRepresentation(userModel.portraitImage);
    PFFile *image = [PFFile fileWithName:@"portrait.jpg" data:imageData];
    
    [[PFUser currentUser] setObject:image forKey:kHLUserModelKeyPortraitImage];
    [[PFUser currentUser] setObject:userModel.email forKey:kHLUserModelKeyEmail];
    [[PFUser currentUser] setObject:userModel.username forKey:kHLUserModelKeyUserName];
    [[PFUser currentUser] setObject:userModel.chattingId forKey:kHLUserModelKeyUserIdMD5];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        
        if(succeeded){
            
            [[ChattingManager sharedInstance]signUpChattingSDK:[PFUser currentUser] block:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    
                    _uploadSuccess();
                }
                
                else{
                    
                    _uploadSuccess(error);
                }
                
            }];
            
            
        }
        else{
            
            _uploadFailure(error);
            
        }
        
    }];
    
    
}

-(void)fetchChattingIdWithPFUser:(PFUser *)user
                         success:(DownloadSuccessBlock)success
                         failure:(DownloadFailureBlock)failure{
    
    _dowloadSuccess = success;
    _downloadFailure = failure;
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudUserClass];
    [query whereKey:kHLUserModelKeyUserId equalTo:user.objectId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            
            _downloadFailure(error);
            
        }
        else{
            
            NSString *chattingID = [object objectForKey:kHLUserModelKeyUserIdMD5];
            _dowloadSuccess(chattingID);
            
        }
    }];
    
}

-(void)fetchUserWithUserId:(NSString *)objectId
                    success:(DownloadSuccessBlock)success
                    failure:(DownloadFailureBlock)failure{
    
    _dowloadSuccess = success;
    _downloadFailure = failure;
    
    
        PFQuery * query = [PFUser query];
        [query whereKey:@"objectId" equalTo:objectId];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            
            if (!object) {
                
                _downloadFailure(error);
                
            }
            else{
                
                _dowloadSuccess((PFUser *)object);
                
            }
            
        }];

    
}


//-(void)getUserPortraitImageWithUserID:(NSString *)userID withCell:(ChatListCell *)cell block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
//    
//    PFQuery * query = [PFUser query];
//    [query whereKey:@"objectId" equalTo:@"0soFWxXf8K"];
//    NSArray * results = [query findObjects];
//
//    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        if (!object) {
//            
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//           cell.imageView.image = [UIImage imageNamed:@"chat_default_portrait@2x.png"];
//            cell.name = @"Unknown user";
//
//        
//        
//        }
//        else{
//            
//                        PFFile *theImage = [object objectForKey:kHLUserModelKeyPortraitImage];
//                       // NSData *imageData = [theImage getData];
//            [theImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                if (!error) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                    cell.placeholderImage = [UIImage imageWithData:data];
//                        
//                      //  [cell reloadInputViews];
//                        
//                        
//                    });
//                    // image can now be set on a UIImageView
//                }
//            }];
//
//                        cell.name = [object objectForKey:kHLUserModelKeyUserName];
//            
//        }
//    }];
//
//    
////    PFQuery *query = [PFQuery queryWithClassName:kHLCloudUserClass];
////    [query whereKey:kHLUserModelKeyUserId equalTo:[[PFUser currentUser]objectId]];
////    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
////        if (!object) {
////            
////            NSLog(@"Error: %@ %@", error, [error userInfo]);
////            cell.imageView.image = [UIImage imageNamed:@"chat_default_portrait@2x.png"];
////            
////        }
////        else{
////            
////            PFFile *theImage = [object objectForKey:kHLUserModelKeyPortraitImage];
////            NSData *imageData = [theImage getData];
////            cell.imageView.image = [UIImage imageWithData:imageData];
////            cell.name = [object objectForKey:kHLUserModelKeyUserName];
////            
////        }
////    }];
//    
//
//}
//

@end
