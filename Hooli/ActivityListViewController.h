//
//  ActivityListViewController.h
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>

@interface ActivityListViewController : PFQueryTableViewController

@property (nonatomic, strong) PFObject *aObject;

@end
