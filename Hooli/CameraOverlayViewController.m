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


}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];

    CGSize newSize = CGSizeMake(100.0f, 100.0f);
    UIGraphicsBeginImageContext(newSize);
    [chosenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    CGDataProviderRef provider = CGImageGetDataProvider(croppedImage.CGImage);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    const uint8_t* bytes = [data bytes];
    
    NSLog(@"image size %s", bytes);
    
//    CGImageRef imageRef = CGImageCreateWithImageInRect([chosenImage CGImage], CGRectMake(0, 0, 150, 150));
//    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
    
    int photoIndex = [[ImageCache sharedInstance]photoCount];
    photoIndex = photoIndex + 1;
    
    [[ImageCache sharedInstance]setPhotoCount:photoIndex ++];
    
    [self setImage:croppedImage withImageIndex:[[ImageCache sharedInstance]photoCount]];

    [[ImageCache sharedInstance] setImage:croppedImage withImageIndex:[[ImageCache sharedInstance]photoCount]];
    
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
    
//    [[HLSettings sharedInstance]setIsPostingOffer:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.cancelCameraView" object:self];
    
}

- (IBAction)postItem:(id)sender {
    
    
    if(self.image1.image == nil){
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"You need at least one photo to submit" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
    }
    else{
        
        [[HLSettings sharedInstance]setIsPostingOffer:NO];
    
        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.goToPostForm" object:self];
        
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    
}



- (IBAction)takePicture:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.takephoto" object:self];
}
@end
