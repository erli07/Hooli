//
//  OfferModel.m
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "OfferModel.h"
#import "HLConstant.h"
@implementation OfferModel
@synthesize image = _image;;
@synthesize offerCategory = _offerCategory;
@synthesize offerDescription = _offerDescription;
@synthesize offerPrice = _offerPrice;
@synthesize offerLocation = _offerLocation;
@synthesize offerId= _offerId;
@synthesize offerName = _offerName;
@synthesize offerLikesNum = _offerLikesNum;
@synthesize imageArray = _imageArray;
@synthesize geoPoint = _geoPoint;

-(id)initOfferModelWithUser:(PFObject *)user
                      image:(UIImage *)image
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation{
    
    self = [super init];
    if(self)
    {
        _image = image;
        _user = user;
        _offerName = offerName;
        _offerCategory = offerCategory;
        _offerDescription = offerDescription;
        _offerPrice = offerPrice;
        _offerLocation = offerLocation;
        _geoPoint = [[PFGeoPoint alloc]init];
        _geoPoint.latitude = offerLocation.latitude;
        _geoPoint.longitude = offerLocation.longitude;
    }
    return self;
    
    
}

-(id)initOfferModelWithUser:(PFObject *)user
                 imageArray:(NSArray *)imageArray
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation{
    
    self = [super init];
    if(self)
    {
        _imageArray = imageArray;
        _user = user;
        _offerName = offerName;
        _offerCategory = offerCategory;
        _offerDescription = offerDescription;
        _offerPrice = offerPrice;
        _offerLocation = offerLocation;
        _geoPoint = [[PFGeoPoint alloc]init];
        _geoPoint.latitude = offerLocation.latitude;
        _geoPoint.longitude = offerLocation.longitude;
    }
    return self;
    
    
}
-(id)initOfferModelWithOfferId:(NSString*)offerId
                          user:(PFObject *)user
                         image:(UIImage *)image
                     offerName:(NSString *)offerName
                         price:(NSString *)offerPrice
                      category:(NSString *)offerCategory
                   description:(NSString *)offerDescription
                      location:(CLLocationCoordinate2D) offerLocation {
    
    self = [super init];
    if(self)
    {
        _offerId = offerId;
        _image = image;
        _offerName = offerName;
        _user = user;
        _offerCategory = offerCategory;
        _offerDescription = offerDescription;
        _offerPrice = offerPrice;
        _offerLocation = offerLocation;
    }
    return self;
}

-(id)initOfferModelWithOfferId:(NSString*)offerId
                          user:(PFObject *)user
                    imageArray:(NSArray *)imageArray
                     offerName:(NSString *)offerName
                         price:(NSString *)offerPrice
                      category:(NSString *)offerCategory
                   description:(NSString *)offerDescription
                      location:(CLLocationCoordinate2D) offerLocation {
    
    self = [super init];
    if(self)
    {
        _offerId = offerId;
        _imageArray = imageArray;
        _offerName = offerName;
        _user = user;
        _offerCategory = offerCategory;
        _offerDescription = offerDescription;
        _offerPrice = offerPrice;
        _offerLocation = offerLocation;
    }
    return self;
}

-(id)initOfferWithPFObject:(PFObject *)object{
    
    PFFile *theImage = [object objectForKey:kHLOfferModelKeyThumbNail];
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    NSString *price = [object objectForKey:kHLOfferModelKeyPrice];
    NSString *category = [object objectForKey:kHLOfferModelKeyCategory];
    PFUser *user = [object objectForKey:kHLOfferModelKeyUser];
    NSString *description = [object objectForKey:kHLOfferModelKeyDescription];
    NSString *offerId = [object objectId];
    NSString *offerName = [object objectForKey:kHLOfferModelKeyOfferName];
    PFGeoPoint *geoPoint =  [object objectForKeyedSubscript:kHLOfferModelKeyGeoPoint];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    return  [self initOfferModelWithOfferId:offerId user:user image:image offerName:offerName price:price category:category description:description location:location];
}

-(id)initOfferDetailsWithPFObject:(PFObject *)object{
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:4];
    
    for (int i=0; i< 4; i++) {
        
        PFFile *theImage = [object objectForKey:[NSString stringWithFormat:@"imageFile%d",i]];
        
        if(theImage){
            
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [imageArray addObject:image];
            
        }
        
    }
    NSString *price = [object objectForKey:kHLOfferModelKeyPrice];
    NSString *category = [object objectForKey:kHLOfferModelKeyCategory];
    PFUser *user = [object objectForKey:kHLOfferModelKeyUser];
    NSString *description = [object objectForKey:kHLOfferModelKeyDescription];
    NSString *offerId = [object objectId];
    NSString *offerName = [object objectForKey:kHLOfferModelKeyOfferName];
    PFGeoPoint *geoPoint =  [object objectForKeyedSubscript:kHLOfferModelKeyGeoPoint];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    return  [self initOfferModelWithOfferId:offerId user:user imageArray:imageArray offerName:offerName price:price category:category description:description location:location];
}


@end
