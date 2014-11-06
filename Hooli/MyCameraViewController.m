
//
//  MyCameraViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyCameraViewController.h"
#import "CameraOverlayViewController.h"
#import "HLTheme.h"
#import "HLSettings.h"
#import "OffersManager.h"
#import "HLConstant.h"
#import "MBProgressHUD.h"
#import "ImageManager.h"
#import "LocationManager.h"
#define CAMERA_TRANSFORM_X 1
//#define CAMERA_TRANSFORM_Y 1.12412 // this was for iOS 3.x
#define CAMERA_TRANSFORM_Y 1.24299 // this works for iOS 4.x


@interface MyCameraViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    unsigned int photoCount;
}
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *takePhotosButton;
@property (nonatomic, strong) UIButton *selectPhotoButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) CameraOverlayViewController *overlayVC;
@property (nonatomic, strong) UIBarButtonItem *retakePhotosButton;
@property (nonatomic, strong) UIBarButtonItem *confirmButton;
@property (nonatomic,assign) BOOL cancelFlag;

@end

@implementation MyCameraViewController
@synthesize priceInputBox,itemDetailTextView,itemNameTextField,image1,image2,image3,image4;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[HLSettings sharedInstance]setIsPostingOffer:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(takePhotoClicked)
                                                 name:@"Hooli.takephoto" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelCameraView)
                                                 name:@"Hooli.cancelCameraView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(submitOfferToCloud)
                                                 name:@"Hooli.submitOfferToCloud" object:nil];
    [self configureUIElements];
    
    self.priceInputBox.delegate = self;
    
    self.itemDetailTextView.delegate = self;
    
    self.itemNameTextField.delegate = self;
    
    self.categoryTextView.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    photoCount = 0;
    
    
    
    [self updateCurrentView];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[HLSettings sharedInstance]setCategory:nil];
    
}
-(void)submitOfferToCloud{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    NSArray *imagesArray = [NSArray arrayWithObjects:self.image1,self.image2,self.image3,self.image4, nil];
    //  UIImage *image = [[ImageManager sharedInstance]loadImageWithName:@"image1"];
    
    OfferModel *offer = [[OfferModel alloc]initOfferModelWithUser:[PFUser currentUser] image:self.image1  price:self.priceInputBox.text offerName:self.itemNameTextField.text category:self.categoryTextView.text description:self.itemDetailTextView.text location:[[LocationManager sharedInstance]currentLocation]];
//
//    OfferModel *offer = [[OfferModel alloc]initOfferModelWithUser:[PFUser currentUser] imageArray:imagesArray price:self.priceInputBox.text offerName:self.itemNameTextField.text  category:self.categoryTextView.text description:self.itemDetailTextView.text location:[[LocationManager sharedInstance]currentLocation]];
    
    [[OffersManager sharedInstance]updaloadOfferToCloud:offer withSuccess:^{
        
        [HUD hide:YES];
        [self updateCurrentView];
        
        
            UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
                                                                  message:@"You have successfully post your item!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
            [confirmAlert show];
        
        
    } withFailure:^(id error) {
        
        [HUD hide:YES];
        
    }];
    
    
}

-(void)confirmOffer{
    
    [[HLSettings sharedInstance]setIsPostingOffer:YES];
    
    UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Are you sure?"
                                                          message:@"Do you confirm to make this offer?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Confirm" , nil];
    [confirmAlert show];
    
    
    
}


-(void)updateCurrentView{
    
    if(![[HLSettings sharedInstance]isPostingOffer]){
        
        self.title = @"Make Offer";
        
        self.makeOfferView.hidden = NO;
        
        self.retakePhotosButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Retake"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showCameraView:)];
        self.navigationItem.leftBarButtonItem =  self.retakePhotosButton;
        
        self.confirmButton = [[UIBarButtonItem alloc]
                              initWithTitle:@"Confirm"
                              style:UIBarButtonItemStylePlain
                              target:self
                              action:@selector(confirmOffer)];
        self.navigationItem.rightBarButtonItem = self.confirmButton;
        
        [self.itemNameTextField becomeFirstResponder];
        
        if([[HLSettings sharedInstance]category]){
            
            self.categoryTextView.text = [[HLSettings sharedInstance]category][0];
            
        }
        else{
            
            self.categoryTextView.text = @"";
        }
        
    }
    
    else{
        
        self.makeOfferView.hidden = YES;
        
        self.navigationItem.leftBarButtonItem = nil;
        
        self.navigationItem.rightBarButtonItem = nil;
        
        self.title = @"Post Item";
        
        [self.priceInputBox resignFirstResponder];
        
        [self.itemDetailTextView resignFirstResponder];
        
        [self.itemNameTextField resignFirstResponder];
        
    }
    
    
}


