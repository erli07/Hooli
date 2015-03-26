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
@interface CreateActivityViewController ()<UIActionSheetDelegate,UIAlertViewDelegate, HSDatePickerViewControllerDelegate>
//@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic) NSMutableArray *imagesArray;
@property (nonatomic) NSDate *eventDate;
@property (nonatomic) NSString *eventDateText;
@property (nonatomic) CLLocation *eventLocation;
@property (nonatomic) PFGeoPoint *eventGeopoint;
@property (nonatomic) NSString *eventCategory;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"Title",@"Detail",@"Location", @"Date"];
    
    self.title = @"发布活动";
    
    _eventContent.placeholder = @"简洁介绍你的活动，吸引更多的小伙伴儿，不多于80个字 ";
    
    _eventContent.placeholderColor = [UIColor lightGrayColor];
    
    _eventAnnouncementField.placeholder = @"附加详细信息，包括注意事项等，可稍后修改 （Optional）";
    
    _eventAnnouncementField.placeholderColor = [UIColor lightGrayColor];
    
    [_inviteButton setBackgroundColor:[HLTheme secondColor]];
    
    [_submitButton setBackgroundColor:[HLTheme secondColor]];
    
    _inviteButton.tintColor = [UIColor whiteColor];
    
    _submitButton.tintColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventOccured:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _imagesArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self configureEventObject:_eventObject];
    
}


-(void)configureEventObject:(PFObject *)eventObject{
    
    if(_eventObject){
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"删除"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(deleteEvent)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
        _eventTitle.text = [eventObject objectForKey:kHLEventKeyTitle];
        _eventContent.text = [eventObject objectForKey:kHLEventKeyDescription];
        _eventLocationField.text = [eventObject objectForKey:kHLEventKeyEventLocation];
        _eventDateField.text = [eventObject objectForKey:kHLEventKeyDateText];
        _eventDate = [eventObject objectForKey:kHLEventKeyDate];
        _eventGeopoint = [eventObject objectForKey:kHLEventKeyEventGeoPoint];
        _eventAnnouncementField.text = [eventObject objectForKey:kHLEventKeyAnnoucement];
        _eventMemberNumberField.text = [eventObject objectForKey:kHLEventKeyMemberNumber];
        _eventCategoryLabel.text = [eventObject objectForKey:kHLEventKeyCategory];
        
        PFObject *imagesObject = [eventObject objectForKey:kHLEventKeyImages];
        
        PFFile *imageFile0 =[imagesObject objectForKey:@"imageFile0"];
        if(imageFile0){
            
            [_imagesArray addObject:[UIImage imageWithData:[imageFile0 getData]]];
            [self.imageButton1 setImage:[UIImage imageWithData:[imageFile0 getData]] forState:UIControlStateNormal];
        }
        PFFile *imageFile1 =[imagesObject objectForKey:@"imageFile1"];
        if(imageFile1){
            [_imagesArray addObject:[UIImage imageWithData:[imageFile1 getData]]];
            [self.imageButton2 setImage:[UIImage imageWithData:[imageFile1 getData]] forState:UIControlStateNormal];
        }
        PFFile *imageFile2 =[imagesObject objectForKey:@"imageFile2"];
        if(imageFile2){
            [_imagesArray addObject:[UIImage imageWithData:[imageFile2 getData]]];
            [self.imageButton3 setImage:[UIImage imageWithData:[imageFile2 getData]] forState:UIControlStateNormal];
        }
        
        [_submitButton setTitle:@"发布更新" forState:UIControlStateNormal];
        
        
    }
    else{
        
        
        
    }
    
    
}



-(BOOL)checkIfFieldsFilled{
    
    if([self.eventTitle.text isEqualToString:@""] || [self.eventContent.text isEqualToString:@""] || [self.eventMemberNumberField.text isEqualToString:@""] || [self.eventDateField.text isEqualToString:@""] || [self.eventLocationField.text isEqualToString:@""]){
        
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Field missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    else if([_imagesArray count] == 0){
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Image missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
    }
    else {
        
        return  YES;
    }
    
    
}

-(void)deleteEvent{
    
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"确定删除？" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    alert.tag = 2;
    
    [alert show];
    
}




- (IBAction)submitActivity:(id)sender {
    
    if(![self checkIfFieldsFilled]){
        return;
    }
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"确定发布？" delegate:self cancelButtonTitle:@"等一会儿" otherButtonTitles:@"是的", nil];
    
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
                    
                    [eventObject setObject:self.eventTitle.text forKey:kHLEventKeyTitle];
                    [eventObject setObject:self.eventContent.text forKey:kHLEventKeyDescription];
                    [eventObject setObject:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] forKey:kHLEventKeyUserGeoPoint];
                    [eventObject setObject:self.eventLocationField.text forKey:kHLEventKeyEventLocation];
                    [eventObject setObject:self.eventAnnouncementField.text forKey:kHLEventKeyAnnoucement];
                    [eventObject setObject:self.eventMemberNumberField.text forKey:kHLEventKeyMemberNumber];
                    [eventObject setObject:self.eventDateField.text forKey:kHLEventKeyDateText];
                    
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
                    [eventObject setObject:kHLEventCategoryEating forKey:kHLEventKeyCategory];
                    
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
                                        
                                        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"发布成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                        
                                        [alert show];
                                        
                                        [self.delegate didCreateActivity:eventObject];
                                        
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                        
                                    }
                                    
                                }];
                                
                            }
                            else{
                                
                                UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"更新成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                
                                [alert show];
                                
                                UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                HomeViewViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                                
                                [self presentViewController:vc animated:YES completion:^{
                                    
                                    [self.delegate didCreateActivity:_eventObject];
                                    
                                }];
                                
                            }
                            
                        }
                        else{
                            
                            UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"发布失败..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                            
                            [alert show];
                            
                        }
                        
                        [self tapEventOccured:nil];
                        
                        [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                        
                        
                    }];
                    
                }
                
            }];
            
        }
        
    }
    else if(alertView.tag == 1){
        
        if(buttonIndex == 1){
            
            if(_currentButtonIndex == 0){
                
                [self.imageButton1 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
                
            }
            else if(_currentButtonIndex == 1){
                
                [self.imageButton2 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
                
            }
            else{
                
                [self.imageButton3 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
                
            }
        }
    }
    else if(alertView.tag == 2){
        
        if(buttonIndex == 1){
            
            PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:_eventObject.objectId];
            
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    
                    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"删除成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    HomeViewViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                    
                    [self presentViewController:vc animated:YES completion:^{
                        
                        [self.delegate didCreateActivity:_eventObject];
                        
                    }];
                    
                    
                }
                
            }];
            
        }
    }
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.eventMemberNumberField){
        
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [textField setKeyboardAppearance:UIKeyboardAppearanceLight];
        
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"人数不限"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(setEventNoLimited)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        
        textField.inputAccessoryView = keyboardDoneButtonView;
        
        
    }
    
    if(textField == self.eventTitle){
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x,  - 80,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
        
    }
    else if(textField == self.eventLocationField){
        
        [textField resignFirstResponder];

        [self performSegueWithIdentifier:@"map" sender:self];

    }
    else if(textField == self.eventDateField){
        
        [textField resignFirstResponder];
        
        HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
        hsdpvc.delegate = self;
        
        [self presentViewController:hsdpvc animated:YES completion:nil];
        
    }
    else{
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 40,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
        
    }
   
    
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if(textView == self.eventAnnouncementField){
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, - 250,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
    }
    else{
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x,  - 80,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
        
    }
}

