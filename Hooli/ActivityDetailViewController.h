//
//  ActivityDetailViewController.h
//  Hooli
//
//  Created by Er Li on 1/7/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ActivityMemberViewController.h"
@interface ActivityDetailViewController : UIViewController<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate,HLActivitySelectMemberDelegate>
@property (nonatomic) PFObject *activityDetail;
@property (nonatomic) UITableView *activityDetailTableView;
@property (nonatomic) ActivityMemberViewController *memberTableView;


@end
