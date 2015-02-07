//
//  NeedTableViewController.h
//  Hooli
//
//  Created by Er Li on 12/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Parse/Parse.h>

@interface NeedTableViewController : PFQueryTableViewController<UIScrollViewDelegate>
@property (nonatomic, strong) NSString *needId;
@property (nonatomic, assign, getter = isFirstLaunch) BOOL firstLaunch;

@end
