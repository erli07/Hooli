//
//  CreateActivityViewController.m
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "CreateActivityViewController.h"
#import "FormManager.h"
#import "HLTheme.h"
#import "LocationManager.h"
#import "HLConstant.h"
#import "EventManager.h"
#import "camera.h"
#import "HLUtilities.h"
#import "MBProgressHUD.h"
#import "ActivityListViewController.h"
#import "HSDatePickerViewController.h"
#import "HomeViewViewController.h"
#import "ChatConstant.h"
#import "messages.h"
#import "ProgressHUD.h"
#import "GCPlaceholderTextView.h"

@interface CreateActivityViewController ()<UIActionSheetDelegate,UIAlertViewDelegate, HSDatePickerViewControllerDelegate,UIGestureRecognizerDelegate>
//@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic) NSMutableArray *imagesArray;
@property (nonatomic) NSDate *eventDate;
@property (nonatomic) NSString *eventDateText;
@property (nonatomic) CLLocation *eventLocation;
@property (nonatomic) PFGeoPoint *eventGeopoint;
@property (nonatomic) NSString *eventCategory;
@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) GCPlaceholderTextView *descriptionTextView;
@property (nonatomic) GCPlaceholderTextView *annoucementTextView;
@property (nonatomic) UITextField *priceTextField;
@property (nonatomic) UITextField *memberTextField;
@property (nonatomic) UILabel *eventDateLabel;
@property (nonatomic) UILabel *eventLocationLabel;
@property (nonatomic) UILabel *eventCategoryLabel;

@end

@implementation CreateActivityViewController
@synthesize submitButton = _submitButton;
@synthesize inviteButton = _inviteButton;
@synthesize imagesArray = _imagesArray;
@synthesize currentButtonIndex = _currentButtonIndex;
@synthesize eventDate = _eventDate;
@synthesize eventLocation = _eventLocation;
@synthesize eventGeopoint = _eventGeopoint;
@synthesize eventObject = _eventObject;
@synthesize eventCategory = _eventCategory;
@synthesize eventLocationLabel = _eventLocationLabel;
@synthesize imageButton1 = _imageButton1;
@synthesize imageButton2 = _imageButton2;
@synthesize imageButton3 = _imageButton3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"Title",@"Detail",@"Location", @"Date"];
    
    self.title = @"Post Event";
    
    // _eventContent.placeholder = @"简洁介绍你的活动，吸引更多的小伙伴儿，不多于80个字 ";
    _eventContent.placeholder = @"Brief Introduction ";
    
    _eventContent.placeholderColor = [HLTheme textColor];
    
    //_eventAnnouncementField.placeholder = @"附加详细信息，包括注意事项等，可稍后修改 （Optional）";
    _eventAnnouncementField.placeholder = @"More details here（Optional）";
    
    _eventContent.placeholderColor = [HLTheme textColor];
    
    [_inviteButton setBackgroundColor:[HLTheme secondColor]];
    
    [_submitButton setBackgroundColor:[HLTheme secondColor]];
    
    _inviteButton.tintColor = [UIColor whiteColor];
    
    _submitButton.tintColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapEventOccured:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    // [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _imagesArray = [[NSMutableArray alloc]init];
    
    _eventGeopoint = [[PFGeoPoint alloc]init];
    
    
    _imageButton1.hidden = NO;
    _imageButton2.hidden = YES;
    _imageButton3.hidden = YES;
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self configureEventObject:_eventObject];
    
}


