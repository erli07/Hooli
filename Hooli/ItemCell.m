//
//  ItemCell.m
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ItemCell.h"
#import "HLTheme.h"
#import "LocationManager.h"
#import "ItemDetailViewController.h"
#import "ActivityManager.h"
@implementation ItemCell

@synthesize productImageView,distanceLabel,distanceBackground,offerId;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    

//    self.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:11.0f];
//    self.timeLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
    self.likesLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
    self.distanceBackground.layer.cornerRadius = self.distanceBackground.frame.size.height/2;
    self.distanceBackground.layer.masksToBounds = YES;
    self.contentView.tintColor = [HLTheme mainColor];
    
//    self.titleLabel.textColor = [UIColor blackColor];
//    self.timeLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.likesLabel.textColor = [HLTheme mainColor];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.shadowView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.shadowView.layer insertSublayer:gradient atIndex:0];
    
    
}

//-(void)updateCellWithData:(NSDictionary*)data{
//    
//    self.productImageView.image = [UIImage imageNamed:data[@"image"]];
//    self.priceLabel.text = data[@"price"];
//    self.titleLabel.text = data[@"company"];
//    self.timeLabel.text = data[@"dates"];
//    self.likesLabel.text = data[@"hearts"];
//    
//}

-(void)updateCellWithOfferModel:(OfferModel *)offerModel{
    
    self.productImageView.image = offerModel.image;
    
    self.distanceLabel.text =[[LocationManager sharedInstance]getApproximateDistance:offerModel.offerLocation];
    
    self.offerId = offerModel.offerId;
    
    [[ActivityManager sharedInstance]setOfferLikesCount:self.likesLabel withOffer:offerModel];
    
    self.priceLabel.text = offerModel.offerPrice;
    
}



- (IBAction)likesButtonClicked:(id)sender {
    
    NSLog(@"Like button clicked");
}


@end
