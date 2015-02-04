//
//  FollowListViewController.h
//  Hooli
//
//  Created by Er Li on 2/3/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import "FollowListCell.h"
#import "ActivityManager.h"
@interface FollowListViewController : PFQueryTableViewController<FollowListCellDelegate>
@property (nonatomic, assign) RelationshipType followStatus;
@property (nonatomic) PFUser *fromUser;

@end