-(void)configureEventObject:(PFObject *)eventObject{
    
    if(_eventObject){
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Delete"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(deleteEvent)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
        self.titleTextField.text = [eventObject objectForKey:kHLEventKeyTitle];
        self.descriptionTextView.text = [eventObject objectForKey:kHLEventKeyDescription];
        _eventLocationLabel.text = [eventObject objectForKey:kHLEventKeyEventLocation];
        _eventDateLabel.text = [eventObject objectForKey:kHLEventKeyDateText];
        _eventDate = [eventObject objectForKey:kHLEventKeyDate];
        _eventGeopoint = [eventObject objectForKey:kHLEventKeyEventGeoPoint];
        self.annoucementTextView.text = [eventObject objectForKey:kHLEventKeyAnnoucement];
        self.memberTextField.text = [eventObject objectForKey:kHLEventKeyMemberNumber];
        _eventCategoryLabel.text = [eventObject objectForKey:kHLEventKeyCategory];
        
        PFObject *imagesObject = [eventObject objectForKey:kHLEventKeyImages];
        
        PFFile *imageFile0 =[imagesObject objectForKey:@"imageFile0"];
        PFFile *imageFile1 =[imagesObject objectForKey:@"imageFile1"];
        PFFile *imageFile2 =[imagesObject objectForKey:@"imageFile2"];
        
        if(imageFile0){
            
            [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                [_imagesArray addObject:[UIImage imageWithData:data]];
                
                self.imageButton1.imageView.image = nil;
                
                [self configureImageButtons];
                
                
            }];
        }
        
        if(imageFile1){
            
            [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                [_imagesArray addObject:[UIImage imageWithData:data]];
                
                self.imageButton2.imageView.image = nil;
                
                [self configureImageButtons];
                
                
            }];
        }
        
        if(imageFile2){
            
            [imageFile2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                [_imagesArray addObject:[UIImage imageWithData:data]];
                
                self.imageButton3.imageView.image = nil;
                
                [self configureImageButtons];
                
                
            }];
            
        }
        
        [_submitButton setTitle:@"Update" forState:UIControlStateNormal];
        
        
    }
    
    
}



