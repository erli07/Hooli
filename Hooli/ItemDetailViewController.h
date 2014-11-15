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
@protocol UpdateCollectionViewDelegate;


@interface ItemDetailViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate>{
    
    __weak id <UpdateCollectionViewDelegate> updateCollectionViewDelegate;

}
@property (nonatomic, weak) id <UpdateCollectionViewDelegate> updateCollectionViewDelegate;
@property (nonatomic, strong) NSString *offerId;
@property (weak, nonatomic) IBOutlet UIView *offerDetailView;
@property (nonatomic, strong) OfferModel *offerObject;
@property (nonatomic, strong) NSString *userID;
@property (weak, nonatomic) IBOutlet UIView *bottomButtonsView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *parentScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet SMPageControl *pageControl;
- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *seeMapButton;
- (IBAction)seeMapButtonClicked:(id)sender;
@end

@protocol  UpdateCollectionViewDelegate <NSObject>

-(void)updateCollectionViewData;

@end