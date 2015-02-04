//
//  HLCache.h
//  Hooli
//
//  Created by Er Li on 11/13/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfferModel.h"
@interface HLCache : NSObject

+ (id)sharedCache;

- (void)clear;

- (void)incrementLikerCountForOffer:(OfferModel *)offerModel;
- (void)decrementLikerCountForOffer:(OfferModel *)offerModel;
- (void)setAttributesForOffer:(OfferModel *)offer likers:(NSArray *)likers likedByCurrentUser:(BOOL)likedByCurrentUser;
-( void)setLikedOffersByUser:(PFUser *)user likedOffers:(NSArray *)likedOffers;

- (NSDictionary *)attributesForUser:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;


- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;
@end