-(void)tapEventOccured:(UIGestureRecognizer *)gesture{
    
    [UIView animateWithDuration:.5
                     animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, 0,
                                                               self.view.frame.size.width, self.view.frame.size.height); } ];
    
    
    for (UIView *subView in self.view.subviews) {
        
        if ([subView isFirstResponder]) {
            
            [subView resignFirstResponder];
            
        }
    }
    
    
}

-(void)setEventNoLimited{
    
    self.eventMemberNumberField.text = @"人数不限";
    
}
- (IBAction)inviteFriends:(id)sender {
    
    
}

- (IBAction)selectCategory:(id)sender {
    
    [self performSegueWithIdentifier:@"category" sender:self];
    
}

- (IBAction)locateInMap:(id)sender {
    
}

- (IBAction)showCalender:(id)sender {
    

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"map"])
    {
        ActivityLocationViewController *locationVC = segue.destinationViewController;
        locationVC.showSearchBar = YES;
        locationVC.eventGeopoint = _eventGeopoint;
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
    
    if(_imageButton1.imageView.frame.size.width == _imageButton1.frame.size.width){
        
        _currentButtonIndex = 0;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 0;
        
        [self showActionSheetWithCameraOptions];
        
    }
    
}
- (IBAction)secondImagePressed:(id)sender {
    
    if(_imageButton2.imageView.frame.size.width == _imageButton2.frame.size.width){
        
        _currentButtonIndex = 1;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 1;
        
        [self showActionSheetWithCameraOptions];
        
    }
    
}
- (IBAction)thirdImagePressed:(id)sender {
    
    if(_imageButton3.imageView.frame.size.width == _imageButton3.frame.size.width){
        
        _currentButtonIndex = 2;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 2;
        
        [self showActionSheetWithCameraOptions];
        
    }
    
}
- (IBAction)fourthImagePressed:(id)sender {
    
    _currentButtonIndex = 3;
    [self showActionSheetWithCameraOptions];
    
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
    
}

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



#pragma mark - Category delegate

-(void)didSelectEventCategory:(NSString *)eventCategory{
    
    if(eventCategory){
        
        self.eventCategoryLabel.text = eventCategory;
        
    }
    
}

#pragma mark - HLLocation delegate

-(void)didSelectEventLocation:(CLLocation *)eventLocation locationString:(NSString *)eventLocationText{
    
    //    self.eventLocationLabel.text = [NSString stringWithFormat:@"(%.2f, %.2f)", eventLocation.coordinate.latitude, eventLocation.coordinate.longitude];
    if(eventLocationText){
        
        self.eventLocationField.text = eventLocationText;
        
        
    }
    
    if (eventLocation) {
        
        _eventGeopoint = [[PFGeoPoint alloc]init];
        
        _eventGeopoint.longitude = eventLocation.coordinate.longitude;
        
        _eventGeopoint.latitude = eventLocation.coordinate.latitude;
    }
    
    
    
}

#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"EEEE yyyy-MM-dd hh:mm a";
    //    self.eventDateField.text =[NSString stringWithFormat:@"%@ %@", self.eventDateField.text, [dateFormater stringFromDate:date]];
    self.eventDateField.text = [dateFormater stringFromDate:date];
    
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
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton1 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton1 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton1 setImage:nil forState:UIControlStateNormal];
        
    }
    else if(_currentButtonIndex == 1){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton2 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton2 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton2 setImage:nil forState:UIControlStateNormal];
        
        
    }
    else if(_currentButtonIndex == 2){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton3 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton3 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton3 setImage:nil forState:UIControlStateNormal];
        
    }
    else if(_currentButtonIndex == 3){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton4 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton4 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton4 setImage:nil forState:UIControlStateNormal];
        
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
