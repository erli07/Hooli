//
//  MyCameraViewController.h
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
- (IBAction)showCameraView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *showCameraButton;
@property (weak, nonatomic) IBOutlet UITextView *itemDetailTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceInputBox;
@property (weak, nonatomic) IBOutlet UIView *makeOfferView;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextView;

@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property (nonatomic, strong) UIImage *image4;
@end
