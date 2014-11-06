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



-(id)initOfferModelWithUser:(PFObject *)user
                      image:(UIImage *)image
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation;

-(id)initOfferModelWithUser:(PFObject *)user
                 imageArray:(NSArray *)imageArray
                      price:(NSString *)offerPrice
                  offerName:(NSString *)offerName
                   category:(NSString *)offerCategory
                description:(NSString *)offerDescription
                   location:(CLLocationCoordinate2D) offerLocation;

-(id)initOfferModelWithOfferId:(NSString*)offerId
                          user:(PFObject *)user
                         image:(UIImage *)image
                     offerName:(NSString *)offerName
                         price:(NSString *)offerPrice
                      category:(NSString *)offerCategory
                   description:(NSString *)offerDescription
                      location:(CLLocationCoordinate2D) offerLocation;

-(id)initOfferWithPFObject:(PFObject *)object;


@end