- (IBAction)showCameraView:(id)sender {
    
    self.overlayVC = [[CameraOverlayViewController alloc]initWithNibName:@"CameraOverlayViewController" bundle:nil];
    
    // Create a new image picker instance:
    self.picker = [[UIImagePickerController alloc] init];
    
    // Set the image picker source:
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Hide the controls:
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Insert the overlay:
    self.picker.cameraOverlayView = self.overlayVC.view;
    
    // Show the picker:
    
    
    [self presentViewController:self.picker animated:YES completion:NULL];
}

-(void)configureUIElements{
    
    self.view.tintColor = [HLTheme mainColor];
    
    [self.navigationController setNavigationBarHidden:NO];
    //
    self.title = @"Post Item";
    
    
    [self.showCameraButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self.showCameraButton setBackgroundImage:[UIImage imageNamed:@"button-pressed"] forState:UIControlStateHighlighted];
    [self.showCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, 200, 200)];
    //    self.takePhotosButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [self.takePhotosButton  addTarget:self
    //                               action:@selector(takePhotoClicked)
    //                     forControlEvents:UIControlEventTouchUpInside];
    //    [self.takePhotosButton  setTitle:@"Take Photo" forState:UIControlStateNormal];
    //    self.takePhotosButton.frame = CGRectMake(60, 420, 200, 40);
    //
    //    self.selectPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [self.selectPhotoButton  addTarget:self
    //                                action:@selector(selectPhotoClicked)
    //                      forControlEvents:UIControlEventTouchUpInside];
    //    [self.selectPhotoButton  setTitle:@"Select Photo" forState:UIControlStateNormal];
    //    self.selectPhotoButton.frame = CGRectMake(60, 420, 200, 40);
    //
    //    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    [self.submitButton  addTarget:self
    //                           action:@selector(uploadImage)
    //                 forControlEvents:UIControlEventTouchUpInside];
    //    [self.submitButton  setTitle:@"Submit" forState:UIControlStateNormal];
    //    self.submitButton.frame = CGRectMake(60, 420, 200, 40);
    //
    //
    //    [self.view addSubview:self.submitButton];
    //    [self.view addSubview:self.imageView];
    //    [self.view addSubview:self.takePhotosButton];
    //    [self.view addSubview:self.selectPhotoButton];
    //
    //    [self.submitButton setHidden:YES];
    
    
}



-(void)cancelCameraView{
    
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)takePhotoClicked {
    
    if(photoCount < 4){
        
        [self.picker takePicture];
        
    }
    
}

- (void)selectPhotoClicked {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    photoCount ++;
    
    [self.overlayVC setImage:chosenImage withImageIndex:photoCount];
    [self setImage:chosenImage withImageIndex:photoCount];
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [chosenImage drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    //  [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)setImage:(UIImage *)image withImageIndex:(int)imageIndex{
    
    switch (imageIndex) {
        case 1:
            self.image1 = image;
            break;
        case 2:
            self.image2 = image;
            break;
        case 3:
            self.image3 = image;
            break;
        case 4:
            self.image4 = image;
            break;
            
        default:
            break;
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma  mark -UIAlertview delegate


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
        
    }
    else if(buttonIndex == 1){
        
        
        [self submitOfferToCloud];
        
        
    }
}

#pragma mark textview delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.priceInputBox) {
        
        self.priceInputBox.text = @"$";
    }
    else if (textField == self.categoryTextView){
        
        [self performSegueWithIdentifier:@"selectCategory" sender:self];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    self.itemDetailTextView.text = @"";
}
@end