-(BOOL)checkIfFieldsFilled{
    
    if([self.titleTextField.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@""] || [self.memberTextField.text isEqualToString:@""] || [self.eventDateLabel.text isEqualToString:@""] || [self.eventLocationLabel.text isEqualToString:@""] || [self.eventCategoryLabel.text isEqualToString:@""]){
        
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Field missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    
    if(_imagesArray == nil || [_imagesArray count] == 0){
        
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Image missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
    }
    
    
    NSDate *today = [NSDate date];
    
    if ([_eventDate earlierDate:today] == _eventDate) {
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Date cannot be earlier than today!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    
    return  YES;
    
}

-(void)deleteEvent{
    
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Delete？" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    alert.tag = 2;
    
    [alert show];
    
}

-(void)configureImageButtons{
    
    [self.imageButton1 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.imageButton1 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
    
    [self.imageButton2 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.imageButton2 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
    
    [self.imageButton3 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.imageButton3 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
    
    for (int i = 0; i< [_imagesArray count]; i++) {
        
        switch (i) {
            case 0:
                
                if( [_imagesArray objectAtIndex:0] != nil){
                    
                    [_imageButton1 setBackgroundImage:[_imagesArray objectAtIndex:0] forState:UIControlStateNormal];
                    [_imageButton1 setTitle:@"" forState:UIControlStateNormal];
                    [_imageButton1 setImage:nil forState:UIControlStateNormal];
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = YES;
                    
                    
                }
                else{
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = YES;
                    _imageButton3.hidden = YES;
                    
                }
                
                break;
            case 1:
                if( [_imagesArray objectAtIndex:1] != nil){
                    
                    [_imageButton2 setBackgroundImage:[_imagesArray objectAtIndex:1] forState:UIControlStateNormal];
                    [_imageButton2 setTitle:@"" forState:UIControlStateNormal];
                    [_imageButton2 setImage:nil forState:UIControlStateNormal];
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = NO;
                    
                }
                else{
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = YES;
                    
                }
                break;
            case 2:
                if( [_imagesArray objectAtIndex:1] != nil){
                    
                    [_imageButton3 setBackgroundImage:[_imagesArray objectAtIndex:2] forState:UIControlStateNormal];
                    [_imageButton3 setTitle:@"" forState:UIControlStateNormal];
                    [_imageButton3 setImage:nil forState:UIControlStateNormal];
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = NO;
                }
                else{
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = NO;
                    
                }
                break;
                
                
            default:
                break;
        }
        
        
    }
    
    
}


- (IBAction)submitActivity:(id)sender {
    
    if(![self checkIfFieldsFilled]){
        return;
    }
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure？" delegate:self cancelButtonTitle:@"Wait" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 0;
    
    [alert show];
    
    
}


#pragma mark delegate callbacks

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0) {
        
        if(buttonIndex == 1){
            
            [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
            
            PFObject *eventImages = [PFObject objectWithClassName:kHLCloudEventImagesClass];
            
            for (int i = 0; i <[_imagesArray count]; i++) {
                
                if ([_imagesArray objectAtIndex:i]) {
                    
                    NSData *imageData = [HLUtilities compressImage:[_imagesArray objectAtIndex:i] WithCompression:0.1f];
                    PFFile *imageFile = [PFFile fileWithName:@"ImageFile.jpg" data:imageData];
                    [eventImages setObject:imageFile forKey:[NSString stringWithFormat:@"imageFile%d",i]];
                }
                
            }
            
            [eventImages saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    
                    PFObject *eventObject;
                    
                    if(_eventObject){
                        
                        eventObject = [PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:_eventObject.objectId];
                        
                    }
                    else{
                        
                        eventObject = [[PFObject alloc]initWithClassName:kHLCloudEventClass];
                        
                    }
                    
                    [eventObject setObject:self.titleTextField.text forKey:kHLEventKeyTitle];
                    [eventObject setObject:self.descriptionTextView.text forKey:kHLEventKeyDescription];
                    // [eventObject setObject:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] forKey:kHLEventKeyUserGeoPoint];
                    [eventObject setObject:self.eventLocationLabel.text forKey:kHLEventKeyEventLocation];
                    [eventObject setObject:self.annoucementTextView.text forKey:kHLEventKeyAnnoucement];
                    [eventObject setObject:self.memberTextField.text forKey:kHLEventKeyMemberNumber];
                    [eventObject setObject:self.eventDateLabel.text forKey:kHLEventKeyDateText];
                    [eventObject setObject:self.eventCategoryLabel.text forKey:kHLEventKeyCategory];

                    if(_eventDate){
                        
                        [eventObject setObject:_eventDate forKey:kHLEventKeyDate];
                        
                    }
                    
                    if(_eventGeopoint){
                        
                        [eventObject setObject:_eventGeopoint forKey:kHLEventKeyEventGeoPoint];
                    }
                    
                    [eventObject setObject:[PFUser currentUser] forKey:kHLEventKeyHost];
                    [eventObject setObject:[PFObject objectWithoutDataWithClassName:
                                            kHLCloudEventImagesClass objectId:eventImages.objectId] forKey:kHLEventKeyImages];
                    
                    NSData *imageData = [HLUtilities compressImage:[_imagesArray objectAtIndex:0]WithCompression:0.1f];
                    PFFile *thumbnailFile = [PFFile fileWithName:@"thumbnail.jpg" data:imageData];
                    [eventObject setObject:thumbnailFile forKey:kHLEventKeyThumbnail];
                    
                    [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        if(succeeded){
                            
                            if(!_eventObject){
                                
                                PFObject *eventMember = [PFObject objectWithClassName:kHLCloudEventMemberClass];
                                [eventMember setObject:[PFUser currentUser] forKey:kHLEventMemberKeyMember];
                                [eventMember setObject:[PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:eventObject.objectId] forKey:kHLEventMemberKeyEvent];
                                [eventMember setObject:eventObject.objectId forKey:kHLEventMemberKeyEventId];
                                [eventMember setObject:@"host" forKey:kHLEventMemberKeyMemberRole];
                                
                                PFACL *eventMemberACL = [PFACL ACLWithUser:[PFUser currentUser]];
                                [eventMemberACL setPublicReadAccess:YES];
                                eventMember.ACL = eventMemberACL;
                                
                                [eventMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    
                                    if(succeeded){
                                        
                                        // [self sendWelcomeMessage:eventObject];
                                        
                                        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Post Success！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        
                                        [alert show];
                                        
                                        [self.delegate didCreateActivity:eventObject];
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    }
                                    
                                }];
                                
                            }
                            else{
                                
                                UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Update success!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                
                                [alert show];
                                
                                UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                HomeViewViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                                
                                [self presentViewController:vc animated:YES completion:^{
                                    
                                    [self.delegate didCreateActivity:_eventObject];
                                    
                                }];
                                
                            }
                            
                        }
                        else{
                            
                            UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Post fail..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            
                            [alert show];
                            
                        }
                        
                        [self viewTapEventOccured:nil];
                        
                        [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                        
                        
                    }];
                    
                }
                
            }];
            
        }
        
    }
    else if(alertView.tag == 1){
        
        if(buttonIndex == 1){
            
            if(_currentButtonIndex == 0){
                
                [_imagesArray removeObjectAtIndex:0];
                
                [self.imageButton1 setBackgroundImage:nil forState:UIControlStateNormal];
                
                [self.imageButton1 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
            }
            else if(_currentButtonIndex == 1){
                
                [_imagesArray removeObjectAtIndex:1];
                
                [self.imageButton2 setBackgroundImage:nil forState:UIControlStateNormal];
                
                [self.imageButton2 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
            }
            else{
                
                [_imagesArray removeObjectAtIndex:2];
                
                [self.imageButton3 setBackgroundImage:nil forState:UIControlStateNormal];
                
                [self.imageButton3 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
            }
            
            [self configureImageButtons];
            
        }
    }
    else if(alertView.tag == 2){
        
        if(buttonIndex == 1){
            
            PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:_eventObject.objectId];
            
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    
                    PFObject *imagesObject = [_eventObject objectForKey:kHLEventKeyImages];
                    
                    [imagesObject deleteInBackground];
                    
                    [self deleteRelatedMessages];
                    
                    [self deleteRelatedNotifications];
                    
                    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Delete Success" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    HomeViewViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                    
                    [self presentViewController:vc animated:YES completion:^{
                        
                        [self.delegate didCreateActivity:_eventObject];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHLLoadFeedObjectsNotification object:self];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kHLLoadMessageObjectsNotification object:self];
                        
                    }];
                    
                    
                }
                
            }];
            
        }
    }
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.memberTextField){
        
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [textField setKeyboardAppearance:UIKeyboardAppearanceLight];
        
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"No limit"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(setEventNoLimited)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        
        textField.inputAccessoryView = keyboardDoneButtonView;
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, -200 ,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
        
        
    }
    
    else{
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, -100 ,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
    }
    
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(textView == self.annoucementTextView){
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, - 220,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
    }
    else{
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x,  - 100,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
        
    }
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_postDetailTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

