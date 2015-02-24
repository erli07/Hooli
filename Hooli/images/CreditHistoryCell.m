//
//  CreditHistoryCell.m
//  Hooli
//
//  Created by Er Li on 2/20/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "CreditHistoryCell.h"
#import "TTTTimeIntervalFormatter.h"
#import "ProfileImageView.h"
#import "NotificationFeedViewController.h"
#import "HLConstant.h"
#import "HLTheme.h"

static TTTTimeIntervalFormatter *timeFormatter;

@interface CreditHistoryCell()

@property (nonatomic, strong) UIButton *profileImageButton;
@property (nonatomic) BOOL hasActivityImage;
@property (nonatomic, strong) ProfileImageView *activityImageView;
@property (nonatomic) NSString *activityType;

- (void)setActivityImageFile:(PFFile *)image;
- (void)didTapActivityButton:(id)sender;
+ (CGFloat)horizontalTextSpaceForInsetWidth:(CGFloat)insetWidth;

@end

@implementation CreditHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        horizontalTextSpace = [CreditHistoryCell horizontalTextSpaceForInsetWidth:0];
        
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
        
        self.nameButton= nil;
        
        self.profileImageButton = nil;
        
        self.avatarImageButton = nil;
        
        self.avatarImageView = nil;
        
       
//        self.profileImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.profileImageButton setBackgroundColor:[UIColor clearColor]];
//        [self.profileImageButton addTarget:self action:@selector(didTapActivityButton:) forControlEvents:UIControlEventTouchUpInside];
//        [self.mainView addSubview:self.profileImageButton];
    }
    return self;
}


- (void)setIsNew:(BOOL)isNew {
    if (isNew) {
        [self.mainView setBackgroundColor:[UIColor whiteColor]];
    }
}


-(void)setNotification:(PFObject *)notification{
    
    if ([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:kHLNotificationTypeFollow] || [[notification objectForKey:kHLNotificationTypeKey] isEqualToString:kHLNotificationTypeJoined]) {
        [self setActivityImageFile:nil];
    } else {
        
        PFFile *activityImageFile = (PFFile*)[[notification objectForKey:kHLNotificationOfferKey] objectForKey:kHLOfferModelKeyThumbNail];
        
        [self setActivityImageFile:activityImageFile];
    }
    
    
    NSString *activityString;
    
    if([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:khlNotificationTypMakeOffer]){
        
        activityString  = [NSString stringWithFormat:@"You spent %@ for item", [notification objectForKey:kHLNotificationContentKey]];

    }
    else if ([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:khlNotificationTypAcceptOffer]){
        
        activityString  = [NSString stringWithFormat:@"You earned %@ for item", [notification objectForKey:kHLNotificationContentKey]];
        self.contentLabel.textColor= [HLTheme mainColor];
        //self.contentLabel.textColor= [UIColor redColor];

    }

    
    self.user = [notification objectForKey:kHLNotificationFromUserKey];
    
    if (self.contentLabel.text) {
        [self setContentText:self.contentLabel.text];
    }
    
    [self.contentLabel setText:activityString];
    
   
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

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // Layout the content
    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX)
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}
                                                              context:nil].size;
    [self.contentLabel setFrame:CGRectMake(30, vertTextBorderSpacing + 5.0f, contentSize.width, contentSize.height)];
    
    // Layout the timestamp label
    CGSize timeSize = [self.timeLabel.text boundingRectWithSize:CGSizeMake(horizontalTextSpace, CGFLOAT_MAX)
                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}
                                                        context:nil].size;
    [self.timeLabel setFrame:CGRectMake(30, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + vertElemSpacing, timeSize.width, timeSize.height)];
    
    [self.activityImageView setFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 86.0f, avatarY, avatarDim, avatarDim)];
    
    // Add activity image if one was set
    if (self.hasActivityImage) {
        [self.activityImageView setHidden:NO];
    } else {
        [self.activityImageView setHidden:YES];
    }
    
    
}

@end
