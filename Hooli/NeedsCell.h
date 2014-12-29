//
//  NeedsCell.h
//  Hooli
//
//  Created by Er Li on 12/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeedsModel.h"

@interface NeedsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *portraitImage;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *needsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic,strong) NSString *needId;


-(void)updateCellWithNeedModel:(NeedsModel *)needModel;

@end
