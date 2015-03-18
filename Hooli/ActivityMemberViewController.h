//
//  ActivityMemberViewController.h
//  Hooli
//
//  Created by Er Li on 3/18/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>

@interface ActivityMemberViewController : PFQueryTableViewController
@property (nonatomic, strong) PFObject *aObject;

- (id)initWithObject:(PFObject *)_object;
@end
