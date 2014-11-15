//
//  ActivityManager.m
//  Hooli
//
//  Created by Er Li on 11/14/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ActivityManager.h"
#import "OfferModel.h"
#import <Parse/Parse.h>
#import "HLConstant.h"
#import "HLCache.h"

@implementation ActivityManager


+(ActivityManager *)sharedInstance{
    
    static ActivityManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ActivityManager alloc] init];
        
    });
    return _sharedInstance;
    
}


-(void)isOfferLikedByCurrentUser:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    
    __block BOOL isLikedByCurrentUser = NO;
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLActivityKeyOfferID equalTo:offer.offerId];
    [queryLikes whereKey:kHLActivityKeyUserID equalTo:[[PFUser currentUser] objectId]];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if([objects count] > 0){
                
                isLikedByCurrentUser = YES;
                
                if (completionBlock) {
                    completionBlock(isLikedByCurrentUser,nil);
                }
            }
            else{
                
                if (completionBlock) {
                    completionBlock(isLikedByCurrentUser,nil);
                }
                
            }
        }
        else{
            
            if (completionBlock) {
                completionBlock(isLikedByCurrentUser,nil);
            }
            
        }
        
    }];
    
}

- (void)setOfferLikesCount:(UILabel *)label withOffer:(OfferModel *)offer{
    
    __block NSInteger offerLikesCount = 0;
    
    NSLog(@"Offer ID %@",offer.offerId);
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLActivityKeyOfferID equalTo:offer.offerId];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            offerLikesCount = [objects count];
            NSLog(@"insdie likes count %d",offerLikesCount);
            
            label.text = [NSString stringWithFormat:@"%d",offerLikesCount];
            
        }
    }];
    
}

- (void)likeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    NSLog(@"Like offer ID %@",offer.offerId);
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryExistingLikes whereKey:kHLActivityKeyOfferID equalTo:offer.offerId];
    [queryExistingLikes whereKey:kHLActivityKeyUserID equalTo:[[PFUser currentUser]objectId]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        else{
            if (completionBlock) {
                completionBlock(NO,nil);
            }
        }
        
        PFObject *likeActivity = [PFObject objectWithClassName:kHLCloudActivityClass];
        [likeActivity setObject:[offer offerId] forKey:kHLActivityKeyOfferID];
        [likeActivity setObject:[[PFUser currentUser]objectId] forKey:kHLActivityKeyUserID];
        
        
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        //    [likeACL setWriteAccess:YES forUser:[offer.user objectForKey:kHLOfferModelKeyUser]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
        }];
        
    }];
    
}

- (void)dislikeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryExistingLikes whereKey:kHLActivityKeyOfferID equalTo:offer.offerId];
    [queryExistingLikes whereKey:kHLActivityKeyUserID equalTo:[[PFUser currentUser]objectId]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
            if (completionBlock) {
                completionBlock(YES,nil);
            }
            
        }
        else{
            
            if (completionBlock) {
                completionBlock(NO,nil);
            }
            
        }
        
    }];
    
}

@end
