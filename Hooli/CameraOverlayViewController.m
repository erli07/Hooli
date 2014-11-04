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
@interface CameraOverlayViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}

@end

@implementation CameraOverlayViewController
@synthesize image1,image2,image3,image4;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [[HLSettings sharedInstance]setPostItemStatus:HL_POST_ITEM];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.cancelCameraView" object:self];

}

- (IBAction)postItem:(id)sender {
  
    [[HLSettings sharedInstance]setPostItemStatus:HL_MAKE_OFFER];
    
//    OfferModel *offer = [[OfferModel alloc]initOfferModelWithUser:[PFUser currentUser] image:image1.image price:@"$100" category:@"Books" description:@"this is a cook book"];
//    
//    [[OffersManager sharedInstance]updaloadOfferToCloud:offer withSuccess:^{
//        
//        
//    } withFailure:^(id error) {
//        
//        
//    }];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];

//    [[ImageManager sharedInstance]saveImage:image1.image WithName:@"image1"];
//    [[ImageManager sharedInstance]saveImage:image2.image WithName:@"image2"];
//    [[ImageManager sharedInstance]saveImage:image3.image WithName:@"image3"];
//    [[ImageManager sharedInstance]saveImage:image4.image WithName:@"image4"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.cancelCameraView" object:self];

 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.submitOfferToCloud" object:self];


//     [self uploadImage:image2];
//     [self uploadImage:image3];
//     [self uploadImage:image4];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.postItem" object:self];

}

-(void)viewWillDisappear:(BOOL)animated{
    [HUD hide:YES];
}

- (void)uploadImage:(OfferModel *)offer
{
    
    if(offer.image == nil){
        
        return;
        
    }
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [offer.image drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    NSLog(@"Image size %u kb", [imageData length]/1024);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *offerClass = [PFObject objectWithClassName:kHLCloudOfferClass];
            [offerClass setObject:imageFile forKey:kHLCloudImageKeyForOfferClass];
            offerClass.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [offerClass setObject:user forKey:kHLCloudUserKeyForOfferClass];
            [offerClass setObject:offer.offerDescription forKey:kHLCloudDescriptionKeyForOfferClass];
            [offerClass setObject:offer.offerPrice forKey:kHLCloudPriceKeyForOfferClass];
            [offerClass setObject:offer.offerCategory forKey:kHLCloudCategoryKeyForOfferClass];
            
            [offerClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // [self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        
    }];
}


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
