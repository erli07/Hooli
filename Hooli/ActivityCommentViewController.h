//
//  ActivityCommentViewController.h
//  Hooli
//
//  Created by Er Li on 3/3/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>
#import "BaseTextCell.h"
#import <ParseUI/ParseUI.h>

@interface ActivityCommentViewController : PFQueryTableViewController<UITextFieldDelegate, UIActionSheetDelegate, BaseTextCellDelegate>

@property (nonatomic, strong) UITextField *commentTextField;

@property (nonatomic, strong) PFObject *aObject;

- (id)initWithObject:(PFObject *)_object;

@end
