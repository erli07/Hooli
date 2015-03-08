//
//  ActivityDetailCell.h
//  Hooli
//
//  Created by Er Li on 3/6/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activityImageView;

@property (weak, nonatomic) IBOutlet UIView *backgroundShadowView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitle;
@property (weak, nonatomic) IBOutlet UILabel *activityContent;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
