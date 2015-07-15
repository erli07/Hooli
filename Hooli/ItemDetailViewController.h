//
//  ItemDetailViewController.h
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
#import <MessageUI/MessageUI.h>
#import "OfferModel.h"
#import "ItemCommentViewController.h"

@protocol UpdateCollectionViewDelegate;


@interface ItemDetailViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>{
    
    __weak id <UpdateCollectionViewDelegate> updateCollectionViewDelegate;

}
@property (nonatomic, weak) id <UpdateCollectionViewDelegate> updateCollectionViewDelegate;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (nonatomic, strong) NSString *offerId;
@property (weak, nonatomic) IBOutlet UIScrollView *offerDetailView;
@property (nonatomic, strong) OfferModel *offerObject;
@property (weak, nonatomic) IBOutlet UIImageView *soldImageView;
@property (nonatomic, strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *topDetailBar;
@property (weak, nonatomic) IBOutlet UIView *likeView;
@property (nonatomic, strong) ItemCommentViewController *commentVC;
@property (weak, nonatomic) IBOutlet SMPageControl *pageControl;
@property (nonatomic, assign) BOOL isFirstPosted;
@property (weak, nonatomic) IBOutlet UIButton *makeOfferButton;
- (IBAction)makeOffer:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *seeMapButton;
- (IBAction)seeMapButtonClicked:(id)sender;
-(void)getOfferDetailsFromCloud;
-(void)refreshOfferDetailsFromCloud;

@property (weak, nonatomic) IBOutlet UIButton *showBidButton;
- (IBAction)showBidHistory:(id)sender;


@end

@protocol  UpdateCollectionViewDelegate <NSObject>

-(void)updateCollectionViewData;

@end