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

@interface CreateItemViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,HLActivityLocationDelegate,UITextFieldDelegate,UITextViewDelegate,ShowSearchResultDelegate,UIGestureRecognizerDelegate>
@property (nonatomic) NSMutableArray *imagesArray;
@property (nonatomic,assign) CLLocationCoordinate2D itemLocationCoordinate;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic) NSString *itemCondition;
@property (nonatomic) PFGeoPoint *itemGeoPoint;
@property (nonatomic,strong) UIButton *addItemButton;
@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) GCPlaceholderTextView *descriptionTextView;
@property (nonatomic) UITextField *priceTextField;
@property (nonatomic) BOOL isEditing;
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
@synthesize postDetailTableView = _postDetailTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Post Item";
    
    _itemContetnTextView.placeholder = @"";
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
    
    _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
    [_submitButton setTitle:@"Post" forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitItem:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_submitButton];
    [_submitButton setBackgroundColor:[HLTheme mainColor]];
    [_submitButton setTintColor:[UIColor whiteColor]];
    
    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventOccured:)];
//    tapGestureRecognizer.numberOfTapsRequired = 1;
//    tapGestureRecognizer.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self updateExistingItem];

}

-(void)updateExistingItem{
    
    if(_offerObject ){
        
        self.descriptionTextView.text = [_offerObject objectForKey:kHLOfferModelKeyDescription];
        _conditionLabel.text = [_offerObject objectForKey:kHLOfferModelKeyCondition];
        _categoryLabel.text = [_offerObject objectForKey:kHLOfferModelKeyCategory];
        self.titleTextField.text = [_offerObject objectForKey:kHLOfferModelKeyOfferName] ;
        self.priceTextField.text = [_offerObject objectForKey:kHLOfferModelKeyPrice];        _itemGeoPoint = [_offerObject objectForKey:kHLOfferModelKeyGeoPoint];
        
        if(_itemGeoPoint){
            
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(_itemGeoPoint.latitude, _itemGeoPoint.longitude);
            [[LocationManager sharedInstance]convertGeopointToAddressWithGeoPoint:coord
                                                                            block:^(NSString *address, NSError *error) {
                                                                                
                                                                                _deliveryLabel.text = [NSString stringWithFormat:@"%@",address];
                                                                                
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
        
        [_submitButton setTitle:@"Submit Update" forState:UIControlStateNormal];
        
        
    }
}


-(BOOL)checkFieldEmpty{
    
    if([self.descriptionTextView.text  isEqual: @""] || [_conditionLabel.text  isEqual: @""] || [_categoryLabel.text  isEqual: @""] || [self.deliveryLabel.text  isEqual: @""] || [self.titleTextField.text isEqualToString:@""]){
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Field missing!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
        
    }
    
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

- (void)submitItem:(id)sender {
    
    if(![self checkFieldEmpty] || ![self checkImagesEmpty]){
        
        return;
    }
    
    UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Post？" delegate:self cancelButtonTitle:@"Wait" otherButtonTitles:@"Yes", nil];
    
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

- (void)showConditions:(id)sender {
    
    [self resetViews];
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"New", @"Half new",@"Old" , nil];
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

- (void)showDelivery:(id)sender {
    
    [self resetViews];
    
    [self tapEventOccured:nil];
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    ActivityLocationViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"ActivityLocationViewController"];
    vc.title = @"Location";
    vc.showSearchBar = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
//    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
//                                               otherButtonTitles:@"包送", @"自取", nil];
//    action.tag = 1;
//    
//    [action showInView:self.view];
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

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_postDetailTableView]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

-(void)tapEventOccured:(UIGestureRecognizer *)gesture{
    
    [self resetViews];
    
}

#pragma mark UITableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self resetViews];
    
    if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            [self showDelivery:nil];
            
        }
        else if(indexPath.row == 1){
            
            [self showConditions:nil];
            
        }
        else if (indexPath.row == 2){
            
            [self showCategories:nil];
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postItemCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"Title";
            
            self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 2, SCREEN_WIDTH - 100 , 40)];
            
            self.titleTextField.placeholder = @"Enter title";
            
            [self.titleTextField setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
            
            [self.titleTextField setDelegate:self];
            
            [cell addSubview:self.titleTextField];
            
        }
        else if(indexPath.row == 1){
            
            cell.textLabel.text = @"Description";
            
            self.descriptionTextView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(96, 2, SCREEN_WIDTH - 100 , 96)];
            
            self.descriptionTextView.placeholder = @"Enter description";
            
            [self.descriptionTextView setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
            
            [self.descriptionTextView setDelegate:self];
            
            [cell addSubview:self.descriptionTextView];
            
        }
        else if(indexPath.row == 2){
            
            cell.textLabel.text = @"Price($)";
            
            self.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 2, SCREEN_WIDTH - 100 , 40)];
            
            self.priceTextField.placeholder = @"Enter price in dollar";
            
            [self.priceTextField setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
            
            [self.priceTextField setDelegate:self];
            
            [cell addSubview:self.priceTextField];
            
        }

        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"Location";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!self.deliveryLabel) {
                
                self.deliveryLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 40)];
                [self.deliveryLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                [cell addSubview:self.deliveryLabel];
                
            }
        }
        else if(indexPath.row == 1){
            
            cell.textLabel.text = @"Condition";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if (!self.conditionLabel) {
                
                self.conditionLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 40)];
                [self.conditionLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                [cell addSubview:self.conditionLabel];
                
            }
        }
        else{
            
            if (!self.categoryLabel) {
                
                self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(98, 2, SCREEN_WIDTH - 100 , 40)];
                [self.categoryLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
                [cell addSubview:self.categoryLabel];
                
            }
            
            cell.textLabel.text = @"Category";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }
    }

    
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 3;
    else
        return 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        if(indexPath.row == 1){
            
            return  120;
        }
        
    }

    
    return 44;
}

