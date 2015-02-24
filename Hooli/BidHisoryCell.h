//
//  BidHisoryCell.h
//  Hooli
//
//  Created by Er Li on 2/24/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "BaseTextCell.h"
#import "NotificationTableViewCell.h"
@interface BidHisoryCell : NotificationTableViewCell

@property (nonatomic, strong) PFObject *notification;

- (void)setIsNew:(BOOL)isNew;

@end
