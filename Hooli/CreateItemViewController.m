//
//  CreateItemViewController.m
//  Hooli
//
//  Created by Er Li on 3/28/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "CreateItemViewController.h"
#import "OffersManager.h"
#import "MBProgressHUD.h"
#import "ItemDetailViewController.h"
#import "HLSettings.h"
#import "FormManager.h"
#import "OfferModel.h"
#import "HLTheme.h"
#import "camera.h"
#import "ActivityLocationViewController.h"
#import "SelectCategoryTableViewController.h"

@interface CreateItemViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,HLActivityLocationDelegate,UITextFieldDelegate,UITextViewDelegate,HLItemCategoryDelegate>
@property (nonatomic) NSMutableArray *imagesArray;
@property (nonatomic,assign) CLLocationCoordinate2D itemLocationCoordinate;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic) NSString *itemCondition;

@end

@implementation CreateItemViewController
@synthesize currentButtonIndex = _currentButtonIndex;
@synthesize itemCategoryField = _itemCategoryField;
@synthesize itemConditionField = _itemConditionField;
@synthesize itemContetnTextView = _itemContetnTextView;
@synthesize itemPickupField = _itemPickupField;
@synthesize itemPriceField = _itemPriceField;
@synthesize itemTitleField = _itemTitleField;
@synthesize imagesArray = _imagesArray;
@synthesize itemLocationCoordinate = _itemLocationCoordinate;
@synthesize submitButton= _submitButton;
@synthesize itemCondition = _itemCondition;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemContetnTextView.placeholder = @"必填";
    
    _imagesArray = [NSMutableArray new];
    
    _itemPickupField.delegate = self;
    _itemCategoryField.delegate = self;
    _itemConditionField.delegate = self;
    _itemTitleField.delegate = self;
    _itemContetnTextView.delegate = self;
    _itemPriceField.delegate = self;
    
    _imageButton1.hidden = NO;
    _imageButton2.hidden = YES;
    _imageButton3.hidden = YES;
    _imageButton4.hidden = YES;
    
    
    [_itemPriceField setKeyboardType:UIKeyboardTypeNumberPad];
    
    [_submitButton setBackgroundColor:[HLTheme mainColor]];
    [_submitButton setTintColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventOccured:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

-(BOOL)checkFieldEmpty{
    
    if([_itemContetnTextView.text  isEqual: @""] || [_itemCategoryField.text  isEqual: @""] || [_itemPickupField.text  isEqual: @""] || [_itemConditionField.text  isEqual: @""] || [_itemPriceField.text  isEqual: @""] || [_itemTitleField.text isEqualToString:@""]){
        
        return NO;
        
    }
    
    return YES;
}

-(BOOL)checkImagesEmpty{
    
    if(_imagesArray == nil || [_imagesArray count] == 0){
        
        return NO;
        
    }
    
    return YES;
}

- (IBAction)submitItem:(id)sender {
    
    if(![self checkFieldEmpty] || ![self checkImagesEmpty]){
        
        return;
    }
    
    NSString *itemName = _itemTitleField.text;
    NSString *itemPrice = _itemPriceField.text;
    NSString *itemCategory = _itemCategoryField.text;
    NSString *itemDescription = _itemContetnTextView.text;
    NSString *itemCondtion = _itemConditionField.text;
    
    
    OfferModel *offer = [[OfferModel alloc]initOfferModelWithUser:[PFUser currentUser] imageArray:_imagesArray  price:itemPrice offerName:itemName category:itemCategory description:itemDescription location:_itemLocationCoordinate isOfferSold:[NSNumber numberWithBool:NO] condition:itemCondtion];
    
    [[OffersManager sharedInstance]updaloadOfferToCloud:offer withSuccess:^{
        
        
        [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
        
        [[FormManager sharedInstance]setToUser:nil];
        
        [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
        
        UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
                                                              message:@"You have successfully post your item!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [confirmAlert show];
        
        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
        vc.offerObject = offer;
        vc.isFirstPosted = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController pushViewController:vc animated:YES];
        
    } withFailure:^(id error) {
        
        [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
        
        
    }];
    
}

-(void)configureImageButtons{
    
    [self.imageButton1 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.imageButton1 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];

    [self.imageButton2 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.imageButton2 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];

    [self.imageButton3 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.imageButton3 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];

    [self.imageButton4 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.imageButton4 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
    
    for (int i = 0; i< [_imagesArray count]; i++) {
        
        switch (i) {
            case 0:
                
                if( [_imagesArray objectAtIndex:0] != nil){
                    
                    [_imageButton1 setBackgroundImage:[_imagesArray objectAtIndex:0] forState:UIControlStateNormal];
                    [_imageButton1 setTitle:@"" forState:UIControlStateNormal];
                    [_imageButton1 setImage:nil forState:UIControlStateNormal];
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = YES;
                    _imageButton4.hidden = YES;


                }
                else{
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = YES;
                    _imageButton3.hidden = YES;
                    _imageButton4.hidden = YES;

                }
                
                break;
            case 1:
                if( [_imagesArray objectAtIndex:1] != nil){
                    
                    [_imageButton2 setBackgroundImage:[_imagesArray objectAtIndex:1] forState:UIControlStateNormal];
                    [_imageButton2 setTitle:@"" forState:UIControlStateNormal];
                    [_imageButton2 setImage:nil forState:UIControlStateNormal];
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = NO;
                    _imageButton4.hidden = YES;

                }
                else{
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = YES;
                    _imageButton4.hidden = YES;
                    
                }
                break;
            case 2:
                if( [_imagesArray objectAtIndex:1] != nil){
                    
                    [_imageButton3 setBackgroundImage:[_imagesArray objectAtIndex:2] forState:UIControlStateNormal];
                    [_imageButton3 setTitle:@"" forState:UIControlStateNormal];
                    [_imageButton3 setImage:nil forState:UIControlStateNormal];
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = NO;
                    _imageButton4.hidden = NO;
                }
                else{
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = NO;
                    _imageButton4.hidden = YES;
                    
                }
                break;
            case 3:
                
                if( [_imagesArray objectAtIndex:1] != nil){
                    
                    [_imageButton4 setBackgroundImage:[_imagesArray objectAtIndex:3] forState:UIControlStateNormal];
                    [_imageButton4 setTitle:@"" forState:UIControlStateNormal];
                    [_imageButton4 setImage:nil forState:UIControlStateNormal];
                    
                    _imageButton1.hidden = NO;
                    _imageButton2.hidden = NO;
                    _imageButton3.hidden = NO;
                    _imageButton4.hidden = NO;
                }
                else{
                    
                    _imageButton3.hidden = NO;
                    _imageButton3.hidden = NO;
                    _imageButton3.hidden = NO;
                    _imageButton4.hidden = NO;
                    
                }
                break;
                
            default:
                break;
        }
        
        
    }
    
    
}

- (IBAction)imageButton1Pressed:(id)sender {
    
    if(!_imageButton1.imageView.image){
        
        _currentButtonIndex = 0;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 0;
        
        [self showActionSheetWithCameraOptions];
        
    }
}

- (IBAction)imageButton2Pressed:(id)sender {
    
    if(!_imageButton2.imageView.image){
        
        _currentButtonIndex = 1;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 1;
        
        [self showActionSheetWithCameraOptions];
        
    }
}

- (IBAction)imageButton3Pressed:(id)sender {
    
    
    if(!_imageButton3.imageView.image){
        
        _currentButtonIndex = 2;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 2;
        
        [self showActionSheetWithCameraOptions];
        
    }
}

- (IBAction)imageButton4Pressed:(id)sender {
    
    
    if(!_imageButton4.imageView.image){
        
        _currentButtonIndex = 3;
        
        [self showAlertViewWithDeleteOptions];
        
    }
    else{
        
        _currentButtonIndex = 3;
        
        [self showActionSheetWithCameraOptions];
        
    }
}

-(void)showActionSheetWithCameraOptions{
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    action.tag = 0;
    
    [action showInView:self.view];
    
}

-(void)showAlertViewWithDeleteOptions{
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    alert.tag = 1;
    
    [alert show];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 1){
        
        if(buttonIndex == 1){
            
            if(_currentButtonIndex == 0){
                
                [_imagesArray removeObjectAtIndex:0];
                
                [self.imageButton1 setBackgroundImage:nil forState:UIControlStateNormal];
                
                [self.imageButton1 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
                
            }
            else if(_currentButtonIndex == 1){
                
                [_imagesArray removeObjectAtIndex:1];
                
                [self.imageButton2 setBackgroundImage:nil forState:UIControlStateNormal];
                
                [self.imageButton2 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
                
            }
            else if(_currentButtonIndex == 2){
                
                [_imagesArray removeObjectAtIndex:2];
                
                [self.imageButton3 setBackgroundImage:nil forState:UIControlStateNormal];
                
                [self.imageButton3 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
                
            }
            else{
                
                [_imagesArray removeObjectAtIndex:3];
                
                [self.imageButton4 setBackgroundImage:nil forState:UIControlStateNormal];
                
                [self.imageButton4 setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];
                
            }
            
            [self configureImageButtons];
            
        }
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if(actionSheet.tag == 0){
        
        if (buttonIndex != actionSheet.cancelButtonIndex)
        {
            if (buttonIndex == 0)	ShouldStartCamera(self, YES);
            if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
        }
        
    }
    
    else if(actionSheet.tag == 1){
        
        if (buttonIndex != actionSheet.cancelButtonIndex){
            
            if (buttonIndex == 0)	{
                
                _itemPickupField.text = @"包送";
            }
            if (buttonIndex == 1) {
                
                [self tapEventOccured:nil];
                UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
                ActivityLocationViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"ActivityLocationViewController"];
                vc.title = @"自取地点";
                vc.showSearchBar = YES;
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
    }
    else{
        
        if (buttonIndex != actionSheet.cancelButtonIndex){
            
            if (buttonIndex == 0)	{
                
                _itemConditionField.text  = @"全新";
            }
            else if (buttonIndex == 1) {
                
                _itemConditionField.text  = @"半新";
                
            }
            else if (buttonIndex == 2) {
                
                _itemConditionField.text  = @"旧物";
                
            }
        }
        
        
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    
    UIImage *compressedImage = [UIImage imageWithData:UIImageJPEGRepresentation(picture, 0.2)];
    
    if(_currentButtonIndex == 0){
        
        _imageButton2.hidden = NO;
        
        [_imagesArray addObject:compressedImage];
        [_imageButton1 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [_imageButton1 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton1 setImage:nil forState:UIControlStateNormal];
        self.imageButton1.imageView.image = nil;
        
    }
    else if(_currentButtonIndex == 1){
        
        _imageButton3.hidden = NO;
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton2 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton2 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton2 setImage:nil forState:UIControlStateNormal];
        self.imageButton2.imageView.image = nil;
        
        
    }
    else if(_currentButtonIndex == 2){
        
        _imageButton4.hidden = NO;
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton3 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton3 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton3 setImage:nil forState:UIControlStateNormal];
        self.imageButton3.imageView.image = nil;
        
    }
    else if(_currentButtonIndex == 3){
        
        [_imagesArray addObject:compressedImage];
        [self.imageButton4 setBackgroundImage:compressedImage forState:UIControlStateNormal];
        [self.imageButton4 setTitle:@"" forState:UIControlStateNormal];
        [self.imageButton4 setImage:nil forState:UIControlStateNormal];
        self.imageButton4.imageView.image = nil;
        
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


- (void) textFieldDidBeginEditing:(UITextField *)textField{
    
    if(textField == self.itemPriceField || textField == self.itemCategoryField ){
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, - 200,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
    }
    
    if(textField == self.itemPickupField){
        
        [textField resignFirstResponder];
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                   otherButtonTitles:@"包送", @"自取", nil];
        action.tag = 1;
        
        [action showInView:self.view];
        
        
    }
    
    else if(textField == self.itemConditionField){
        
        [textField resignFirstResponder];
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                   otherButtonTitles:@"全新", @"半新",@"旧物" , nil];
        action.tag = 2;
        [action showInView:self.view];
        
        
    }
    
    else if(textField == self.itemCategoryField){
        
        [textField resignFirstResponder];
        
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Post"
                                                      bundle:nil];
        SelectCategoryTableViewController *vc =  [sb instantiateViewControllerWithIdentifier:@"SelectCategoryTableViewController"];
        vc.title = @"Category";
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    
}

- (void)didSelectEventCategory:(NSString *)eventCategory{
    
    _itemCategoryField.text = eventCategory;
}

-(void)didSelectEventLocation:(CLLocation *)eventLocation locationString:(NSString *)eventLocationText{
    
    _itemLocationCoordinate = eventLocation.coordinate;
    
    _itemPickupField.text = [NSString stringWithFormat:@"自取 %@", eventLocationText];
    
}

-(void)tapEventOccured:(id)sender{
    
    [UIView animateWithDuration:.5
                     animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, 0,
                                                               self.view.frame.size.width, self.view.frame.size.height); } ];
    
    for (UIView *subView in self.view.subviews) {
        
        if ([subView isFirstResponder]) {
            
            [subView resignFirstResponder];
            
        }
    }
    
}
@end
