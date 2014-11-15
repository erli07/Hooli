//
//  UserModel.m
//  Hooli
//
//  Created by Er Li on 11/9/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize email,username,portraitImage,userID,password;

NSString *const kHLUserModelKeyEmail = @"Email";
NSString *const kHLUserModelKeyUserName = @"UserName";
NSString *const kHLUserModelKeyPortraitImage = @"PortraitImage";
NSString *const kHLUserModelKeyUserId = @"UserId";

-(id)initUserWithEmail:(NSString *)_email
                userName:(NSString *)_username
                password:(NSString *)_password
           portraitImage:(UIImage *)_portraitImage{
    
    
    self = [super init];
    if(self)
    {
        self.email = _email;
        self.username = _username;
        self.password = _password;
        self.portraitImage = _portraitImage;
    }
    return self;

}

-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
              password:(NSString *)_password
         portraitImage:(UIImage *)_portraitImage
                userID:(NSString *)_userID{
    
    
    self = [super init];
    if(self)
    {
        self.email = _email;
        self.username = _username;
        self.password = _password;
        self.portraitImage = _portraitImage;
        self.userID = _userID;
    }
    return self;
    
}

-(id)initUserWithPFObject:(PFObject *)object{
    
    
    self = [super init];
    if(self)
    {
        self.email = [object objectForKey:kHLUserModelKeyEmail];
        self.username = [object objectForKey:kHLUserModelKeyUserName];
        PFFile *theImage = [object objectForKey:kHLUserModelKeyPortraitImage];
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];
        self.portraitImage = image;
        self.userID = [object objectForKey:kHLUserModelKeyUserId];
    }
    return self;
    
    
}



@end
