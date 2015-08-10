//
//  AdminManager.h
//  Hooli
//
//  Created by Er Li on 8/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface AdminManager : NSObject
+(AdminManager *)sharedInstance;

+(void)addToBlackList:(PFUser *)user;
-(void)checkIfOnBlackList:(PFUser *)user withBlock:(void (^)(BOOL flag, NSError *error))completionBlock;
@end
