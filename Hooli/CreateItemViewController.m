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
#import "SearchItemViewController.h"
#import "HLConstant.h"
#import "OffersManager.h"
#import "LocationManager.h"
#import "HLUtilities.h"

@interface CreateItemViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,HLActivityLocationDelegate,UITextFieldDelegate,UITextViewDelegate,ShowSearchResultDelegate>
@property (nonatomic) NSMutableArray *imagesArray;
@property (nonatomic,assign) CLLocationCoordinate2D itemLocationCoordinate;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic) NSString *itemCondition;
@property (nonatomic) PFGeoPoint *itemGeoPoint;

@end

@implementation CreateItemViewController
@synthesize currentButtonIndex = _currentButtonIndex;
@synthesize itemContetnTextView = _itemContetnTextView;
@synthesize itemPriceField = _itemPriceField;
@synthesize itemTitleField = _itemTitleField;
@synthesize imagesArray = _imagesArray;
@synthesize itemLocationCoordinate = _itemLocationCoordinate;
@synthesize submitButton= _submitButton;
@synthesize itemCondition = _itemCondition;
@synthesize deliveryLabel = _deliveryLabel;
@synthesize conditionLabel = _conditionLabel;
@synthesize categoryLabel = _categoryLabel;
@synthesize offerObject = _offerObject;
@synthesize itemGeoPoint = _itemGeoPoint;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布物品";
    
    _itemContetnTextView.placeholder = @"必填";
    _itemContetnTextView.textColor = [HLTheme textColor];
    
    _imagesArray = [NSMutableArray new];
    
    _itemTitleField.delegate = self;
    _itemContetnTextView.delegate = self;
    _itemPriceField.delegate = self;
    _itemPriceField.placeholder = @"in US dollar";
    
    _imageButton1.hidden = NO;
    _imageButton2.hidden = YES;
    _imageButton3.hidden = YES;
    _imageButton4.hidden = YES;
    
    [_itemPriceField setKeyboardType:UIKeyboardTypeNumberPad];
    
    [_submitButton setBackgroundColor:[HLTheme mainColor]];
    [_submitButton setTintColor:[UIColor whiteColor]];
    
    [self updateExistingItem];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventOccured:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}


-(void)updateExistingItem{
    
    if(_offerObject){
        
        _itemContetnTextView.text = [_offerObject objectForKey:kHLOfferModelKeyDescription];
        _conditionLabel.text = [_offerObject objectForKey:kHLOfferModelKeyCondition];
        _categoryLabel.text = [_offerObject objectForKey:kHLOfferModelKeyCategory];
        _itemTitleField.text = [_offerObject objectForKey:kHLOfferModelKeyOfferName] ;
        _itemPriceField.text = [[_offerObject objectForKey:kHLOfferModelKeyPrice]substringFromIndex:1];
        _itemGeoPoint = [_offerObject objectForKey:kHLOfferModelKeyGeoPoint];
        
        if(_itemGeoPoint){
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(_itemGeoPoint.latitude, _itemGeoPoint.longitude);
            [[LocationManager sharedInstance]convertGeopointToAddressWithGeoPoint:coord
                                                                            block:^(NSString *address, NSError *error) {
                                                                                
                                                                                _deliveryLabel.text = [NSString stringWithFormat:@"自取:%@",address];
                                                                                
                                                                            }];
        }
        
        PFObject *imagesObject = [_offerObject objectForKey:kHLOfferModelKeyImage];
        PFFile *imageFile0 =[imagesObject objectForKey:@"imageFile0"];
        PFFile *imageFile1 =[imagesObject objectForKey:@"imageFile1"];
        PFFile *imageFile2 =[imagesObject objectForKey:@"imageFile2"];
        PFFile *imageFile3 =[imagesObject objectForKey:@"imageFile3"];
        
        if(imageFile0){
            
            [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                [_imagesArray addObject:[UIImage imageWithData:data]];
                
                self.imageButton1.imageView.image = nil;
                
                [self configureImageButtons];
                
                
            }];
        }
        
        if(imageFile1){
            
            [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                [_imagesArray addObject:[UIImage imageWithData:data]];
                
                self.imageButton2.imageView.image = nil;
                
                [self configureImageButtons];
                
                
            }];
        }
        
        if(imageFile2){
            
            [imageFile2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                [_imagesArray addObject:[UIImage imageWithData:data]];
                
                self.imageButton3.imageView.image = nil;
                
                [self configureImageButtons];
                
                
            }];
            
        }
        
        if(imageFile3){
            
            [imageFile3 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                
                [_imagesArray addObject:[UIImage imageWithData:data]];
                
                self.imageButton4.imageView.image = nil;
                
                [self configureImageButtons];
                
                
            }];
            
        }
        
        [_submitButton setTitle:@"发布更新" forState:UIControlStateNormal];
        
        
    }
}


-(BOOL)checkFieldEmpty{
    
//    if([_itemContetnTextView.text  isEqual: @""] || [_conditionLabel.text  isEqual: @""] || [_categoryLabel.text  isEqual: @""] || [_deliveryLabel.text  isEqual: @""] || [_itemTitleField.text isEqualToString:@""]){
//        
//        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Field missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        
//        [alert show];
//        
//        return NO;
//        
//    }
    
    return YES;
}

-(BOOL)checkImagesEmpty{
    
    if(_imagesArray == nil || [_imagesArray count] == 0){
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Image missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    
    return YES;
}

- (IBAction)submitItem:(id)sender {
    
    if(![self checkFieldEmpty] || ![self checkImagesEmpty]){
        
        return;
    }
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"确定发布？" delegate:self cancelButtonTitle:@"等一会儿" otherButtonTitles:@"是的", nil];
    
    alert.tag = 0;
    
    [alert show];
    
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

- (IBAction)showConditions:(id)sender {
    
    [self resetViews];
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"全新", @"半新",@"旧物" , nil];
    action.tag = 2;
    [action showInView:self.view];
    
}

