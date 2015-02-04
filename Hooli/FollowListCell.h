//
//  FollowListCell.h
//  Hooli
//
//  Created by Er Li on 2/3/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class ProfileImageView;
@protocol FollowListCellDelegate;

@interface FollowListCell : UITableViewCell{
    id _delegate;
}

@property (nonatomic) id<FollowListCellDelegate> delegate;

@property(nonatomic) PFUser *user;
@property(nonatomic) UILabel *subTitle;
@property(nonatomic) UIButton *followButton;

/*! Setters for the cell's content */
- (void)setUser:(PFUser *)user;

- (void)didTapUserButtonAction:(id)sender;
- (void)didTapFollowButtonAction:(id)sender;

/*! Static Helper methods */
+ (CGFloat)heightForCell;


@end


@protocol FollowListCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(FollowListCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(FollowListCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end