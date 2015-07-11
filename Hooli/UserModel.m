//
//  UserModel.m
//  Hooli
//
//  Created by Er Li on 11/9/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "UserModel.h"
#import "NSString+MD5.h"

@implementation UserModel
@synthesize email,username,portraitImage,userID,password,chattingId,gender,phoneNumber,wechat,hobby,signature,work,age;





-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
              password:(NSString *)_password
         portraitImage:(UIImage *)_portraitImage
                gender:(NSString *)_gender{
    
    
    self = [super init];
    if(self)
    {
        self.email = _email;
        self.username = _username;
        self.password = _password;
        self.portraitImage = _portraitImage;
        self.chattingId = [_email MD5];
        self.gender = _gender;
        
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
        self.chattingId = [_email MD5];
    }
    return self;
    
}


-(id)initUserWithEmail:(NSString *)_email
              userName:(NSString *)_username
         portraitImage:(UIImage *)_portraitImage
                gender:(NSString *)_gender
           phoneNumber:(NSString *)_phoneNumber
                wechat:(NSString *)_wechat{
    self = [super init];
    if(self)
    {
        self.email = _email;
        self.username = _username;
        self.portraitImage = _portraitImage;
        self.wechat = _wechat;
        self.gender = _gender;
        self.phoneNumber = _phoneNumber;
    }
    return self;
    
}

-(id)initUserWithUserName:(NSString *)_username
                      age:(NSString *)_age
            portraitImage:(UIImage *)_portraitImage
                   gender:(NSString *)_gender
                     work:(NSString *)_work
                    hobby:(NSString *)_hobby
                signature:(NSString *)_signature{
    
    self = [super init];
    if(self)
    {
        self.age = _age;
        self.username = _username;
        self.portraitImage = _portraitImage;
        self.hobby = _hobby;
        self.gender = _gender;
        self.signature = _signature;
        self.work = _work;
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
        self.chattingId = [object objectForKey:kHLUserModelKeyUserIdMD5];
        
    }
    return self;
    
    
}


@end

//-----User Manager----//
static UserManager *pUserManagerInst = nil;

@implementation UserManager
@synthesize mainUser;

+(UserManager*)shareMainUser
{
    @synchronized(self)
    {
        if(pUserManagerInst == nil)
        {
            pUserManagerInst = [[UserManager alloc] init];
            pUserManagerInst.mainUser = nil;
        }
    }
    return pUserManagerInst;
}

@end
