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

@synthesize productImageView,distanceLabel,distanceBackground,offerId,soldImage,isOfferSold;

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
    self.productImageView.layer.cornerRadius = 10.0f;
    self.productImageView.layer.masksToBounds = YES;
    self.shadowView.layer.cornerRadius = 10.0f;
    self.shadowView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;    //    self.titleLabel.textColor = [UIColor blackColor];
    //    self.timeLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.likesLabel.textColor = [UIColor colorWithRed:(253.0/255.0) green:(92.0/255.0) blue:(89.0/255.0) alpha:1.0];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.shadowView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [self.shadowView.layer insertSublayer:gradient atIndex:0];
    self.soldImage.image = nil;
    
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

-(void)updateCellWithOfferSoldStatus:(OfferModel *)offerModel{
    
    if([offerModel.isOfferSold boolValue]){
        
        self.soldImage.image = [UIImage imageNamed:@"sold"];
        
    }
    else{
        
        self.soldImage.image = nil;
    }
    
    self.isOfferSold = [offerModel.isOfferSold boolValue];
    
}

-(void)updateCellWithOfferModel:(OfferModel *)offerModel{
    
    
        [offerModel.theImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if(!error){
                
                self.productImageView.image = [UIImage imageWithData:data];
                
            }
        }];
        
        self.distanceLabel.text =[[LocationManager sharedInstance]getApproximateDistance:offerModel.offerLocation];
        
        self.offerId = offerModel.offerId;
        
        self.priceLabel.text = offerModel.offerPrice;
    
    [[ActivityManager sharedInstance]setOfferLikesCount:self.likesLabel withOffer:offerModel];
    
    [self updateCellWithOfferSoldStatus:offerModel];
    
}



- (IBAction)likesButtonClicked:(id)sender {
    
    NSLog(@"Like button clicked");
}


@end
