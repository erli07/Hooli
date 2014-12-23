//
//  ItemDetailViewController.m
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "OffersManager.h"
#import "AccountManager.h"
#import <Parse/Parse.h>
#import "LocationManager.h"
#import "HLConstant.h"
#import "MBProgressHUD.h"
#import "HLSettings.h"
#import "MapViewController.h"
#import "UserCartViewController.h"
#import "ActivityManager.h"
#import "NSString+MD5.h"
#import "ChatViewController.h"


#define kScrollViewOffset 44
#define kBottomButtonOffset 44

@interface ItemDetailViewController ()<MFMailComposeViewControllerDelegate>
{
    MBProgressHUD *HUD;
    BOOL toggleIsOn;
}
@property (nonatomic) CLLocationCoordinate2D offerLocation;
@property (nonatomic) BOOL toggleIsOn;
@end

@implementation ItemDetailViewController
@synthesize offerId,offerObject,locationLabel,offerDescription,itemNameLabel,categoryLabel,likeButton,offerLocation,updateCollectionViewDelegate,bottomButtonsView,userID,soldImageView;
- (void)viewDidLoad {
    
    [super viewDidLoad];
        
    [self configureUIElements];
    
    if(!self.offerObject){
        
        self.bottomButtonsView.hidden = NO;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD show:YES];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            [[OffersManager sharedInstance]fetchOfferByID:self.offerId
                                              withSuccess:^(id downloadObject) {
                                                  
                                                  // Dispatch to main thread to update the UI
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      
                                                      self.offerObject = [[OfferModel alloc]initOfferDetailsWithPFObject:(PFObject *)downloadObject];
                                                      
                                                      [self updateOfferDetailInfo:self.offerObject];
                                                      
                                                      [HUD hide:YES];
                                                      
                                                  });
                                                  
                                              } failure:^(id error) {
                                                  
                                                  NSLog(@"%@",[error description]);
                                                  
                                                  [HUD hide:YES];
                                                  
                                              }];
            
        });
        
    }else{
        
        self.bottomButtonsView.hidden = YES;
        
        [self.parentScrollView setContentSize:self.contentView.frame.size];
        
        [self updateOfferDetailInfo:self.offerObject];
        
    }
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self setNavBarVisible:YES animated:NO];
    
}

- (void)setNavBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self navBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat height = frame.size.height + 20;
    CGFloat offsetY = (visible)? height : -height;
    
    self.navigationController.navigationBar.frame = CGRectOffset(frame, 0, offsetY);
    
    
}

// know the current state
- (BOOL)navBarIsVisible {
    
    return self.navigationController.navigationBar.frame.origin.y >= 0;
    
}

-(void)deleteSelf{
    
    
    UIAlertView *deleteAlert = [[UIAlertView alloc]initWithTitle:@"Delete this offer?" message:@"Are you sure you want to delete this offer?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [deleteAlert show];
    
    
}

-(void)updateOfferDetailInfo:(OfferModel *)offerModel{
    
    if ([[[self.offerObject user]objectId] isEqualToString:[[PFUser currentUser]objectId]]) {
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Delete"
                                           style:UIBarButtonItemStyleDone
                                           target:self
                                           action:@selector(deleteSelf)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
    }
    
    
    self.itemNameLabel.text =  offerModel.offerName;
    
    NSString *distanceText = [[LocationManager sharedInstance]getApproximateDistance:offerModel.offerLocation];
    self.locationLabel.text = [NSString stringWithFormat:@"Location: %@", distanceText];
    self.categoryLabel.text = [NSString stringWithFormat:@"In %@",offerModel.offerCategory];
    self.offerDescription.text = offerModel.offerDescription;
    [self.offerDescription sizeToFit];
    self.priceLabel.text = offerModel.offerPrice;
    
    if([offerModel.isOfferSold boolValue]){
        
        self.soldImageView.image = [UIImage imageNamed:@"sold"];
        self.bottomButtonsView.hidden = YES;
        
    }
    else{
        
        self.bottomButtonsView.hidden = NO;
        self.soldImageView.image = nil;
    }
    
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:offerModel.user.objectId Success:^(id object) {
        
        
        UserModel *userModel = (UserModel *)object;
        
        self.profilePicture.image = userModel.portraitImage;
        
        
    } Failure:^(id error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    
    CGRect newFrame = self.contentView.frame;
    newFrame.size.height = self.offerDescription.frame.size.height + self.offerDescription.frame.origin.y + kScrollViewOffset;
    self.contentView.frame = newFrame;
    [self.parentScrollView setContentSize:newFrame.size];
    
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.masksToBounds = YES;
    
    [self setOffersScrollViewWithImageArray:offerModel.imageArray];
    self.offerLocation = offerModel.offerLocation;
    
    self.userID = offerModel.user.objectId;
    
    UITapGestureRecognizer *tapPortrait = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(seeItemOwner)];
    
    [self.profilePicture addGestureRecognizer:tapPortrait];
    tapPortrait.numberOfTapsRequired = 1;
    self.profilePicture.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapCategory = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(seeCategory)];
    
    [self.categoryLabel addGestureRecognizer:tapCategory];
    tapCategory.numberOfTapsRequired = 1;
    self.categoryLabel.userInteractionEnabled = YES;
    
    if(offerModel.offerId){
        
        [[ActivityManager sharedInstance]isOfferLikedByCurrentUser:offerModel block:^(BOOL succeeded, NSError *error) {
            
            toggleIsOn = succeeded;
            [self updateLikeButtonImage:!succeeded];
            
        }];
        
    }

}


