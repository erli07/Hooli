//
//  CreateActivityViewController.h
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//
#import "PostFormViewController.h"
#import <UIKit/UIKit.h>
typedef enum{
    
    HL_EVENT_DETAIL_NAME = 1,
    HL_EVENT_DETAIL_DESCRIPTION,
    HL_EVENT_DETAIL_LOCATION,
    HL_EVENT_DETAIL_DATE

    
} EventDetailType;

@interface CreateActivityViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet UITextView *eventContent;
@property (weak, nonatomic) IBOutlet UITextField *eventDateField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationField;
@property (weak, nonatomic) IBOutlet UITextField *eventMemberNumberField;
@property (weak, nonatomic) IBOutlet UITextField *eventCategoryFiled;
@property (weak, nonatomic) IBOutlet UITextView *eventAnnouncementField;

- (IBAction)submitActivity:(id)sender;
- (IBAction)inviteFriends:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
