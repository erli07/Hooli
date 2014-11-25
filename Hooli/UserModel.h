//
//  UserModel.h
//  Hooli
//
//  Created by Er Li on 11/9/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface UserModel : NSObject

extern NSString *const kHLUserModelKeyEmail;
extern NSString *const kHLUserModelKeyUserName;
extern NSString *const kHLUserModelKeyPortraitImage;
extern NSString *const kHLUserModelKeyUserId;
extern NSString *const kHLUserModelKeyPassword;


@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage *portraitImage;
@property (nonatomic, strong) NSString *userID;

-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
              password:(NSString *)_password
         portraitImage:(UIImage *)_portraitImage;

-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
              password:(NSString *)_password
         portraitImage:(UIImage *)_portraitImage
                userID:(NSString *)_userID;
-(id)initUserWithPFObject:(PFObject *)object;
@end
