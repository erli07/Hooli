//
//  ActivityManager.h
//  Hooli
//
//  Created by Er Li on 11/14/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfferModel.h"

typedef enum{
    HL_RELATIONSHIP_TYPE_NONE = 1,
    HL_RELATIONSHIP_TYPE_FRIENDS,
    HL_RELATIONSHIP_TYPE_IS_FOLLOWED,
    HL_RELATIONSHIP_TYPE_IS_FOLLOWING,
    
} RelationshipType;

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


- (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
- (void)unFollowUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
- (void)getFollowersByUser:(PFUser *)user block:(void (^)(NSArray *array, NSError *error))completionBlock;
- (void)getFollowedUsersByUser:(PFUser *)user block:(void (^)(NSArray *array, NSError *error))completionBlock;
- (void)getFriendsByUser:(PFUser *)user block:(void (^)(NSArray *array, NSError *error))completionBlock;
- (void)getUserRelationshipWithUserOne:(PFUser *)user1
                               UserTwo:(PFUser *)user2
                             WithBlock:(void (^)(RelationshipType relationType, NSError *error))completionBlock;
- (void)deleteAllOfferWithOfferId:(NSString *)offerId;

- (BOOL)checkBalanceStatus:(NSString *)offeredPrice;

- (void)makeOfferToOffer:(OfferModel *)offerObject
               withPrice:(NSString *)price
                   block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)acceptingOfferWithOffer:(PFObject *)offer
                         price:(NSString *)price
                        toUser:(PFUser *) toUser
                         block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)updateCreditsValueForAllWithOffer:(PFObject *)offerObject
                                  toUser:(PFUser *)toUser
                                   price:(NSString *)price
                                   block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)isOfferAlreadyMadeByCurrentUser:(OfferModel *)offerObject
                                 block:(void (^)(BOOL succeeded, NSError *error))completionBlock;



-(void)returnCreditsWithOffer:(PFObject *)offer;

@end
