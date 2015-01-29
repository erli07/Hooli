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
#import "OffersManager.h"

@implementation ActivityManager
@synthesize downloadFailure = _downloadFailure;
@synthesize downloadSuccess = _downloadSuccess;

+(ActivityManager *)sharedInstance{
    
    static ActivityManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ActivityManager alloc] init];
        
    });
    return _sharedInstance;
    
}


-(void)isOfferLikedByCurrentUser:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    
    // __block BOOL isLikedByCurrentUser = NO;
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLActivityKeyOffer equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.offerId]];
    [queryLikes whereKey:kHLActivityKeyUser equalTo:[PFUser currentUser]];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if([objects count]>0){
                
                if (completionBlock) {
                    completionBlock(YES,nil);
                }
                
            }
            else{
                
                if (completionBlock) {
                    completionBlock(NO,nil);
                }
                
            }
        }
        else{
            
            if (completionBlock) {
                completionBlock(NO,nil);
            }
            
        }
        
    }];
    
}

- (void)setOfferLikesCount:(UILabel *)label withOffer:(OfferModel *)offer{
    
    __block NSInteger offerLikesCount = 0;
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLActivityKeyOffer equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.offerId]];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            offerLikesCount = [objects count];
            //  NSLog(@"insdie likes count %d",offerLikesCount);
            
            label.text = [NSString stringWithFormat:@"%ld",(long)offerLikesCount];
            
        }
    }];
    
}

- (void)likeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    NSLog(@"Like offer ID %@",offer.offerId);
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryExistingLikes whereKey:kHLActivityKeyOffer equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.offerId]];
    [queryExistingLikes whereKey:kHLActivityKeyUser equalTo:[PFUser currentUser]];
    [queryExistingLikes setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingLikes findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
        }
        
        // proceed to creating new like
        PFObject *likeActivity = [PFObject objectWithClassName:kHLCloudActivityClass];
        [likeActivity setObject:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.offerId] forKey:kHLActivityKeyOffer];
        [likeActivity setObject:[PFUser currentUser] forKey:kHLActivityKeyUser];
        //                [likeActivity setObject:offer.offerId forKey:kHLActivityKeyOffer];
        //                [likeActivity setObject:[[PFUser currentUser]objectId ] forKey:kHLActivityKeyUser];
        PFACL *likeACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [likeACL setPublicReadAccess:YES];
        //   [likeACL setWriteAccess:YES forUser:[offer.user objectForKey:kHLOfferModelKeyUser]];
        likeActivity.ACL = likeACL;
        
        [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
            
        }];
        
    }];
    
}

- (void)dislikeOfferInBackground:(OfferModel *)offer block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    NSLog(@"Dislike offer ID %@",offer.offerId);
    
    PFQuery *queryExistingLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryExistingLikes whereKey:kHLActivityKeyOffer equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.offerId]];
    [queryExistingLikes whereKey:kHLActivityKeyUser equalTo:[PFUser currentUser]];
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

- (void)getLikedOffersByUser:(PFUser *)user WithSuccess:(DownloadSuccessBlock)success
                     Failure:(DownloadFailureBlock)failure{
    
    _downloadSuccess = success ;
    _downloadFailure = failure;
    
    NSMutableArray *likedOffers = [NSMutableArray array];
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes includeKey:kHLActivityKeyOffer];
    [queryLikes whereKey:kHLActivityKeyUser equalTo:user];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *activity in objects) {
                
                PFObject *offerOriginal = [activity objectForKey:kHLActivityKeyOffer];
                
                OfferModel *offerModel = [[OfferModel alloc]initOfferWithPFObject:offerOriginal];
                
                [likedOffers addObject:offerModel];
                
            }
            
            _downloadSuccess(likedOffers);
            
            [[HLCache sharedCache] setLikedOffersByUser:user likedOffers:likedOffers];
            
            
        }
        else{
            
            
            _downloadFailure(nil);
            
        }
        
        
        
    }];
}


#pragma mark follow activity