-(void)viewTapEventOccured:(UIGestureRecognizer *)gesture{
    
    [self resetViews];
    
}

-(void)setEventNoLimited{
    
    self.memberTextField.text = @"No Limit";
    
    [self resetViews];
    
}

-(void)sendWelcomeMessage:(PFObject *)eventObject{
    
    CreateMessageItem([PFUser currentUser], eventObject.objectId, [eventObject objectForKey:kHLEventKeyTitle], eventObject);
    
    PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
    object[PF_CHAT_USER] = [PFUser currentUser];
    object[PF_CHAT_GROUPID] = eventObject.objectId;
    object[PF_CHAT_TEXT] = @"Welcome！";
    
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
         }
         else [ProgressHUD showError:@"Network error."];;
     }];
    
    
}


- (IBAction)inviteFriends:(id)sender {
    
    
}

- (IBAction)selectCategory:(id)sender {
    
    [self performSegueWithIdentifier:@"category" sender:self];
    
}


- (void)showCalender {
    
    [self resetViews];
    
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    
    [self presentViewController:hsdpvc animated:YES completion:nil];
    
}

- (IBAction)showMap:(id)sender {
    
    [self resetViews];
    
    [self performSegueWithIdentifier:@"map" sender:self];
    
}

-(void)resetViews{
    
    [UIView animateWithDuration:.5
                     animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, 0,
                                                               self.view.frame.size.width, self.view.frame.size.height); } ];
    
    
    if([_titleTextField isFirstResponder])
        [_titleTextField resignFirstResponder];
    
    if([_memberTextField isFirstResponder])
        [_memberTextField resignFirstResponder];
    
    if([_descriptionTextView isFirstResponder])
        [_descriptionTextView resignFirstResponder];
    
    if([_annoucementTextView isFirstResponder])
        [_annoucementTextView resignFirstResponder];
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"map"])
    {
        ActivityLocationViewController *locationVC = segue.destinationViewController;
        locationVC.showSearchBar = YES;
        
        if(_eventGeopoint.latitude!=0 && _eventGeopoint.longitude!=0){
            
            locationVC.eventGeopoint = _eventGeopoint;
            
        }
        
        locationVC.eventLocationText = _eventLocationLabel.text;
        locationVC.delegate = self;
        
    }
    else if([segue.identifier isEqualToString:@"category"])
    {
        ActivityCategoryViewController *categoryVC = segue.destinationViewController;
        categoryVC.isMultipleSelection = NO;
        categoryVC.delegate = self;
        
    }
    
}

