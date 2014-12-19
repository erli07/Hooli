//
//  ActivityManager.h
//  Hooli
//
//  Created by Er Li on 11/14/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfferModel.h"
typedef void (^DownloadSuccessBlock) (id downloadObjects);
typedef void (^DownloadFailureBlock) (id error);

typedef void (^UploadSuccessBlock) ();
typedef void (^UploadFailureBlock) (id error);

@interface ActivityManager : NSObject
+(ActivityManager *)sharedInstance;

@property (nonatomic, strong) DownloadSuccessBlock downloadSuccess;
@property (nonatomic, strong) DownloadFailureBlock downloadFailure;
@property (nonatomic, strong) UploadFailureBlock uploadFailure;
@property (nonatomic, strong) UploadSuccessBlock uploadSuccess;


- (void)likeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
- (void)dislikeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
- (void)setOfferLikesCount:(UILabel *)label withOffer:(OfferModel *)offer;
- (void)isOfferLikedByCurrentUser:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
- (void)getLikedOffersByUser:(PFUser *)user WithSuccess:(DownloadSuccessBlock)success
                                                Failure:(DownloadFailureBlock)failure;
@end
