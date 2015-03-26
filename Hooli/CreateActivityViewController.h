//
//  CreateActivityViewController.h
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//
#import "PostFormViewController.h"
#import <UIKit/UIKit.h>
#import "ActivityLocationViewController.h"
#import "ActivityCategoryViewController.h"
#import "GCPlaceholderTextView.h"
typedef enum{
    
    HL_EVENT_DETAIL_NAME = 1,
    HL_EVENT_DETAIL_DESCRIPTION,
    HL_EVENT_DETAIL_LOCATION,
    HL_EVENT_DETAIL_DATE

    
} EventDetailType;

@protocol HLCreateActivityDelegate <NSObject>

@optional
//- (void)didSelectEventLocation:(CLLocation *)eventLocation;
- (void)didCreateActivity:(PFObject *)object;

- (void)didUpdateActivity:(PFObject *)object;


@end

@interface CreateActivityViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate,HLActivityLocationDelegate, HLActivityCategoryDelegate>



@property (weak, nonatomic) IBOutlet UITextField *eventTitle;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *eventContent;
@property (weak, nonatomic) IBOutlet UITextField *eventDateField;
@property (weak, nonatomic) IBOutlet UITextField *eventLocationField;
@property (weak, nonatomic) IBOutlet UITextField *eventMemberNumberField;
@property (weak, nonatomic) IBOutlet UITextField *eventCategoryFiled;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *eventAnnouncementField;
@property (weak, nonatomic) IBOutlet UIButton *selectCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *locateInMapButton;
@property (weak, nonatomic) IBOutlet UIButton *showCalenderButton;
@property (weak, nonatomic) IBOutlet UILabel *eventCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;

@property (nonatomic, weak) id<HLCreateActivityDelegate> delegate;

@property (nonatomic) PFObject *eventObject;


- (IBAction)showCalender:(id)sender;

- (IBAction)submitActivity:(id)sender;
- (IBAction)inviteFriends:(id)sender;

- (IBAction)selectCategory:(id)sender;
- (IBAction)locateInMap:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *inviteButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *imageButton1;
@property (weak, nonatomic) IBOutlet UIButton *imageButton2;
@property (weak, nonatomic) IBOutlet UIButton *imageButton3;
@property (weak, nonatomic) IBOutlet UIButton *imageButton4;

@end
