//
//  NotificationsViewController.h
//  Hooli
//
//  Created by Er Li on 1/19/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import "HLConstant.h"
#import "NotificationTableViewCell.h"
@interface NotificationsViewController : PFQueryTableViewController<NotificationCellDelegate>

+ (NSString *)stringForNotificationType:(NSString *)notificationType;


@end
