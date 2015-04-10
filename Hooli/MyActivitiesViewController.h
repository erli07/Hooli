//
//  MyActivitiesViewController.h
//  Hooli
//
//  Created by Er Li on 3/24/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface MyActivitiesViewController : PFQueryTableViewController

@property (nonatomic, strong) PFUser *aUser;

- (id)initWithUser:(PFUser *)_user;

@end