#pragma mark UIAlert

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 0){
        
        if(buttonIndex == 1){
            
            NSString *itemName = self.titleTextField.text;
            NSString *itemPrice = [NSString stringWithFormat:@"%@",self.priceTextField.text];
            NSString *itemCategory = _categoryLabel.text;
            NSString *itemDescription = self.descriptionTextView.text;
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
                        [offerObject setObject:itemPrice forKey:kHLOfferModelKeyPrice];
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
                    
                    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
                    vc.selectedIndex = 1;
                    [self presentViewController:vc animated:YES completion:^{
                        
                    }];
                
//                    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
//                    ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
//                    vc.offerObject = offer;
//                    vc.isFirstPosted = YES;
//                    vc.hidesBottomBarWhenPushed = YES;
//                    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//                    [self.navigationController pushViewController:vc animated:YES];
                    
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
            
//            if (buttonIndex == 0)	{
//                
//                _deliveryLabel.text = @"包送";
//            }
//            if (buttonIndex == 1) {
//                
//                [self tapEventOccured:nil];
//                UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
//                ActivityLocationViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"ActivityLocationViewController"];
//                vc.title = @"自取地点";
//                vc.showSearchBar = YES;
//                vc.delegate = self;
//                [self.navigationController pushViewController:vc animated:YES];
//                
//            }
        }
    }
    else{
        
        if (buttonIndex != actionSheet.cancelButtonIndex){
            
            if (buttonIndex == 0)	{
                
                _conditionLabel.text  = @"New";
            }
            else if (buttonIndex == 1) {
                
                _conditionLabel.text  = @"Half New";
                
            }
            else if (buttonIndex == 2) {
                
                _conditionLabel.text  = @"Old";
                
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



- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == self.priceTextField){
        
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [textField setKeyboardAppearance:UIKeyboardAppearanceLight];
        
        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        
        [keyboardDoneButtonView sizeToFit];
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Free"
                                                                       style:UIBarButtonItemStylePlain target:self
                                                                      action:@selector(setPriceFree)];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        
        textField.inputAccessoryView = keyboardDoneButtonView;
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, -100 ,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
        
        
    }
    
    else{
        
        [UIView animateWithDuration:.5
                         animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x, -100 ,
                                                                   self.view.frame.size.width, self.view.frame.size.height); } ];
    }
    
    
}

-(void)setPriceFree{
    
    [self resetViews];
    
    self.priceTextField.text = @"Free";
    
}


-(void)resetViews{
    
    for (UIView *subView in self.view.subviews) {
        
        if ([subView isFirstResponder]) {
            
            [subView resignFirstResponder];
            
        }
    }
    
    if([self.descriptionTextView isFirstResponder])
       [self.descriptionTextView resignFirstResponder];
    else if([self.titleTextField isFirstResponder])
        [self.titleTextField resignFirstResponder];
    else if([self.priceTextField isFirstResponder])
        [self.priceTextField resignFirstResponder];
        
    
    [UIView animateWithDuration:.5
                     animations:^{self.view.frame = CGRectMake(self.view.frame.origin.x,  0,
                                                               self.view.frame.size.width, self.view.frame.size.height); } ];
    
}


-(void)didSelectItemCategory:(NSString *)itemCategory{
    
    _categoryLabel.text = itemCategory;
    
}

-(void)didSelectLocation:(CLLocation *)location locationString:(NSString *)locationText{
    
    _itemLocationCoordinate = location.coordinate;
    
    _deliveryLabel.text = [NSString stringWithFormat:@"%@", locationText];
    
}

@end
