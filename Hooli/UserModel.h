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
