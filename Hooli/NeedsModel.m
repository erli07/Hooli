//
//  NeedsModel.m
//  Hooli
//
//  Created by Er Li on 12/24/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedsModel.h"
#import "HLConstant.h"

#define imagesCount 4
@implementation NeedsModel
@synthesize category = _category;
@synthesize user = _user;
@synthesize name = _name;
@synthesize needsDescription = _needsDescription;
@synthesize geoPoint = _geoPoint;
@synthesize uploadTime = _uploadTime;
@synthesize budget = _budget;
@synthesize objectId = _objectId;
@synthesize isOfferSold = _isOfferSold;
@synthesize imageArray = _imageArray;
@synthesize location = _location;

-(id)initNeedModelWithObjectId:(NSString*)objectId
                          user:(PFObject *)user
                    imageArray:(NSArray *)imageArray
                          name:(NSString *)name
                         price:(NSString *)price
                      category:(NSString *)category
                   description:(NSString *)description
                      location:(CLLocationCoordinate2D) location
                   isOfferSold:(NSNumber *)isOfferSold {
    
    self = [super init];
    if(self)
    {
        _objectId = objectId;
        _imageArray = imageArray;
        _name = name;
        _user = user;
        _category = category;
        _needsDescription = description;
        _budget = price;
        _location = location;
        _isOfferSold = isOfferSold;
        
    }
    
    return self;
}


-(id)initNeedsObjectDetailsWithPFObject:(PFObject *)object{
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:imagesCount];
    
    for (int i=0; i< imagesCount; i++) {
        
        PFFile *theImage = [object objectForKey:[NSString stringWithFormat:@"imageFile%d",i]];
        
        if(theImage){
            
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            [imageArray addObject:image];
            
        }
        
    }
    
    NSString *price = [object objectForKey:kHLNeedsModelKeyPrice];
    NSString *category = [object objectForKey:kHLNeedsModelKeyCategory];
    PFUser *user = [object objectForKey:kHLNeedsModelKeyUser];
    NSString *description = [object objectForKey:kHLNeedsModelKeyDescription];
    NSString *objectId = [object objectId];
    NSString *name = [object objectForKey:kHLNeedsModelKeyName];
    PFGeoPoint *geoPoint =  [object objectForKeyedSubscript:kHLNeedsModelKeyGeoPoint];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    NSNumber *offerStatus = [object objectForKeyedSubscript:kHLNeedsModelKeyStatus];
    
    return  [self initNeedModelWithObjectId:objectId user:user imageArray:imageArray name:name price:price category:category description:description location:location isOfferSold:offerStatus];
}

-(id)initNeedModelWithUser:(PFObject *)user
                     title:(NSString *)title
               description:(NSString *)description
                    budget:(NSString *)budget
                  category:(NSString *)category{
   
    self = [super init];
    if(self)
    {
        _user = user;
        _category = category;
        _needsDescription = description;
        _budget = budget;
        _name = title;
        
    }
    
    return self;

    
    
}
@end
