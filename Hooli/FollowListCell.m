//
//  FollowListCell.m
//  Hooli
//
//  Created by Er Li on 2/3/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "FollowListCell.h"
#import "ProfileImageView.h"
#import "HLConstant.h"
#import "HLTheme.h"
@interface FollowListCell ()
/*! The cell's views. These shouldn't be modified but need to be exposed for the subclass */
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UIButton *avatarImageButton;
@property (nonatomic, strong) ProfileImageView *avatarImageView;

@end

@implementation FollowListCell
@synthesize delegate;
@synthesize user;
@synthesize avatarImageView;
@synthesize avatarImageButton;
@synthesize nameButton;
@synthesize subTitle;
@synthesize followButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.avatarImageView = [[ProfileImageView alloc] init];
        self.avatarImageView.frame = CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f);
        self.avatarImageView.layer.cornerRadius = 23.0f;
        self.avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.avatarImageView];
        
        self.avatarImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarImageButton.backgroundColor = [UIColor clearColor];
        self.avatarImageButton.frame = CGRectMake( 10.0f, 14.0f, 40.0f, 40.0f);
        [self.avatarImageButton addTarget:self action:@selector(didTapUserButtonAction:)
                         forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarImageButton];
        
        self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nameButton.backgroundColor = [UIColor clearColor];
        self.nameButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.nameButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.nameButton setTitleColor:[UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f]
                              forState:UIControlStateNormal];
        [self.nameButton setTitleColor:[UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f]
                              forState:UIControlStateHighlighted];
        [self.nameButton addTarget:self action:@selector(didTapUserButtonAction:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.nameButton];
        
        self.subTitle = [[UILabel alloc] init];
        self.subTitle.font = [UIFont systemFontOfSize:11.0f];
        self.subTitle.textColor = [UIColor grayColor];
        self.subTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.subTitle];
        
        self.followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.followButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.followButton.titleEdgeInsets = UIEdgeInsetsMake( 0.0f, 10.0f, 0.0f, 0.0f);
        [self.followButton setBackgroundColor:[UIColor redColor]];
        [self.followButton setTintColor:[UIColor whiteColor]];
//        [self.followButton setBackgroundImage:[UIImage imageNamed:@"ButtonFollow.png"]
//                                     forState:UIControlStateNormal];
//        [self.followButton setBackgroundImage:[UIImage imageNamed:@"ButtonFollowing.png"]
//                                     forState:UIControlStateSelected];
//        [self.followButton setImage:[UIImage imageNamed:@"IconTick.png"]
//                           forState:UIControlStateSelected];
//        [self.followButton setTitle:NSLocalizedString(@"Follow  ", @"Follow string, with spaces added for centering")
//                           forState:UIControlStateNormal];
//        [self.followButton setTitle:@"Following"
//                           forState:UIControlStateSelected];
//        [self.followButton setTitleColor:[UIColor colorWithRed:254.0f/255.0f green:149.0f/255.0f blue:50.0f/255.0f alpha:1.0f]
//                                forState:UIControlStateNormal];
//        [self.followButton setTitleColor:[UIColor whiteColor]
//                                forState:UIControlStateSelected];
        [self.followButton addTarget:self action:@selector(didTapFollowButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.followButton];
    }
    return self;
}
#pragma mark - PAPFindFriendsCell

- (void)setUser:(PFUser *)aUser {
    user = aUser;
    
    
    [self.avatarImageView setFile:[self.user objectForKey:kHLUserModelKeyPortraitImage]];

    // Configure the cell
//    if ([PAPUtility userHasProfilePictures:self.user]) {
//        [self.avatarImageView setFile:[self.user objectForKey:kPAPUserProfilePicSmallKey]];
//    } else {
//        [self.avatarImageView setImage:[PAPUtility defaultProfilePicture]];
//    }
    
    // Set name
    NSString *nameString = [self.user objectForKey:kHLUserModelKeyUserName];
    CGSize nameSize = [nameString boundingRectWithSize:CGSizeMake(144.0f, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0f]}
                                               context:nil].size;
    [self.nameButton setTitle:[self.user objectForKey:kHLUserModelKeyUserName] forState:UIControlStateNormal];
    [self.nameButton setTitle:[self.user objectForKey:kHLUserModelKeyUserName] forState:UIControlStateHighlighted];
    
    [nameButton setFrame:CGRectMake( 60.0f, 17.0f, nameSize.width, nameSize.height)];
    
    // Set photo number label
    CGSize photoLabelSize = [@"photos" boundingRectWithSize:CGSizeMake(144.0f, CGFLOAT_MAX)
                                                    options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}
                                                    context:nil].size;
    [subTitle setFrame:CGRectMake( 60.0f, 17.0f + nameSize.height, 140.0f, photoLabelSize.height)];
    
    // Set follow button
    [followButton setFrame:CGRectMake( 208.0f, 20.0f, 103.0f, 32.0f)];
}

#pragma mark - ()

+ (CGFloat)heightForCell {
    return 67.0f;
}

/* Inform delegate that a user image or name was tapped */
- (void)didTapUserButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapUserButton:)]) {
        [self.delegate cell:self didTapUserButton:self.user];
    }
}

/* Inform delegate that the follow button was tapped */
- (void)didTapFollowButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapFollowButton:)]) {
        [self.delegate cell:self didTapFollowButton:self.user];
    }
}

@end
