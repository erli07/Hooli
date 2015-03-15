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
#import "HSDatePickerViewController.h"

@interface CreateActivityViewController ()<UIActionSheetDelegate,UIAlertViewDelegate, HSDatePickerViewControllerDelegate>
//@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic) NSMutableArray *imagesArray;
@end

@implementation CreateActivityViewController
@synthesize submitButton = _submitButton;
@synthesize inviteButton = _inviteButton;
@synthesize imagesArray = _imagesArray;
@synthesize currentButtonIndex = _currentButtonIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"Title",@"Detail",@"Location", @"Date"];
    
    self.title = @"发布活动";
    
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
    //
    //    if([[FormManager sharedInstance]eventDetailType]){
    //
    //        switch ([[FormManager sharedInstance]eventDetailType]) {
    //
    //            case HL_EVENT_DETAIL_NAME:
    //                [self.detailsArray replaceObjectAtIndex:0 withObject:[[FormManager sharedInstance]itemName]];
    //                break;
    //            case HL_EVENT_DETAIL_DESCRIPTION:
    //                [self.detailsArray replaceObjectAtIndex:1 withObject:[[FormManager sharedInstance]itemDescription]];
    //                break;
    //            case HL_EVENT_DETAIL_LOCATION:
    //                [self.detailsArray replaceObjectAtIndex:2 withObject:[[FormManager sharedInstance]itemPrice]];
    //                break;
    //            case HL_EVENT_DETAIL_DATE:
    //                [self.detailsArray replaceObjectAtIndex:3 withObject:[[FormManager sharedInstance]itemCategory]];
    //                break;
    //
    //            default:
    //                break;
    //        }
    //
    //    }
    //
    //    [self.tableView reloadData];
    //
}


-(BOOL)checkIfFieldsFilled{
    
    if([self.eventTitle.text isEqualToString:@""] || [self.eventContent.text isEqualToString:@""] || [self.eventMemberNumberField.text isEqualToString:@""] || [self.eventDateField.text isEqualToString:@""] || [self.eventLocationField.text isEqualToString:@""]){
        
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Field missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    else {
        
        return  YES;
    }
    
    
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

            
            if([_imagesArray count] == 0){
                
                //no images
                
                PFObject *eventObject = [[PFObject alloc]initWithClassName:kHLCloudEventClass];
                
                [eventObject setObject:self.eventTitle.text forKey:kHLEventKeyTitle];
                [eventObject setObject:self.eventContent.text forKey:kHLEventKeyDescription];
                [eventObject setObject:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] forKey:kHLEventKeyUserGeoPoint];
                [eventObject setObject:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] forKey:kHLEventKeyEventGeoPoint];
                [eventObject setObject:self.eventLocationField.text forKey:kHLEventKeyEventLocation];
                [eventObject setObject:self.eventAnnouncementField.text forKey:kHLEventKeyAnnoucement];
                [eventObject setObject:self.eventMemberNumberField.text forKey:kHLEventKeyMemberNumber];
                [eventObject setObject:[NSDate date] forKey:kHLEventKeyDate];
                [eventObject setObject:[PFUser currentUser] forKey:kHLEventKeyHost];
                [eventObject setObject:kHLEventCategoryEating forKey:kHLEventKeyCategory];
                
                [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if(succeeded){
                        
                        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"发布成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                        
                    }
                    else{
                        
                        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"发布失败..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                        [alert show];
                        
                    }
                    
                    [self tapEventOccured:nil];

                    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];

                    
                }];
                
            }
            else{
                //has images
                
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
                        
                        PFObject *eventObject = [[PFObject alloc]initWithClassName:kHLCloudEventClass];
                        [eventObject setObject:self.eventTitle.text forKey:kHLEventKeyTitle];
                        [eventObject setObject:self.eventContent.text forKey:kHLEventKeyDescription];
                        [eventObject setObject:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] forKey:kHLEventKeyUserGeoPoint];
                        [eventObject setObject:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] forKey:kHLEventKeyEventGeoPoint];
                        [eventObject setObject:self.eventLocationField.text forKey:kHLEventKeyEventLocation];
                        [eventObject setObject:self.eventAnnouncementField.text forKey:kHLEventKeyAnnoucement];
                        [eventObject setObject:self.eventMemberNumberField.text forKey:kHLEventKeyMemberNumber];
                        [eventObject setObject:[NSDate date] forKey:kHLEventKeyDate];
                        [eventObject setObject:[PFUser currentUser] forKey:kHLEventKeyHost];
                        [eventObject setObject:[PFObject objectWithoutDataWithClassName:
                                                kHLCloudEventImagesClass objectId:eventImages.objectId] forKey:kHLEventKeyImages];
                        
                        NSData *imageData = [HLUtilities compressImage:[_imagesArray objectAtIndex:0]WithCompression:0.1f];
                        PFFile *thumbnailFile = [PFFile fileWithName:@"thumbnail.jpg" data:imageData];
                        [eventObject setObject:thumbnailFile forKey:kHLEventKeyThumbnail];
                        [eventObject setObject:kHLEventCategoryEating forKey:kHLEventKeyCategory];

                        [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            if(succeeded){
                                
                                UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"发布成功！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                
                                [alert show];
                                
                            }
                            
                            [self tapEventOccured:nil];

                            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];

                            
                        }];
                        
                    }
                    
                }];
                
            }
        }
    }
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.eventTitle){
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x,  - 80,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
        
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
- (IBAction)inviteFriends:(id)sender {
    
    
}

- (IBAction)selectCategory:(id)sender {
    
    [self performSegueWithIdentifier:@"category" sender:self];

}

- (IBAction)locateInMap:(id)sender {
    
    [self performSegueWithIdentifier:@"map" sender:self];
}

- (IBAction)showCalender:(id)sender {
    
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;

    [self presentViewController:hsdpvc animated:YES completion:nil];

}


- (IBAction)firstImagePressed:(id)sender {
    
    _currentButtonIndex = 0;
    
    [self showActionSheetWithCameraOptions];
    
}
- (IBAction)secondImagePressed:(id)sender {
    
    _currentButtonIndex = 1;
    
    [self showActionSheetWithCameraOptions];
    
}
- (IBAction)thirdImagePressed:(id)sender {
    
    _currentButtonIndex = 2;
    
    [self showActionSheetWithCameraOptions];
    
}
- (IBAction)fourthImagePressed:(id)sender {
    
    _currentButtonIndex = 3;
    
    [self showActionSheetWithCameraOptions];
    
}

-(void)showActionSheetWithCameraOptions{
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    [action showInView:self.view];
    
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


#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm";
    self.eventDateField.text = [dateFormater stringFromDate:date];
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
        
    }
    else if(_currentButtonIndex == 1){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton2 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton2 setTitle:@"" forState:UIControlStateNormal];
        
    }
    else if(_currentButtonIndex == 2){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton3 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton3 setTitle:@"" forState:UIControlStateNormal];
        
    }
    else if(_currentButtonIndex == 3){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton4 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton4 setTitle:@"" forState:UIControlStateNormal];
        
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