-(void)configureUIElements{
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"Item Detail";
    
    [self.parentScrollView setScrollEnabled:YES];
    [self.parentScrollView setContentSize:self.contentView.frame.size];
    
    UIImage* buttonImage = [[UIImage imageNamed:@"button-pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage* buttonPressedImage = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.addToCartButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    self.addToCartButton.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:18.0f];
    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addToCartButton setTitleColor:[HLTheme mainColor] forState:UIControlStateHighlighted];
    
    [self.likeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.likeButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    self.likeButton.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:18.0f];
    [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[HLTheme mainColor] forState:UIControlStateHighlighted];
    
    self.itemNameLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    self.offerDescription.font = [UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    self.locationLabel.font =[UIFont fontWithName:[HLTheme boldFont] size:15.0f];
    self.categoryLabel.font =[UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    
    
    
}

-(void)seeItemOwner{
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userCart"];
    vc.userID = self.userID;
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)seeCategory{
    
    NSDictionary *filterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kHLFilterDictionarySearchKeyCategory, kHLFilterDictionarySearchType,
                                      self.offerObject.offerCategory,kHLFilterDictionarySearchKeyCategory,nil];
    
    [[OffersManager sharedInstance]setFilterDictionary:filterDictionary];
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserCartViewController *vc = [mainSb instantiateViewControllerWithIdentifier:@"searchResult"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.pageControl.currentPage = ceil(scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    
}


-(void)setOffersScrollViewWithImageArray:(NSArray *)imagesArray{
    
    [self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot"]];
    [self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot-selected"]];
    self.pageControl.numberOfPages = imagesArray.count;
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.scrollView.delegate = self;
    
    CGFloat scrollContentWidth = 0;
    CGFloat scrollHeight = self.scrollView.bounds.size.height; // -20;
    CGFloat padding = (self.scrollView.bounds.size.width - scrollHeight) / 2;
    for (UIImage *image in imagesArray) {
        
        CGRect frame = CGRectMake(scrollContentWidth + padding + 30 , (self.scrollView.bounds.size.height - scrollHeight)/2, 200, 260);
        
        UIImageView *preview = [[UIImageView alloc] initWithFrame:frame];
        preview.image = image;
        
        scrollContentWidth += self.scrollView.bounds.size.width;
        
        [self.scrollView addSubview:preview];
    }
    
    self.scrollView.contentSize = CGSizeMake(scrollContentWidth, scrollHeight);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    [self scrollViewDidEndDecelerating:self.scrollView];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex== 1){
        
        [HUD show:YES];
        [[OffersManager sharedInstance]deleteOfferModelWithOfferId:self.offerId block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                [HUD hide:YES];
                [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                NSLog(@"Delete self error %@", [error description]);
                
            }
            
        }];
        
    }
    else{
        
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)likeButtonPressed:(id)sender {
    
    [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
    
    if(!toggleIsOn){
        
        [[ActivityManager sharedInstance]likeOfferInBackground:self.offerObject block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                NSLog(@"Like Success!");
                
            }
            else{
                
                NSLog(@"%@",[error description]);
            }
        }];
    }
    else {
        
        [[ActivityManager sharedInstance]dislikeOfferInBackground:self.offerObject block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                NSLog(@"dislike Success!");
                
            }
            else{
                
                NSLog(@"%@",[error description]);
            }
        }];
    }
    
    toggleIsOn = !toggleIsOn;
    
    [self updateLikeButtonImage:!toggleIsOn];
    
    [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
    
    
}

-(void)updateLikeButtonImage:(BOOL)flag{
    
    [self.likeButton setTitle:flag ? @"Like" :@"Dislike" forState:UIControlStateNormal];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:flag ? @"button-pressed.png" :@"button.png"] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:flag?[UIColor whiteColor]:[HLTheme mainColor] forState:UIControlStateNormal];
    
    
}

- (IBAction)contactSeller:(id)sender {
    
    __weak ItemDetailViewController *weakSelf = self;
    
    EMConversation *conversation = [[EMConversation alloc]init];
    conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:[self.offerObject.user.objectId MD5] isGroup:NO];
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:self.offerObject.user.objectId Success:^(id object) {
        
        
        
        UserModel *userModel = (UserModel *)object;
        PFUser *user = [PFUser currentUser];
        PFFile *theImage = [user objectForKey:kHLUserModelKeyPortraitImage];
        NSData *imageData = [theImage getData];
        UIImage *portraitImage = [UIImage imageWithData:imageData];
        
        ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:conversation.chatter isGroup:conversation.isGroup];
        
        chatVC.receiver = [[ChatterObject alloc]initWithChatterID:conversation.chatter username:userModel.username portrait: userModel.portraitImage isSender:YES];
        
        chatVC.sender = [[ChatterObject alloc]initWithChatterID:[user.objectId MD5] username:user.username portrait:portraitImage isSender:NO];
        
        chatVC.title = userModel.username;
        chatVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:chatVC animated:YES];
        
        
    } Failure:^(id error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
    
    
}

- (IBAction)addToCart:(id)sender {
    
    MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setSubject:@"My Subject"];
    [mailVC setMessageBody:@"Hello there." isHTML:NO];
    [mailVC setToRecipients:[NSArray arrayWithObject:@"123@gmail.com"]];
    
    if (mailVC)
        
        [self presentViewController:mailVC animated:YES completion:^{
            
        }];
    
}
- (IBAction)seeMapButtonClicked:(id)sender {
    
    
    [self performSegueWithIdentifier:@"map" sender:self];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"map"])
    {
        MapViewController *map = segue.destinationViewController;
        map.offerLocation = self.offerLocation;
    }
    
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
