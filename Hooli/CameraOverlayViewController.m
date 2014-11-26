//
//  CameraOverlayViewController.m
//  Hooli
//
//  Created by Er Li on 10/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "CameraOverlayViewController.h"
#import "MBProgressHUD.h"
#import "HLSettings.h"
#import "OffersManager.h"
#import "OfferModel.h"
#import "HLConstant.h"
#import "ImageManager.h"
#import "MyCameraViewController.h"
#import "ImageCache.h"
@interface CameraOverlayViewController ()<MBProgressHUDDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    MBProgressHUD *HUD;
}

@end

@implementation CameraOverlayViewController
@synthesize image1,image2,image3,image4;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addGestureToImages];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (IBAction)selectPhotos:(id)sender {
    
    
    

            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
            
    


  //  [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.selectPhoto" object:self];

}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];

//    CGImageRef imageRef = CGImageCreateWithImageInRect([chosenImage CGImage], CGRectMake(0, 0, 640, 640));
//    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
    
    int photoIndex = [[ImageCache sharedInstance]photoCount];
    photoIndex = photoIndex + 1;
    [[ImageCache sharedInstance]setPhotoCount:photoIndex ++];
    
    [self setImage:chosenImage withImageIndex:[[ImageCache sharedInstance]photoCount]];

    [[ImageCache sharedInstance] setImage:chosenImage withImageIndex:[[ImageCache sharedInstance]photoCount]];
    
   [picker dismissViewControllerAnimated:YES completion:^{
      
   }];

}



-(void)addGestureToImages{
    
    
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(addDismissGesture:)];
    [self.image1 addGestureRecognizer:tapImage];
    [self.image2 addGestureRecognizer:tapImage];
    [self.image3 addGestureRecognizer:tapImage];
    [self.image4 addGestureRecognizer:tapImage];

}

-(void)addDismissGesture:(id)sender{
    
    
}

-(void)setImage:(UIImage *)image withImageIndex:(int)imageIndex{
    
    switch (imageIndex) {
        case 1:
            self.image1.image = image;
            break;
        case 2:
            self.image2.image = image;
            break;
        case 3:
            self.image3.image = image;
            break;
        case 4:
            self.image4.image = image;
            break;
            
        default:
            break;
    }
    
}

- (IBAction)cancelCameraView:(id)sender {
    
    [[HLSettings sharedInstance]setIsPostingOffer:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.cancelCameraView" object:self];
    
}

- (IBAction)postItem:(id)sender {
    
    
    if(self.image1.image == nil){
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"You need at least one photo to submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }
    else{
        
        [[HLSettings sharedInstance]setIsPostingOffer:NO];
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD show:YES];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.cancelCameraView" object:self];
        
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [HUD hide:YES];
}



- (IBAction)takePicture:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.takephoto" object:self];
}
@end