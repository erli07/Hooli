//
//  ShoppingItemCell.h
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingItemCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView* productImageView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* priceLabel;
@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* likesLabel;
@property (nonatomic, weak) IBOutlet UILabel* viewsLabel;
@property (nonatomic, weak) IBOutlet UIButton* likesButton;
@property (nonatomic, weak) IBOutlet UIButton* viewsButton;

- (IBAction)viewButtonClicked:(id)sender;

- (IBAction)likesButtonClicked:(id)sender;

-(void)updateCellWithData:(NSDictionary*)data;
@end
