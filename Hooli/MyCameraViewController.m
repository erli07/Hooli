
//
//  MyCameraViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyCameraViewController.h"

@interface MyCameraViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *takePhotosButton;
@property (nonatomic, strong) UIButton *selectPhotoButton;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) NSData *imageData;
@end

@implementation MyCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureUIElements];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)configureUIElements{
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, 200, 200)];
    self.takePhotosButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.takePhotosButton  addTarget:self
                               action:@selector(takePhotoClicked)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.takePhotosButton  setTitle:@"Take Photo" forState:UIControlStateNormal];
    self.takePhotosButton.frame = CGRectMake(60, 360, 200, 40);
    
    self.selectPhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.selectPhotoButton  addTarget:self
                                action:@selector(selectPhotoClicked)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.selectPhotoButton  setTitle:@"Select Photo" forState:UIControlStateNormal];
    self.selectPhotoButton.frame = CGRectMake(60, 420, 200, 40);
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.submitButton  addTarget:self
                           action:@selector(uploadImage)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton  setTitle:@"Submit" forState:UIControlStateNormal];
    self.submitButton.frame = CGRectMake(60, 420, 200, 40);
    
    
    [self.view addSubview:self.submitButton];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.takePhotosButton];
    [self.view addSubview:self.selectPhotoButton];
    
    [self.submitButton setHidden:YES];
    
    
}


- (void)takePhotoClicked {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
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
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [self.takePhotosButton setHidden:YES];
    [self.selectPhotoButton setHidden:YES];
    [self.submitButton setHidden:NO];
    
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [chosenImage drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
