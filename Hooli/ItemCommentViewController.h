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

- (id)initWithOffer:(OfferModel*)aOffer;

-(NSInteger )getViewHeight;

@end