- (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    //can not follow self
    
    if([user.objectId isEqual:[[PFUser currentUser]objectId]])
        return;
    
    PFQuery *queryExistingFollowing = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryExistingFollowing whereKey:kHLNotificationToUserKey equalTo: user];
    [queryExistingFollowing whereKey:kHLNotificationFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingFollowing setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingFollowing findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteInBackground];
            }
        }
        // proceed to creating new like
        
        PFObject *followActivity = [PFObject objectWithClassName:kHLCloudNotificationClass];
        [followActivity setObject:user forKey:kHLNotificationToUserKey];
        [followActivity setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey];
        [followActivity setObject:kHLNotificationTypeFollow forKey:kHLNotificationTypeKey];
        //                [likeActivity setObject:offer.offerId forKey:kHLActivityKeyOffer];
        //                [likeActivity setObject:[[PFUser currentUser]objectId ] forKey:kHLActivityKeyUser];
        PFACL *followACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [followACL setPublicReadAccess:YES];
        [followACL setWriteAccess:YES forUser:[PFUser currentUser]];
        followActivity.ACL = followACL;
        
        [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
                if(succeeded){
                    NSLog(@"Follow success");
                }
                
            }
            
        }];
        
    }];
    
    
}
- (void)unFollowUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    //can not unfollow self
    if([user.objectId isEqual:[[PFUser currentUser]objectId]])
        return;
    
    PFQuery *queryExistingFollowing = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryExistingFollowing whereKey:kHLNotificationToUserKey equalTo:user];
    [queryExistingFollowing whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
    [queryExistingFollowing whereKey:kHLNotificationFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingFollowing setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingFollowing findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        if (!error) {
            for (PFObject *activity in activities) {
                [activity delete];
            }
            if (completionBlock) {
                
                NSLog(@"Unfollow success");
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

- (void)getFollowersByUser:(PFUser *)user block:(void (^)(NSArray *array, NSError *error))completionBlock{
    
//    _downloadSuccess = success ;
//    _downloadFailure = failure;
    
    NSMutableArray *followersArray = [NSMutableArray array];
    
    PFQuery *queryFollwers = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryFollwers includeKey:kHLNotificationFromUserKey];
    [queryFollwers whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
    [queryFollwers whereKey:kHLNotificationToUserKey equalTo:user];
    [queryFollwers findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                
                PFUser *follower = [object objectForKey:kHLNotificationFromUserKey];
                
                [followersArray addObject:follower];
                
            }
            
            if(completionBlock){
                
                completionBlock(followersArray, nil);
            }
          
            // [[HLCache sharedCache] setLikedOffersByUser:user likedOffers:likedOffers];
        }
        else{
            
            if(completionBlock){
                
                completionBlock(nil, error);
            }

            
        }
        
    }];
    
    
}

- (void)getFollowedUsersByUser:(PFUser *)user block:(void (^)(NSArray *array, NSError *error))completionBlock{
    
    NSMutableArray *followedUsersArray = [NSMutableArray array];
    
    PFQuery *queryFollowee = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryFollowee includeKey:kHLNotificationToUserKey];
    [queryFollowee whereKey:kHLNotificationFromUserKey equalTo:user];
    [queryFollowee whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
    [queryFollowee findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                
                PFUser *followedUser = [object objectForKey:kHLNotificationToUserKey];
                
                [followedUsersArray addObject:followedUser];
                
            }
            NSLog(@"Get followed users %d", [followedUsersArray count]);
            
            if(completionBlock){
                
                completionBlock(followedUsersArray, nil);
            }
            
            // [[HLCache sharedCache] setLikedOffersByUser:user likedOffers:likedOffers];
        }
        else{
            
            if(completionBlock){
                
                completionBlock(nil, error);
            }
        }
        
    }];
    
}



- (void)getFriendsByUser:(PFUser *)user block:(void (^)(NSArray *array, NSError *error))completionBlock{
    
     NSMutableArray *friendsArray = [NSMutableArray array];
    
    PFQuery *followeeQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [followeeQuery whereKey:kHLNotificationFromUserKey equalTo:user];
    [followeeQuery whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
    
    PFQuery *friendsQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [friendsQuery whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
    [friendsQuery whereKey:kHLNotificationToUserKey equalTo:user];
    [friendsQuery whereKey:kHLNotificationFromUserKey matchesKey:kHLNotificationToUserKey inQuery:followeeQuery];
    
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            NSLog(@"objects %@",objects);
            
            for (PFObject *object in objects) {
                
                PFUser *friend = [object objectForKey:kHLNotificationFromUserKey];
                
                [friendsArray addObject:friend];
                
            }
            
            if(completionBlock){
                
                completionBlock(friendsArray, nil);
            }

            
        }
        else{
            
            if(completionBlock){
                
                completionBlock(nil, error);
            }

            
        }
        
        
    }];
    
}

