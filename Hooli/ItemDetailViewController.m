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
#import "ActivityManager.h"
#define kScrollViewOffset 44
#define kBottomButtonOffset 44

@interface ItemDetailViewController ()<MFMailComposeViewControllerDelegate>
{
    MBProgressHUD *HUD;
    BOOL toggleIsOn;
}
@property (nonatomic) CLLocationCoordinate2D offerLocation;

@end

@implementation ItemDetailViewController
@synthesize offerId,offerObject,locationLabel,offerDescription,itemNameLabel,categoryLabel,likeButton,offerLocation,updateCollectionViewDelegate,bottomButtonsView;
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
    
 
}

-(void)deleteSelf{
    
    
    UIAlertView *deleteAlert = [[UIAlertView alloc]initWithTitle:@"Delete this offer?" message:@"Are you sure you want to delete this offer?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [deleteAlert show];
    
    
}

-(void)updateOfferDetailInfo:(OfferModel *)offerModel{
    
    self.tabBarController.tabBar.hidden=YES;
    
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
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:offerModel.user.objectId Success:^(id object) {
        
        self.profilePicture.image = (UIImage *)object;
        
    } Failure:^(id error) {
        
        NSLog(@"%@",error);
        
    }];
    
    [[ActivityManager sharedInstance]isOfferLikedByCurrentUser:self.offerObject block:^(BOOL succeeded, NSError *error) {
        
        if(succeeded){
            
            toggleIsOn = NO;
        }
        else{
            
            toggleIsOn = YES;
        }
        
        [self.likeButton setTitle:toggleIsOn ? @"Like" :@"Dislike" forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:toggleIsOn ? @"button-pressed.png" :@"button.png"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:toggleIsOn?[UIColor whiteColor]:[HLTheme mainColor] forState:UIControlStateNormal];
        
    }];
    
    CGRect newFrame = self.contentView.frame;
    newFrame.size.height = self.offerDescription.frame.size.height + self.offerDescription.frame.origin.y + kScrollViewOffset;
    self.contentView.frame = newFrame;
    [self.parentScrollView setContentSize:newFrame.size];

    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.masksToBounds = YES;
    
    [self setOffersScrollViewWithImageArray:offerModel.imageArray];
    self.offerLocation = offerModel.offerLocation;
    
}


-(void)configureUIElements{
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"Item Detail";
    
    [self.parentScrollView setScrollEnabled:YES];
    [self.parentScrollView setContentSize:self.contentView.frame.size];
    
    //    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"button-pressed"] forState:UIControlStateNormal];
    //    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
    //    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
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
        CGRect frame = CGRectMake(scrollContentWidth + padding + 30, (self.scrollView.bounds.size.height - scrollHeight)/2, 200, scrollHeight);
        
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
        
        PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass
                                                           objectId:self.offerId];
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){
                [HUD hide:YES];
                
                //    [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.reloadHomeData" object:self];
                //     [[NSNotificationCenter defaultCenter] postNotificationName:@"Hooli.reloadMyCartData" object:self];
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
    
        if(toggleIsOn){
            
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
    
        [self.likeButton setTitle:toggleIsOn ? @"Like" :@"Dislike" forState:UIControlStateNormal];
    [self.likeButton setBackgroundImage:[UIImage imageNamed:toggleIsOn ? @"button-pressed.png" :@"button.png"] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:toggleIsOn?[UIColor whiteColor]:[HLTheme mainColor] forState:UIControlStateNormal];
    
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
