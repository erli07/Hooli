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

@interface ItemCommentViewController : PFQueryTableViewController<UITextFieldDelegate, UIActionSheetDelegate, BaseTextCellDelegate>
@property (nonatomic, strong) PFObject *offer;

- (id)initWithOffer:(PFObject*)aOffer;

@end
