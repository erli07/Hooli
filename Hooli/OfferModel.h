//
//  OfferModel.h
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
typedef enum {
    
    HL_OFFER_TYPE_CASH,
    HL_OFFER_TYPE_EXCHANGE,
    HL_OFFER_TYPE_FREE,
    
} HLOfferType;

@interface OfferModel : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PFFile *theImageFile;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) HLOfferType offerType;
@property (nonatomic, strong) PFObject *user;
@property (nonatomic, strong) NSString  *offerPrice;
@property (nonatomic, strong) NSDate *uploadTime;
@property (nonatomic, strong) NSString *offerId;
@property (nonatomic, strong) NSString *offerName;
@property (nonatomic, strong) NSString *offerDescription;
@property (nonatomic, strong) NSString *offerCategory;
@property (nonatomic) CLLocationCoordinate2D offerLocation;
@property (nonatomic, strong) NSString *offerLikesNum;
@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, assign) NSNumber *isOfferSold;


-(id)initOfferModelWithUser:(PFObject *)user
                      image:(UIImage *)image
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation
                isOfferSold:(NSNumber *)isOfferSold;

-(id)initOfferModelWithUser:(PFObject *)user
                 imageArray:(NSArray *)imageArray
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation
                isOfferSold:(NSNumber *)isOfferSold;


-(id)initOfferModelWithOfferId:(NSString*)offerId
                          user:(PFObject *)user
                     imageFile:(PFFile *)imageFile
                     offerName:(NSString *)offerName
                         price:(NSString *)offerPrice
                      category:(NSString *)offerCategory
                   description:(NSString *)offerDescription
                      location:(CLLocationCoordinate2D) offerLocation
                   isOfferSold:(NSNumber *)isOfferSold;

-(id)initOfferModelWithOfferId:(NSString*)offerId
                          user:(PFObject *)user
                    imageArray:(NSArray *)imageArray
                     offerName:(NSString *)offerName
                         price:(NSString *)offerPrice
                      category:(NSString *)offerCategory
                   description:(NSString *)offerDescription
                      location:(CLLocationCoordinate2D) offerLocation
                   isOfferSold:(NSNumber *)isOfferSold;


-(id)initOfferWithPFObject:(PFObject *)object;
-(id)initOfferDetailsWithPFObject:(PFObject *)object;



@end
