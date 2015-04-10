//
//  ItemCommentViewController.h
//  Hooli
//
//  Created by Er Li on 1/19/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import "ItemDetailsHeaderView.h"
#import "BaseTextCell.h"
#import "OfferModel.h"

@interface ItemCommentViewController : PFQueryTableViewController<UITextFieldDelegate, UIActionSheetDelegate, BaseTextCellDelegate>
@property (nonatomic, strong) OfferModel *offer;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic) PFUser *repliedUser;
@property (nonatomic, strong) PFObject *aObject;

- (id)initWithObject:(PFObject *)_object;

- (id)initWithOffer:(OfferModel*)aOffer;


@end
