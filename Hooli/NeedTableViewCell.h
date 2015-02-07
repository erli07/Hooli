//
//  NeedTableViewCell.h
//  Hooli
//
//  Created by Er Li on 12/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextCell.h"
#import <Parse/Parse.h>
@interface NeedTableViewCell :BaseTextCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *budgetLabel;
@property (weak, nonatomic) IBOutlet UILabel *GroupSizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *interestedImageView;
@property (weak, nonatomic) IBOutlet UILabel *interestedNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) NSString *needId;
-(void)setNeedContentText:(NSString *)contentText;
@end
