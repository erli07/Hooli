//
//  HLUtilities.m
//  Hooli
//
//  Created by Er Li on 11/13/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLUtilities.h"
#import <Parse/Parse.h>
#import "HLConstant.h"
#import "HLCache.h"
@implementation HLUtilities

+ (void)likeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryExistingLikes whereKey:kHLCloudOfferClass equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudUserClass objectId:offer.offerId]];
    [queryExistingLikes whereKey:kHLCloudUserClass equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kHLCloudActivityClass];
        [likeActivity setObject:[PFObject objectWithoutDataWithClassName:kHLCloudUserClass objectId:offer.offerId] forKey:kHLCloudOfferClass];
        [likeActivity setObject:[PFUser currentUser] forKey:kHLCloudUserClass];
        
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        [likeACL setWriteAccess:YES forUser:[offer.user objectForKey:kHLOfferModelKeyUser]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }

            
            }];
         
         }];

}
+ (void)unlikeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryExistingLikes whereKey:kHLCloudOfferClass equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudUserClass objectId:offer.offerId]];
    [queryExistingLikes whereKey:kHLCloudUserClass equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
    }];
    
}

+ (void)getLikersNumberByOffer:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    NSMutableArray *likers = [NSMutableArray array];
    __block BOOL isLikedByCurrentUser = NO;
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLCloudOfferClass equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudUserClass objectId:offer.offerId]];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *activity in objects) {
                
                [likers addObject:[activity objectForKey:kHLCloudUserClass]];
                
                if ([[activity objectForKey:kHLCloudUserClass] isEqual:[PFUser currentUser]])
                {
                    isLikedByCurrentUser = YES;
                }
            }
        }
        
        [[HLCache sharedCache] setAttributesForOffer:offer likers:likers likedByCurrentUser:isLikedByCurrentUser];
        
    }];
}

+ (void)getLikedOffersByUser:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    NSMutableArray *likedOffers = [NSMutableArray array];
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLCloudUserClass equalTo:user];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *activity in objects) {
                
                [likedOffers addObject:[activity objectForKey:kHLCloudOfferClass]];
                
            }
        }
        
        [[HLCache sharedCache] setLikedOffersByUser:user likedOffers:likedOffers];
        
    }];
}



-(BOOL)isOfferLikedByCurrentUser:(OfferModel *)offer{
    
    __block BOOL isLikedByCurrentUser = NO;
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLCloudOfferClass equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudUserClass objectId:offer.offerId]];
    [queryLikes whereKey:kHLActivityKeyOffer equalTo:offer.offerId];
    [queryLikes whereKey:kHLCloudUserClass equalTo:[PFUser currentUser]];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *activity in objects) {
                
                if ([[activity objectForKey:kHLCloudUserClass]  isEqual:[PFUser currentUser]]) {
                    isLikedByCurrentUser = YES;
                }
            }
        }
    }];
    
    return isLikedByCurrentUser;
}



@end
