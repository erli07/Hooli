//
//  FormDetailViewController.h
//  Hooli
//
//  Created by Er Li on 1/11/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostFormViewController.h"

@interface FormDetailViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *detailFormFiled;
@property (nonatomic, assign) DetailType detailType;
@property (nonatomic) NSString *itemName;
@property (nonatomic) NSString *itemDescription;
@property (nonatomic) NSString *itemPrice;
@property (nonatomic) NSString *itemCategory;
@property (nonatomic) NSString *itemCondition;
@property (nonatomic) NSString *itemLocation;

@end
