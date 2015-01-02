
//
//  ChattingManager.m
//  Hooli
//
//  Created by Er Li on 12/10/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ChattingManager.h"
#import "NSString+MD5.h"

@implementation ChattingManager


+(ChattingManager *)sharedInstance{
    
    static ChattingManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ChattingManager alloc] init];
        
    });
    return _sharedInstance;
    
}

-(void)loginChattingSDK:(PFUser *)currentUser block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    if (completionBlock) {
        completionBlock(YES,nil);
    }
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[currentUser.email MD5]
                                                        password:[currentUser.email MD5]
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         if (loginInfo && !error) {
             NSLog(@"登录成功");
             
             if (completionBlock) {
                 completionBlock(YES,nil);
             }
             
         }else {
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     NSLog(@"连接服务器失败!");
                     break;
                 case EMErrorServerAuthenticationFailure:
                     NSLog(@"用户名或密码错误");
                     break;
                 case EMErrorServerTimeout:
                     NSLog(@"连接服务器超时!");
                     break;
                 default:
                     NSLog(@"登录失败");
                     break;
             }
             
             if (completionBlock) {
                 completionBlock(NO,nil);
             }
         }
     } onQueue:nil];
    
 }


-(void)signUpChattingSDK:(PFUser *)currentUser block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    if (completionBlock) {
        completionBlock(YES,nil);
    }
    
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:[currentUser.email MD5]
                                                         password:[currentUser.email MD5]
                                                   withCompletion:
     ^(NSString *username, NSString *password, EMError *error) {
         
         if (!error) {
             NSLog(@"注册成功,请登录");
             
             if (completionBlock) {
                 completionBlock(YES,nil);
             }
             
         }else{
             
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     NSLog(@"连接服务器失败!");
                     if (completionBlock) {
                         completionBlock(NO,nil);
                     }
                     break;
                 case EMErrorServerDuplicatedAccount:
                     NSLog(@"您注册的用户已存在!");
                     
                     if (completionBlock) {
                         
                         completionBlock(YES,nil);
                     }
                     break;
                 case EMErrorServerTimeout:
                     NSLog(@"连接服务器超时!");
                     if (completionBlock) {
                         completionBlock(NO,nil);
                     }
                     break;
                 default:
                     NSLog(@"注册失败");
                     if (completionBlock) {
                         completionBlock(NO,nil);
                     }
                     break;
             }
             
 
             
         }
     } onQueue:nil];
    
    
    
}

@end
