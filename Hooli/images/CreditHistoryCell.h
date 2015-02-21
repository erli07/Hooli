//
//  CreditHistoryCell.h
//  Hooli
//
//  Created by Er Li on 2/20/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "NotificationTableViewCell.h"

@interface CreditHistoryCell : BaseTextCell

@property (nonatomic, strong) PFObject *notification;

- (void)setIsNew:(BOOL)isNew;

@end
