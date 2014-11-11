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
@synthesize image1,image2,image3,image4,photoCount;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.photoCount ++;
    
    [self setImage:chosenImage withImageIndex:self.photoCount];

    [[ImageCache sharedInstance] setImage:chosenImage withImageIndex:photoCount];
    
   [picker dismissViewControllerAnimated:YES completion:^{
      
   }];

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

//- (void)uploadImage:(OfferModel *)offer
//{
//
//    if(offer.image == nil){
//
//        return;
//
//    }
//    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
//    [offer.image drawInRect: CGRectMake(0, 0, 640, 640)];
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
//
//    NSLog(@"Image size %u kb", [imageData length]/1024);
//    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
//
//    // Save PFFile
//    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//
//            // Create a PFObject around a PFFile and associate it with the current user
//            PFObject *offerClass = [PFObject objectWithClassName:kHLCloudOfferClass];
//            [offerClass setObject:imageFile forKey:kHLCloudImageKeyForOfferClass];
//            offerClass.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
//
//            PFUser *user = [PFUser currentUser];
//            [offerClass setObject:user forKey:kHLCloudUserKeyForOfferClass];
//            [offerClass setObject:offer.offerDescription forKey:kHLCloudDescriptionKeyForOfferClass];
//            [offerClass setObject:offer.offerPrice forKey:kHLCloudPriceKeyForOfferClass];
//            [offerClass setObject:offer.offerCategory forKey:kHLCloudCategoryKeyForOfferClass];
//
//            [offerClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (!error) {
//                    // [self refresh:nil];
//                }
//                else{
//                    // Log details of the failure
//                    NSLog(@"Error: %@ %@", error, [error userInfo]);
//                }
//            }];
//        }
//        else{
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    } progressBlock:^(int percentDone) {
//
//    }];
//}
//

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)takePicture:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.takephoto" object:self];
}
@end
