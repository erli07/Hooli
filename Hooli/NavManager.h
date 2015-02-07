//
//  NavManager.h
//  Hooli
//
//  Created by Er Li on 2/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface NavManager : NSObject

+(NavManager *)sharedInstance;
-(void)goToUserProfile:(PFUser *)aUser;
@end
