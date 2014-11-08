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
@interface ItemDetailViewController ()<MFMailComposeViewControllerDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) PFObject *offerObject;

@end

@implementation ItemDetailViewController
@synthesize offerId,offerObject,locationLabel,offerDescription,itemNameLabel,categoryLabel,updateCollectionViewDelegate;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    self.title = @"Item Detail";
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Delete"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(deleteSelf)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [[OffersManager sharedInstance]fetchOfferByID:self.offerId
                                          withSuccess:^(id downloadObject) {
                                              
                                              // Dispatch to main thread to update the UI
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  self.offerObject = (PFObject *)downloadObject;
                                                  
                                                  [self configureUIElements];
                                                  
                                                  [self updateOfferDetailInfo];
                                                  
                                                  [HUD hide:YES];
                                                  
                                              });
                                              
                                          } failure:^(id error) {
                                              
                                              NSLog(@"%@",[error description]);
                                              
                                              [HUD hide:YES];
                                              
                                          }];
        
    });
    
    
    // Do any additional setup after loading the view.
}

-(void)deleteSelf{
    
    
    UIAlertView *deleteAlert = [[UIAlertView alloc]initWithTitle:@"Delete this offer?" message:@"Are you sure you want to delete this offer?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [deleteAlert show];
    
    
}

-(void)updateOfferDetailInfo{
    
    OfferModel *offerModel = [[OfferModel alloc]initOfferDetailsWithPFObject:self.offerObject];
    
    self.itemNameLabel.text =  offerModel.offerName;
    
    NSString *distanceText = [[LocationManager sharedInstance]getApproximateDistance:offerModel.offerLocation];
    self.locationLabel.text = [NSString stringWithFormat:@"Location: %@", distanceText];
    self.categoryLabel.text = [NSString stringWithFormat:@"In %@",offerModel.offerCategory];
    self.offerDescription.text = offerModel.offerDescription;
    self.priceLabel.text = offerModel.offerPrice;
    
    [[AccountManager sharedInstance]setUserProfilePicture:self.profilePicture];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.masksToBounds = YES;
    
    [self setOffersScrollViewWithImageArray:offerModel.imageArray];
    
}


-(void)configureUIElements{
    
    
    [self.parentScrollView setScrollEnabled:YES];
    [self.parentScrollView setContentSize:self.contentView.frame.size];
    
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"button-pressed"] forState:UIControlStateHighlighted];
    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    UIImage* buttonImage = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage* buttonPressedImage = [[UIImage imageNamed:@"button-pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.addToCartButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    self.addToCartButton.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:18.0f];
    
    self.itemNameLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    self.offerDescription.font = [UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    self.locationLabel.font =[UIFont fontWithName:[HLTheme mainFont] size:15.0f];
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

- (IBAction)addToCart:(id)sender {
    
    
}
- (IBAction)seeMapButtonClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"map" sender:self];
    
    
}
- (IBAction)askQuestion:(id)sender {
    
    MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
    mailVC.mailComposeDelegate = self;
    [mailVC setSubject:@"My Subject"];
    [mailVC setMessageBody:@"Hello there." isHTML:NO];
    [mailVC setToRecipients:[NSArray arrayWithObject:@"123@gmail.com"]];
    
    if (mailVC)
        
        [self presentViewController:mailVC animated:YES completion:^{
            
        }];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
