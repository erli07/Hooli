//
//  CreateItemViewController.h
//  Hooli
//
//  Created by Er Li on 3/28/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface CreateItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *itemTitleField;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *itemContetnTextView;
@property (weak, nonatomic) IBOutlet UITextField *itemPriceField;
@property (weak, nonatomic) IBOutlet UITextField *itemConditionField;
@property (weak, nonatomic) IBOutlet UITextField *itemCategoryField;
@property (weak, nonatomic) IBOutlet UITextField *itemPickupField;

- (IBAction)submitItem:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *imageButton1;
@property (weak, nonatomic) IBOutlet UIButton *imageButton2;
@property (weak, nonatomic) IBOutlet UIButton *imageButton3;
@property (weak, nonatomic) IBOutlet UIButton *imageButton4;

- (IBAction)imageButton1Pressed:(id)sender;
- (IBAction)imageButton2Pressed:(id)sender;
- (IBAction)imageButton3Pressed:(id)sender;
- (IBAction)imageButton4Pressed:(id)sender;

@end
