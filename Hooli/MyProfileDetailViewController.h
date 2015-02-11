//
//  MyProfileDetailViewController.h
//  Hooli
//
//  Created by Er Li on 2/9/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface MyProfileDetailViewController : UITableViewController<UIActionSheetDelegate>
@property (nonatomic) NSString* userId;
@property (nonatomic) PFUser *user;
@end
