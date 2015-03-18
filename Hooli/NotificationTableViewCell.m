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
#import "NotificationFeedViewController.h"
#import "HLConstant.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface NotificationTableViewCell()

@property (nonatomic, strong) UIButton *profileImageButton;
@property (nonatomic) BOOL hasActivityImage;
@property (nonatomic) NSString *activityType;

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
        
        
        self.activityImageView = [[ProfileImageView alloc] init];
        [self.activityImageView setBackgroundColor:[UIColor clearColor]];
        [self.activityImageView setOpaque:YES];
        self.activityImageView.layer.cornerRadius = avatarDim/2;
        self.activityImageView.layer.masksToBounds = YES;
        [self.mainView addSubview:self.activityImageView];
        
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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.activityImageView setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 46.0f, avatarY, avatarDim, avatarDim)];
    
    // Add activity image if one was set
    if (self.hasActivityImage) {
        [self.activityImageView setHidden:NO];
    } else {
        [self.activityImageView setHidden:YES];
    }
    
    //    // Change frame of the content text so it doesn't go through the right-hand side picture
    //    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 72.0f - 46.0f, CGFLOAT_MAX)
    //                                                              options:NSStringDrawingUsesLineFragmentOrigin // wordwrap?
    //                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
    //                                                              context:nil].size;
    //    [self.contentLabel setFrame:CGRectMake( 46.0f, 15.0f, contentSize.width, contentSize.height)];
    //
    //    // Layout the timestamp label given new vertical
    //    CGSize timeSize = [self.timeLabel.text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 72.0f - 46.0f, CGFLOAT_MAX)
    //                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
    //                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}
    //                                                        context:nil].size;
    //    [self.timeLabel setFrame:CGRectMake( 46.0f, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 7.0f, timeSize.width, timeSize.height)];
}

- (void)setIsNew:(BOOL)isNew {
    if (isNew) {
        [self.mainView setBackgroundColor:[UIColor whiteColor]];
    }
}


-(void)setNotification:(PFObject *)notification{
    
    if ([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:kHLNotificationTypeFollow] || [[notification objectForKey:kHLNotificationTypeKey] isEqualToString:kHLNotificationTypeJoined]) {
        [self setActivityImageFile:nil];
    } else if([notification objectForKey:kHLNotificationOfferKey]) {
        
        PFFile *activityImageFile = (PFFile*)[[notification objectForKey:kHLNotificationOfferKey] objectForKey:kHLOfferModelKeyThumbNail];
        
        [self setActivityImageFile:activityImageFile];
        
    }else if([notification objectForKey:kHLNotificationEventKey]) {
        
        PFFile *activityImageFile = (PFFile*)[[notification objectForKey:kHLNotificationEventKey] objectForKey:kHLEventKeyThumbnail];
        
        [self setActivityImageFile:activityImageFile];
        
    }
    else{
        
    }
    
    
    NSString *activityString = [NotificationFeedViewController stringForNotificationType:(NSString*)[notification objectForKey:kHLNotificationTypeKey]];
    
    if([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:khlNotificationTypMakeOffer]){
        
        activityString  = [NSString stringWithFormat:@"%@ %@", activityString,[notification objectForKey:kHLNotificationContentKey]];
        
    }
    else if ([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:khlNotificationTypAcceptOffer]){
        
        activityString  = [NSString stringWithFormat:@"%@ %@", activityString,[notification objectForKey:kHLNotificationContentKey]];
        
    }
    else if ([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:khlNotificationTypeOfferSold]){
        
        
        activityString  = [NSString stringWithFormat:@"%@", activityString];
        
    }
    else if ([[notification objectForKey:kHLNotificationTypeKey]isEqualToString:kHLNotificationTypeJoinEvent]){
        
        activityString  = [NSString stringWithFormat:@"%@", activityString];

        
    }
    
    self.user = [notification objectForKey:kHLNotificationFromUserKey];
    
    if (self.contentLabel.text) {
        [self setContentText:self.contentLabel.text];
    }
    
    if (self.user) {
        CGSize nameSize = [self.nameButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                                        context:nil].size;
        NSString *paddedString = [BaseTextCell padString:activityString withFont:[UIFont systemFontOfSize:13.0f] toWidth:nameSize.width];
        [self.contentLabel setText:paddedString];
    } else { // Otherwise we ignore the padding and we'll add it after we set the user
        [self.contentLabel setText:activityString];
    }
    
    [self.timeLabel setText:[timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[notification createdAt]]];
    
    [self setNeedsDisplay];
    
}

- (void)setActivityImageFile:(PFFile *)imageFile {
    
    if (imageFile) {
        [self.activityImageView setFile:imageFile];
        [self setHasActivityImage:YES];
    } else {
        [self setHasActivityImage:NO];
    }
    
}

@end
