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
    [queryExistingLikes whereKey:kHLOfferModelKeyOfferId equalTo:offer.offerId];
    [queryExistingLikes whereKey:kHLActivityKeyUserID equalTo:[[PFUser currentUser]objectId]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kHLCloudActivityClass];
        [likeActivity setObject:[offer offerId] forKey:kHLActivityKeyOfferID];
        [likeActivity setObject:[[PFUser currentUser]objectId] forKey:kHLActivityKeyUserID];
        
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        [likeACL setWriteAccess:YES forUser:[offer.user objectForKey:kHLOfferModelKeyUser]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            NSMutableArray *likers = [NSMutableArray array];
            __block BOOL isLikedByCurrentUser = NO;
            
            PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
            [queryLikes whereKey:kHLActivityKeyOfferID equalTo:offer.offerId];
            [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    
                    for (PFObject *activity in objects) {
                        
                        [likers addObject:[activity objectForKey:kHLActivityKeyUserID]];

                        if ([[[activity objectForKey:kHLActivityKeyUserID] objectId] isEqualToString:[[PFUser currentUser] objectId]])
                        {
                            isLikedByCurrentUser = YES;
                        }
                    }
                }
                
                [[HLCache sharedCache] setAttributesForOffer:offer likers:likers likedByCurrentUser:isLikedByCurrentUser];

            }];
            
        }];
         
         //                [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:photo userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:succeeded] forKey:PAPPhotoDetailsViewControllerUserLikedUnlikedPhotoNotificationUserInfoLikedKey]];
         }];

}


-(BOOL)isOfferLikedByCurrentUser:(OfferModel *)offer{
    
    __block BOOL isLikedByCurrentUser = NO;
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLActivityKeyOfferID equalTo:offer.offerId];
    [queryLikes whereKey:kHLActivityKeyUserID equalTo:[[PFUser currentUser] objectId]];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *activity in objects) {
                
                if ([[[activity objectForKey:kHLActivityKeyUserID] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
                    isLikedByCurrentUser = YES;
                }
            }
        }
    }];
    
    return isLikedByCurrentUser;
}



@end