- (IBAction)showCategories:(id)sender {
    
    [self resetViews];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    SearchItemViewController *vc =  [sb instantiateViewControllerWithIdentifier:@"SearchItemViewController"];
    vc.title = @"Category";
    vc.isMultipleSelection = NO;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)showDelivery:(id)sender {
    
    [self resetViews];
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"包送", @"自取", nil];
    action.tag = 1;
    
    [action showInView:self.view];
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
    
    if(alertView.tag == 0){
        
        
        if(buttonIndex == 1){
            
            NSString *itemName = _itemTitleField.text;
            NSString *itemPrice = [NSString stringWithFormat:@"$%@",_itemPriceField.text];
            NSString *itemCategory = _categoryLabel.text;
            NSString *itemDescription = _itemContetnTextView.text;
            NSString *itemCondtion = _conditionLabel.text;
            
            [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
            
            if(_offerObject){
                
                PFObject *offerImages = [_offerObject objectForKey:kHLOfferModelKeyImage];
                PFObject *offerImageObject = [PFObject objectWithoutDataWithClassName:kHLCloudOfferImagesClass objectId:offerImages.objectId];
                [offerImageObject deleteInBackground];
                
                PFObject *offerImagesClass = [PFObject objectWithClassName:kHLCloudOfferImagesClass];
                for (int i = 0; i <[_imagesArray count]; i++) {
                    
                    if ([_imagesArray objectAtIndex:i]) {
                        
                        NSData *imageData = [HLUtilities compressImage:[_imagesArray objectAtIndex:i] WithCompression:1.0f];
                        PFFile *imageFile = [PFFile fileWithName:@"ImageFile.jpg" data:imageData];
                        [offerImagesClass setObject:imageFile forKey:[NSString stringWithFormat:@"imageFile%d",i]];
                    }
                    
                }
                [offerImagesClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if(succeeded){
                        
                        PFObject *offerObject = [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:_offerObject.objectId];
                        [offerObject setObject:itemName forKey:kHLOfferModelKeyOfferName];
                        [offerObject setObject:[NSString stringWithFormat:@"$%@", itemPrice]forKey:kHLOfferModelKeyPrice];
                        [offerObject setObject:itemCategory forKey:kHLOfferModelKeyCategory];
                        [offerObject setObject:itemDescription forKey:kHLOfferModelKeyDescription];
                        [offerObject setObject:itemCondtion forKey:kHLOfferModelKeyCondition];
                        [offerObject setObject:[PFUser currentUser] forKey:kHLOfferModelKeyUser];
                        NSData *imageData = [HLUtilities compressImage:[_imagesArray objectAtIndex:0] WithCompression:1.0f];
                        PFFile *thumbnail = [PFFile fileWithName:@"thumbNail.jpg" data:imageData];
                        [offerObject setObject:thumbnail forKey:kHLOfferModelKeyThumbNail];
                        [offerObject setObject:offerImagesClass forKey:kHLOfferModelKeyImage];
                        PFGeoPoint *geopoint = [[PFGeoPoint alloc]init];
                        geopoint.latitude = _itemLocationCoordinate.latitude;
                        geopoint.longitude = _itemLocationCoordinate.longitude;
                        [offerObject setObject:geopoint forKey:kHLOfferModelKeyGeoPoint];
                        [offerObject setObject:[NSNumber numberWithBool:NO] forKey:kHLOfferModelKeyOfferStatus];
                        [offerObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            if(succeeded){
                                
                                UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
                                                                                      message:@"You have successfully post your item!"
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles:nil];
                                [confirmAlert show];
                                
                                [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                                
                            }
                            
                        }];
                    }
                }];
                
            }
            else{
                
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
        }
        
    }
    else if(alertView.tag == 1){
        
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
                
                _deliveryLabel.text = @"包送";
            }
            if (buttonIndex == 1) {
                
                [self tapEventOccured:nil];
                UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
                ActivityLocationViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"ActivityLocationViewController"];
                vc.title = @"Location";
                vc.showSearchBar = YES;
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
    }
    else{
        
        if (buttonIndex != actionSheet.cancelButtonIndex){
            
            if (buttonIndex == 0)	{
                
                _conditionLabel.text  = @"全新";
            }
            else if (buttonIndex == 1) {
                
                _conditionLabel.text  = @"半新";
                
            }
            else if (buttonIndex == 2) {
                
                _conditionLabel.text  = @"旧物";
                
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
    
    
    [UIView animateWithDuration:.5
                     animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, - 80,
                                                               self.view.frame.size.width, self.view.frame.size.height); } ];
    
    
    
}

-(void)resetViews{
    
    for (UIView *subView in self.view.subviews) {
        
        if ([subView isFirstResponder]) {
            
            [subView resignFirstResponder];
            
        }
    }
    
    [UIView animateWithDuration:.5
                     animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x,  0,
                                                               self.view.frame.size.width, self.view.frame.size.height); } ];
    
}


-(void)didSelectItemCategory:(NSString *)itemCategory{
    
    _categoryLabel.text = itemCategory;
    
}

-(void)didSelectLocation:(CLLocation *)location locationString:(NSString *)locationText{
    
    _itemLocationCoordinate = location.coordinate;
    
    _deliveryLabel.text = [NSString stringWithFormat:@"自取 %@", locationText];
    
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
