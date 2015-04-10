//
//  NotificationFeedViewController.h
//  Hooli
//
//  Created by Er Li on 1/27/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface NotificationFeedViewController : PFQueryTableViewController<UIActionSheetDelegate>

+ (NSString *)stringForNotificationType:(NSString *)notificationType;

@property (nonatomic) PFObject *notification;

@end
