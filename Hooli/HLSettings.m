//
//  HLSettings.m
//  Hooli
//
//  Created by Er Li on 11/4/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLSettings.h"

@implementation HLSettings
@synthesize category,isPostingOffer,preferredDistance,isRefreshNeeded;
+(HLSettings *)sharedInstance{
    
    static HLSettings *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[HLSettings alloc] init];
    });
    return _sharedInstance;
    
}

- (PFUser *)getCurrentUser {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"CURRENT_USER"];
}

- (void)saveCurrentUser:(PFUser *)currentUser
{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:currentUser forKey:@"CURRENT_USER"];
    [ud synchronize];

}

@end
