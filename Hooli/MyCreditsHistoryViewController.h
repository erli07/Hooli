//
//  MyCreditsHistoryViewController.h
//  Hooli
//
//  Created by Er Li on 2/19/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import "CreditHistoryCell.h"
#import <ParseUI/ParseUI.h>

@interface MyCreditsHistoryViewController : PFQueryTableViewController

+ (NSString *)stringForNotificationType:(NSString *)notificationType;

@property (nonatomic) PFObject *notification;

@end