- (void)getUserRelationshipWithUserOne:(PFUser *)user1
                               UserTwo:(PFUser *)user2
                             WithBlock:(void (^)(RelationshipType relationType, NSError *error))completionBlock{
    
    
    __block RelationshipType relationType = HL_RELATIONSHIP_TYPE_NONE;
    
    PFQuery *followeeQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [followeeQuery whereKey:kHLNotificationFromUserKey equalTo:user1];
    [followeeQuery whereKey:kHLNotificationToUserKey equalTo:user2];
    [followeeQuery whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
    [followeeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count]!=0){
            
            relationType = HL_RELATIONSHIP_TYPE_IS_FOLLOWING;
            
            PFQuery *followerQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
            [followerQuery whereKey:kHLNotificationFromUserKey equalTo:user2];
            [followerQuery whereKey:kHLNotificationToUserKey equalTo:user1];
            [followerQuery whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
            [followerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(objects){
                    
                    relationType = HL_RELATIONSHIP_TYPE_FRIENDS;
                    completionBlock(relationType,nil);
                    
                }
                
            }];
            
        }
        else{
            
            PFQuery *followerQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
            [followerQuery whereKey:kHLNotificationFromUserKey equalTo:user2];
            [followerQuery whereKey:kHLNotificationToUserKey equalTo:user1];
            [followerQuery whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
            [followerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if([objects count]!=0){
                    
                    relationType = HL_RELATIONSHIP_TYPE_IS_FOLLOWED;
                    completionBlock(relationType,nil);
                    
                }
                else{
                    
                    completionBlock(relationType,nil);
                    
                }
                
            }];
            
        }
        
    }];
    

}


- (void)makeOfferToOffer:(OfferModel *)offerObject
               withPrice:(NSString *)price
                   block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFQuery *queryExistingMakeOffer = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryExistingMakeOffer whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offerObject.offerId]];
    [queryExistingMakeOffer whereKey:kHLNotificationFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingMakeOffer includeKey:kHLNotificationToUserKey];
    [queryExistingMakeOffer setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingMakeOffer findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
//        
        if (!error) {
            for (PFObject *activity in activities) {
                [activity deleteInBackground];
            }
        }
        
        // proceed to creating new like
        
        PFUser *toUser = (PFUser *)offerObject.user;
        
        PFObject *activity = [PFObject objectWithClassName:kHLCloudNotificationClass];
        [activity setObject:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offerObject.offerId] forKey:kHLNotificationOfferKey];
        [activity setObject:toUser forKey:kHLNotificationToUserKey];
        [activity setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey];
        [activity setObject:khlNotificationTypMakeOffer forKey:kHLNotificationTypeKey];
        [activity setObject:price forKey:kHLNotificationContentKey];
        
        //                [likeActivity setObject:[[PFUser currentUser]objectId ] forKey:kHLActivityKeyUser];
        PFACL *aACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [aACL setPublicReadAccess:YES];
        [aACL setWriteAccess:YES forUser:[PFUser currentUser]];
        activity.ACL = aACL;
        
        [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (completionBlock) {
                completionBlock(succeeded,error);
                if(succeeded){
                    NSLog(@"Make offer success");
                }
                
            }
            
        }];
        
    }];

}
-(void)isOfferAlreadyMadeByCurrentUser:(OfferModel *)offerObject
                                 block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [query whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offerObject.offerId]];
    [query whereKey:kHLNotificationFromUserKey equalTo:[PFUser currentUser]];
    [query includeKey:kHLNotificationToUserKey];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if(object){
            
            if (completionBlock) {
                completionBlock(YES,error);
            }
            
        }
        else{
            
            if (completionBlock) {
                completionBlock(NO,error);
            }
            
        }
        
    }];
}

@end
