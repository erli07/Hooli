//
//  ItemCell.h
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferModel.h"
@interface ItemCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView* productImageView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* priceLabel;
@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* likesLabel;
@property (nonatomic, weak) IBOutlet UIButton* likesButton;
@property (weak, nonatomic) IBOutlet UIImageView *distanceBackground;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) NSString *offerId;
@property (weak, nonatomic) IBOutlet UIImageView *shadowView;

- (IBAction)likesButtonClicked:(id)sender;

-(void)updateCellWithData:(NSDictionary*)data;
-(void)updateCellWithOfferModel:(OfferModel *)offerModel;

-(void)updateCellWithRetrievedData:(NSDictionary *)data;
@end
