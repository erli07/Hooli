//
//  HLSettings.h
//  Hooli
//
//  Created by Er Li on 11/4/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface HLSettings : NSObject
+(HLSettings *)sharedInstance;
@property (nonatomic, strong) NSArray *category;
@property (nonatomic, assign) BOOL isPostingOffer;
@property (nonatomic, assign) float preferredDistance;
@property (nonatomic, assign) BOOL isRefreshNeeded;
@property (nonatomic, assign) BOOL showSoldItems;
@property (nonatomic, assign) NSInteger currentPageIndex;

+(NSString *)releaseNumber;
+(NSString *)buildNumber;

- (BOOL)getPushFlag;
- (void)savePushFlag:(BOOL)pushFlag;

- (PFUser *)getCurrentUser ;
- (void)saveCurrentUser:(PFUser *)currentUser;

- (NSArray *)getTitlesArray;
@end