- (IBAction)firstImagePressed:(id)sender {
    
    if(!_imageButton1.imageView.image){
        
        _currentButtonIndex = 0;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 0;
        
        [self showActionSheetWithCameraOptions];
        
    }
    
}
- (IBAction)secondImagePressed:(id)sender {
    
    if(!_imageButton2.imageView.image){
        
        _currentButtonIndex = 1;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 1;
        
        [self showActionSheetWithCameraOptions];
        
    }
    
}
- (IBAction)thirdImagePressed:(id)sender {
    
    if(!_imageButton3.imageView.image){
        
        _currentButtonIndex = 2;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 2;
        
        [self showActionSheetWithCameraOptions];
        
    }
    
}
//- (IBAction)fourthImagePressed:(id)sender {
//
//    _currentButtonIndex = 3;
//    [self showActionSheetWithCameraOptions];
//    if(_imageButton4.imageView.frame.size.width == _imageButton4.frame.size.width){
//
//        _currentButtonIndex = 3;
//
//        [self showAlertViewWithDeleteOptions];
//
//    }
//    else{
//
//        _currentButtonIndex = 3;
//
//        [self showActionSheetWithCameraOptions];
//
//    }
//}

-(void)showActionSheetWithCameraOptions{
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    [action showInView:self.view];
    
}

-(void)showAlertViewWithDeleteOptions{
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    alert.tag = 1;
    
    [alert show];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == 0)	ShouldStartCamera(self, YES);
        if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
    }
}

-(void)deleteRelatedMessages{
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudMessagesClass];
    [query whereKey:@"event" equalTo:_eventObject];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if(!error){
            
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                NSLog(@"Delete messages succeed");
                
            }];
            
        }
        
    }];
    
}

-(void)deleteRelatedNotifications{
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [query whereKey:@"event" equalTo:_eventObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(!error){
            
            for (PFObject *object in objects) {
                
                [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    NSLog(@"Delete notification succeed");
                    
                }];
            }
        }
        
    }];
    
}

#pragma mark - Category delegate

-(void)didSelectEventCategory:(NSString *)eventCategory{
    
    if(eventCategory){
        
        _eventCategoryLabel.text = eventCategory;
        
        //   [_eventObject setObject:eventCategory forKey:kHLEventKeyCategory];
        
    }
    
}

#pragma mark - HLLocation delegate

-(void)didSelectLocation:(CLLocation *)location locationString:(NSString *)locationText{
    
    //    self.eventLocationLabel.text = [NSString stringWithFormat:@"(%.2f, %.2f)", eventLocation.coordinate.latitude, eventLocation.coordinate.longitude];
    if(locationText){
        
        _eventLocationLabel.text = locationText;
        
    }
    
    if (location) {
        
        if(!_eventGeopoint){
            
            _eventGeopoint = [[PFGeoPoint alloc]init];
        }
        
        _eventGeopoint.longitude = location.coordinate.longitude;
        
        _eventGeopoint.latitude = location.coordinate.latitude;
        
    }
}


