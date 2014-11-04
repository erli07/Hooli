//
//  ItemCell.h
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIImageView* productImageView;
@property (nonatomic, weak) IBOutlet UILabel* titleLabel;
@property (nonatomic, weak) IBOutlet UILabel* priceLabel;
@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* likesLabel;
@property (nonatomic, weak) IBOutlet UIButton* likesButton;


- (IBAction)likesButtonClicked:(id)sender;

-(void)updateCellWithData:(NSDictionary*)data;

-(void)updateCellWithRetrievedData:(NSDictionary *)data;
@end
