//
//  NotificationTableViewCell.m
//  Hooli
//
//  Created by Er Li on 1/19/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "ProfileImageView.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface NotificationTableViewCell()

@property (nonatomic, strong) UIButton *profileImageButton;
@property (nonatomic) BOOL hasActivityImage;
@property (nonatomic, strong) ProfileImageView *profileImageView;

- (void)setActivityImageFile:(PFFile *)image;
- (void)didTapActivityButton:(id)sender;
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;
@end

@implementation NotificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        horizontalTextSpace = [NotificationTableViewCell horizontalTextSpaceForInsetWidth:0];
        
        if (!timeFormatter) {
            timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
        }
        
        // Create subviews and set cell properties
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.hasActivityImage = NO; //No until one is set
        
        self.profileImageView = [[ProfileImageView alloc] init];
        [self.profileImageView setBackgroundColor:[UIColor clearColor]];
        [self.profileImageView setOpaque:YES];
        [self.mainView addSubview:self.profileImageView];
        
        self.profileImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.profileImageButton setBackgroundColor:[UIColor clearColor]];
        [self.profileImageButton addTarget:self action:@selector(didTapActivityButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:self.profileImageButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
