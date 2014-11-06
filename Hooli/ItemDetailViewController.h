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
@interface ItemDetailViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) NSString *offerId;
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
@property (weak, nonatomic) IBOutlet UIButton *askQuestionButton;
- (IBAction)askQuestion:(id)sender;
@property (weak, nonatomic) IBOutlet SMPageControl *pageControl;
- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *seeMapButton;
- (IBAction)seeMapButtonClicked:(id)sender;
@end
