//
//  ChattingManager.h
//  Hooli
//
//  Created by Er Li on 12/10/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "EaseMob.h"
#import <Parse/Parse.h>
@interface ChattingManager : NSObject

+(ChattingManager *)sharedInstance;
-(void)loginChattingSDK:(PFUser *)currentUser block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
-(void)signUpChattingSDK:(PFUser *)currentUser block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

@end
