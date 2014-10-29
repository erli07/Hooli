//
//  AccountManager.h
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
@interface AccountManager : NSObject
+(AccountManager *)sharedInstance;
@property (nonatomic, strong) UIImage *profileImage;
@property (nonatomic, strong) NSString *userName;
- (NSString *)getUserName;
- (void)setUserProfilePicture:(UIImageView *)profileImageView;
@end
