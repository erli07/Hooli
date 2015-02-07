//
//  NeedsModel.h
//  Hooli
//
//  Created by Er Li on 12/24/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface NeedsModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *imageArray;
//@property (nonatomic, assign) HLOfferType offerType;
@property (nonatomic, strong) PFObject *user;
@property (nonatomic, strong) NSString  *budget;
@property (nonatomic, strong) NSDate *uploadTime;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *needsDescription;
@property (nonatomic, strong) NSString *category;
@property (nonatomic) CLLocationCoordinate2D location;
//@property (nonatomic, strong) NSString *offerLikesNum;
@property (nonatomic, strong) PFGeoPoint *geoPoint;
@property (nonatomic, assign) NSNumber *isOfferSold;

-(id)initNeedModelWithObjectId:(NSString*)objectId
                           user:(PFObject *)user
                     imageArray:(NSArray *)imageArray
                           name:(NSString *)name
                          price:(NSString *)price
                       category:(NSString *)category
                    description:(NSString *)description
                       location:(CLLocationCoordinate2D) location
                    isOfferSold:(NSNumber *)isOfferSold;

-(id)initNeedsObjectDetailsWithPFObject:(PFObject *)object;

-(id)initNeedModelWithUser:(PFObject *)user
               description:(NSString *)description
                    budget:(NSString *)budget
                  category:(NSString *)category;

@end
