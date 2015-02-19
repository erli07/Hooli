//
//  AccountManager.h
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "HLConstant.h"
#import "ChattingManager.h"
#import "ProfileImageView.h"
//#import "ChatListCell.h"
typedef void (^UploadSuccessBlock) ();
typedef void (^UploadFailureBlock) (id error);

typedef void (^DownloadSuccessBlock) (id object);
typedef void (^DownloadFailureBlock) (id error);

@interface AccountManager : NSObject

+(AccountManager *)sharedInstance;
@property (nonatomic, strong) UploadFailureBlock uploadFailure;
@property (nonatomic, strong) UploadSuccessBlock uploadSuccess;
@property (nonatomic, strong) DownloadSuccessBlock downloadSuccess;
@property (nonatomic, strong) DownloadFailureBlock downloadFailure;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *chattingId;
@property (nonatomic, assign) BOOL *flag;

-(NSString *)getUserName;
-(NSString *)getEmail;
-(NSString *)getGender;

-(void)submitUserInfoFromSignup:(UserModel *)userModel block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
- (void)setUserProfilePicture:(ProfileImageView *)profileImageView withUserId:(NSString *)userId;
- (void)setUserFacebookProfilePicture:(UIImageView *)profileImageView;
- (void)setUserProfilePicture:(UIImageView *)profileImageView;
- (void)loadFaceBookAccountDataWithSuccess:(DownloadSuccessBlock)success
                                   Failure:(DownloadFailureBlock)failure;

-(void)saveFacebookAccountDataWithPFUser:(PFUser *)user
                             WithSuccess:(UploadSuccessBlock)success
                                 Failure:(UploadFailureBlock)failure;

- (void)loadAccountDataWithSuccess:(DownloadSuccessBlock)success
                           Failure:(DownloadFailureBlock)failure;
- (void)loadAccountDataWithUserId:(NSString *)userId
                          Success:(DownloadSuccessBlock)success
                          Failure:(DownloadFailureBlock)failure;
-(UIImage *)getPortraitImage;

-(void)submitUserProfileWithUser:(UserModel *)userModel
                         Success:(UploadSuccessBlock)success
                         Failure:(UploadFailureBlock)failure;
-(void)updateUserProfileWithUser:(UserModel *)userModel
                         Success:(UploadSuccessBlock)success
                         Failure:(UploadFailureBlock)failure;

-(void)checkIfUserExistedWithUser:(UserModel *)userModel
                            block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

//-(void)getUserPortraitImageWithUserID:(NSString *)userID withCell:(ChatListCell *)cell
//                                block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)fetchChattingIdWithPFUser:(PFUser *)user
                         success:(DownloadSuccessBlock)success
                         failure:(DownloadFailureBlock)failure;

-(void)fetchUserWithUserId:(NSString *)objectId
                   success:(DownloadSuccessBlock)success
                   failure:(DownloadFailureBlock)failure;

-(void)logOut;
@end
