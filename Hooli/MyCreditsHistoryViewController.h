//
//  MyCreditsHistoryViewController.h
//  Hooli
//
//  Created by Er Li on 2/19/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import "CreditHistoryCell.h"
@interface MyCreditsHistoryViewController : PFQueryTableViewController

+ (NSString *)stringForNotificationType:(NSString *)notificationType;

@property (nonatomic) PFObject *notification;

@end