#pragma mark UITableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self resetViews];
    
    if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc]init];
            [hsdpvc.view setFrame:self.view.frame];
            hsdpvc.delegate = self;
            [self presentViewController:hsdpvc animated:YES completion:nil];
            
        }
        else if(indexPath.row == 1){
            
            [self performSegueWithIdentifier:@"map" sender:self];
            
        }
        else{
            
            [self performSegueWithIdentifier:@"category" sender:self];
            
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postActivityCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"Title";
            
            if(!self.titleTextField){
                
                self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 2, SCREEN_WIDTH - 100 , 40)];
                
                self.titleTextField.placeholder = @"Enter title";
                
                [self.titleTextField setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                
                [self.titleTextField setDelegate:self];
                
                [cell addSubview:self.titleTextField];
                
            }
            
        }
        else if(indexPath.row == 1){
            
            cell.textLabel.text = @"Description";
            
            if(!self.memberTextField){
                
                self.descriptionTextView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 126)];
                
                self.descriptionTextView.placeholder = @"Enter description";
                
                [self.descriptionTextView setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                
                [self.descriptionTextView setDelegate:self];
                
                [cell addSubview:self.descriptionTextView];
                
            }
            
        }
        else if(indexPath.row == 2){
            
            cell.textLabel.text = @"Member";
            
            if(!self.memberTextField){
                
                self.memberTextField = [[UITextField alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 40)];
                
                self.memberTextField.placeholder = @"Enter Number";
                
                [self.memberTextField setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                
                [self.memberTextField setDelegate:self];
                
                [cell addSubview:self.memberTextField];
                
            }
            
        }
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            cell.textLabel.text = @"Date";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!self.eventDateLabel) {
                
                self.eventDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 40)];
                [self.eventDateLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                [cell addSubview:self.eventDateLabel];
                
            }
            
        }
        else if(indexPath.row == 1){
            cell.textLabel.text = @"Location";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!self.eventLocationLabel) {
                
                self.eventLocationLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 40)];
                [self.eventLocationLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                [cell addSubview:self.eventLocationLabel];
                
            }
        }
        else if(indexPath.row == 2){
            cell.textLabel.text = @"Category";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if(!self.eventCategoryLabel){
                self.eventCategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 40)];
                [self.eventCategoryLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                [cell addSubview:self.eventCategoryLabel];
            }
        }
        
    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = @"More";
        
        if(!self.annoucementTextView){
            
            self.annoucementTextView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 86)];
            
            self.annoucementTextView.placeholder = @"More details here（Optional）";
            
            [self.annoucementTextView setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
            
            [self.annoucementTextView setDelegate:self];
            
            [cell addSubview:self.annoucementTextView];
            
        }
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 3;
    else if(section == 1)
        return 3;
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        if(indexPath.row == 1){
            
            return  130;
        }
        
    }
    else if(indexPath.section == 2){
        
        return  90;
    }
    
    return 44;
}

#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"EEEE yyyy-MM-dd hh:mm a";
    //    self.eventDateField.text =[NSString stringWithFormat:@"%@ %@", self.eventDateField.text, [dateFormater stringFromDate:date]];
    self.eventDateLabel.text = [dateFormater stringFromDate:date];
    
    _eventDate = date;
    //
    //    self.dateLabel.text = [dateFormater stringFromDate:date];
    //    self.selectedDate = date;
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker did dismiss with %lu", method);
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", method);
}

#pragma mark - UIImagePickerControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    
    UIImage *compressedImage = [UIImage imageWithData:UIImageJPEGRepresentation(picture, 0.2)];
    
    if(_currentButtonIndex == 0){
        
        _imageButton2.hidden = NO;
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton1 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton1 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton1 setImage:nil forState:UIControlStateNormal];
        
        self.imageButton1.imageView.image = nil;
        
    }
    else if(_currentButtonIndex == 1){
        
        _imageButton3.hidden = NO;
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton2 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton2 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton2 setImage:nil forState:UIControlStateNormal];
        self.imageButton2.imageView.image = nil;
        
        
    }
    else if(_currentButtonIndex == 2){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton3 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton3 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton3 setImage:nil forState:UIControlStateNormal];
        self.imageButton3.imageView.image = nil;
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
