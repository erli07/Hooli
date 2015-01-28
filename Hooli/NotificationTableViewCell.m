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


- (void)setIsNew:(BOOL)isNew {
    if (isNew) {
        [self.mainView setBackgroundColor:[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:1.0f]];
    } else {
        [self.mainView setBackgroundColor:[UIColor clearColor]];
    }
}


-(void)setNotification:(PFObject *)notification{
    
    
    NSLog(@"%@",self.user.username);
    
}

- (void)setActivity:(PFObject *)activity {
    // Set the activity property
//    _activity = activity;
//    if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeFollow] || [[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeJoined]) {
//        [self setActivityImageFile:nil];
//    } else {
//        [self setActivityImageFile:(PFFile*)[[activity objectForKey:kPAPActivityPhotoKey] objectForKey:kPAPPhotoThumbnailKey]];
//    }
//    
//    NSString *activityString = [PAPActivityFeedViewController stringForActivityType:(NSString*)[activity objectForKey:kPAPActivityTypeKey]];
//    self.user = [activity objectForKey:kPAPActivityFromUserKey];
//    
//    // Set name button properties and avatar image
//    if ([PAPUtility userHasProfilePictures:self.user]) {
//        [self.avatarImageView setFile:[self.user objectForKey:kPAPUserProfilePicSmallKey]];
//    } else {
//        [self.avatarImageView setImage:[PAPUtility defaultProfilePicture]];
//    }
//    
//    NSString *nameString = NSLocalizedString(@"Someone", @"Text when the user's name is unknown");
//    if (self.user && [self.user objectForKey:kPAPUserDisplayNameKey] && [[self.user objectForKey:kPAPUserDisplayNameKey] length] > 0) {
//        nameString = [self.user objectForKey:kPAPUserDisplayNameKey];
//    }
//    
//    [self.nameButton setTitle:nameString forState:UIControlStateNormal];
//    [self.nameButton setTitle:nameString forState:UIControlStateHighlighted];
    
    // If user is set after the contentText, we reset the content to include padding
    if (self.contentLabel.text) {
        [self setContentText:self.contentLabel.text];
    }
    
//    if (self.user) {
//        CGSize nameSize = [self.nameButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
//                                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
//                                                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
//                                                                        context:nil].size;
//        NSString *paddedString = [BaseTextCell padString:activityString withFont:[UIFont systemFontOfSize:13.0f] toWidth:nameSize.width];
//        [self.contentLabel setText:paddedString];
//    } else { // Otherwise we ignore the padding and we'll add it after we set the user
//        [self.contentLabel setText:activityString];
//    }
    
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[activity createdAt]]];
    
    [self setNeedsDisplay];
}

@end
