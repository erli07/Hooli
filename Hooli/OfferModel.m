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
@synthesize isOfferSold = _isOfferSold;
@synthesize theImageFile = _theImageFile;
@synthesize toUser = _toUser;
@synthesize offerCondition = _offerCondition;
-(id)initOfferModelWithUser:(PFObject *)user
                      image:(UIImage *)image
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation
                isOfferSold:(NSNumber *)isOfferSold{
    
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
        _isOfferSold = isOfferSold;
    }
    return self;
    
    
}

-(id)initOfferModelWithUser:(PFObject *)user
                 imageArray:(NSArray *)imageArray
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation
                isOfferSold:(NSNumber *)isOfferSold{
    
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
        _isOfferSold = isOfferSold;
        _image = [imageArray objectAtIndex:0];
        
    }
    return self;
    
    
}


-(id)initOfferModelWithUser:(PFObject *)user
                 imageArray:(NSArray *)imageArray
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation
                isOfferSold:(NSNumber *)isOfferSold
                  condition:(NSString *)offerCondition{
    
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
        _isOfferSold = isOfferSold;
        _image = [imageArray objectAtIndex:0];
        _offerCondition = offerCondition;
        
    }
    return self;
    
    
}

-(id)initOfferModelWithOfferId:(NSString*)offerId
                          user:(PFObject *)user
                     imageFile:(PFFile *)imageFile
                     offerName:(NSString *)offerName
                         price:(NSString *)offerPrice
                      category:(NSString *)offerCategory
                   description:(NSString *)offerDescription
                      location:(CLLocationCoordinate2D) offerLocation
                   isOfferSold:(NSNumber *)isOfferSold {
    
    self = [super init];
    if(self)
    {
        _offerId = offerId;
        _theImageFile = imageFile;
        _offerName = offerName;
        _user = user;
        _offerCategory = offerCategory;
        _offerDescription = offerDescription;
        _offerPrice = offerPrice;
        _offerLocation = offerLocation;
        _isOfferSold = isOfferSold;
        
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
                      location:(CLLocationCoordinate2D) offerLocation
                   isOfferSold:(NSNumber *)isOfferSold {
    
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
        _isOfferSold = isOfferSold;
        _image = [imageArray objectAtIndex:0];
    }
    return self;
}

-(id)initOfferWithPFObject:(PFObject *)object{
    
    PFFile *theImage = [object objectForKey:kHLOfferModelKeyThumbNail];
    NSString *price = [object objectForKey:kHLOfferModelKeyPrice];
    NSString *category = [object objectForKey:kHLOfferModelKeyCategory];
    PFUser *user = [object objectForKey:kHLOfferModelKeyUser];
    NSString *description = [object objectForKey:kHLOfferModelKeyDescription];
    NSString *offerId = [object objectId];
    NSString *offerName = [object objectForKey:kHLOfferModelKeyOfferName];
    PFGeoPoint *geoPoint =  [object objectForKeyedSubscript:kHLOfferModelKeyGeoPoint];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    NSNumber *offerStatus = [object objectForKeyedSubscript:kHLOfferModelKeyOfferStatus];
    
    return  [self initOfferModelWithOfferId:offerId user:user imageFile:theImage offerName:offerName price:price category:category description:description location:location isOfferSold:offerStatus];
}

-(id)initOfferDetailsWithPFObject:(PFObject *)object{
    
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    
    PFObject *images = [object objectForKey:kHLOfferModelKeyImage];
    
    
    for (int i=0; i< 4; i++) {
        
        PFFile *theImage = [images objectForKey:[NSString stringWithFormat:@"imageFile%d",i]];
        
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
    NSNumber *offerStatus = [object objectForKeyedSubscript:kHLOfferModelKeyOfferStatus];

    return  [self initOfferModelWithOfferId:offerId user:user imageArray:imageArray offerName:offerName price:price category:category description:description location:location isOfferSold:offerStatus];
}


@end
