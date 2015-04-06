//
//  HLSettings.m
//  Hooli
//
//  Created by Er Li on 11/4/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLSettings.h"

@implementation HLSettings
@synthesize category,isPostingOffer,preferredDistance,isRefreshNeeded,showSoldItems,currentPageIndex;

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

- (BOOL)getPushFlag{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"PUSH_ENABLE"];
}

- (void)savePushFlag:(BOOL)pushFlag
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:pushFlag forKey:@"PUSH_ENABLE"];
    [ud synchronize];
    
}
- (NSArray *)getTitlesArray{
    
    return @[@"Discover", @"Messages",@"Notifications",@"Profile"];
    
}

+(NSString *)releaseNumber{
    
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [dictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
    
}

+(NSString *)buildNumber{
    
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [dictionary objectForKey:@"CFBundleVersion"];
    return build;
}

@end
