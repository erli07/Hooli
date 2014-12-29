//
//  NeedsCell.m
//  Hooli
//
//  Created by Er Li on 12/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedsCell.h"
#import "LocationManager.h"
#import "HLConstant.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation NeedsCell
@synthesize needId;

-(void)updateCellWithNeedModel:(NeedsModel *)needModel{
    
   // PFFile *theImage = [needModel.user objectForKey:kHLUserModelKeyPortraitImage];

//    [self.portraitImage sd_setImageWithURL: [NSURL URLWithString:theImage.url] placeholderImage:[UIImage imageNamed:@"chat_default_portrait@2x.png"]options:SDWebImageRefreshCached];
    
   [self.portraitImage setImage:[UIImage imageNamed:@"chat_default_portrait@2x.png"]];
    
    self.distanceLabel.text =[[LocationManager sharedInstance]getApproximateDistance:needModel.location];
    
    self.needsNameLabel.text = needModel.name;
    
    self.priceLabel.text = needModel.price;
    
    [self updateCellWithNeedStatus:needModel];
    
}

-(void)updateCellWithNeedStatus:(NeedsModel *)needModel{
    
    if([needModel.isOfferSold boolValue]){
        
    }
    else{
        
    }
    
}
@end
