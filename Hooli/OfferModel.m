//
//  OfferModel.m
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "OfferModel.h"

@implementation OfferModel
@synthesize image = _image;;
@synthesize offerCategory = _offerCategory;
@synthesize offerDescription = _offerDescription;
@synthesize offerPrice = _offerPrice;


-(id)initOfferModelWithUser:(PFObject *)user image:(UIImage *)image price:(NSString *)offerPrice category:(NSString *)offerCategory description:(NSString *)offerDescription{
    
        self = [super init];
        if(self)
        {
            _image = image;
            _user = user;
            _offerCategory = offerCategory;
            _offerDescription = offerDescription;
            _offerPrice = offerPrice;
            
        }
        return self;
}


@end
