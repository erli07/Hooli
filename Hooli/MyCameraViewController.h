//
//  MyCameraViewController.h
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
//@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
//- (IBAction)showCameraView:(id)sender;
//@property (weak, nonatomic) IBOutlet UIButton *showCameraButton;
//@property (weak, nonatomic) IBOutlet UITextView *itemDetailTextView;
//@property (weak, nonatomic) IBOutlet UITextField *priceInputBox;
//@property (weak, nonatomic) IBOutlet UIView *makeOfferView;
//@property (weak, nonatomic) IBOutlet UIView *postItemView;
//@property (weak, nonatomic) IBOutlet UITextField *categoryTextView;
-(void)initCameraPickerWithCompletionBlock:(void (^)(BOOL succeeded))completionBlock;
-(void)showCameraView;

@end
