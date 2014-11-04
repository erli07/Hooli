//
//  CameraOverlayViewController.h
//  Hooli
//
//  Created by Er Li on 10/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraOverlayViewController : UIViewController
@property (nonatomic, strong)IBOutlet UIImageView *image1;
@property (nonatomic, strong)IBOutlet UIImageView *image2;
@property (nonatomic, strong)IBOutlet UIImageView *image3;
@property (nonatomic, strong)IBOutlet UIImageView *image4;

- (IBAction)takePicture:(id)sender;

-(void)setImage:(UIImage *)image withImageIndex:(int)imageIndex ;
- (IBAction)cancelCameraView:(id)sender;
- (IBAction)postItem:(id)sender;

@end
