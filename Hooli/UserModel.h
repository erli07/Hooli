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
#import "HLConstant.h"

@interface UserModel : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage *portraitImage;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *chattingId;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *work;
@property (nonatomic, strong) NSString *hobby;
@property (nonatomic, strong) NSString *age;



-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
              password:(NSString *)_password
         portraitImage:(UIImage *)_portraitImage
                gender:(NSString *)_gender;

-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
              password:(NSString *)_password
         portraitImage:(UIImage *)_portraitImage
                userID:(NSString *)_userID;

-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
         portraitImage:(UIImage *)_portraitImage
                gender:(NSString *)_gender
           phoneNumber:(NSString *)_phoneNumber
                wechat:(NSString *)_wechat;

-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
         portraitImage:(UIImage *)_portraitImage
                gender:(NSString *)_gender
                  work:(NSString *)_work
                 hobby:(NSString *)_hobby
             signature:(NSString *)_signature;

-(id)initUserWithUserName:(NSString *)_username
                      age:(NSString *)_age
            portraitImage:(UIImage *)_portraitImage
                   gender:(NSString *)_gender
                     work:(NSString *)_work
                    hobby:(NSString *)_hobby
                signature:(NSString *)_signature;

-(id)initUserWithPFObject:(PFObject *)object;
@end

@interface UserManager : NSObject
@property(strong, atomic) UserModel* mainUser;
+(UserManager*)shareMainUser;
@end
