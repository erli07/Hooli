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
- (void)getBidOffersByUser:(PFUser *)user WithSuccess:(DownloadSuccessBlock)success
                     Failure:(DownloadFailureBlock)failure{
    
    _downloadSuccess = success ;
    _downloadFailure = failure;
    
    NSMutableArray *bidOffers = [NSMutableArray array];
    
    PFQuery *queryBid = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryBid whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypMakeOffer];
    [queryBid whereKey:kHLNotificationFromUserKey equalTo:user];
    [queryBid includeKey:kHLNotificationOfferKey];
    [queryBid findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *notif in objects) {
                
                PFObject *offerOriginal = [notif objectForKey:kHLNotificationOfferKey];
                
                if(offerOriginal){
                    
                    OfferModel *offerModel = [[OfferModel alloc]initOfferWithPFObject:offerOriginal];
                    
                    [bidOffers addObject:offerModel];
                    
                }
                
            }
            
            _downloadSuccess(bidOffers);
            
            
        }
        else{
            
            
            _downloadFailure(nil);
            
        }
        
        
        
    }];
}


- (void)getLikedOffersByUser:(PFUser *)user WithSuccess:(DownloadSuccessBlock)success
                     Failure:(DownloadFailureBlock)failure{
    
    _downloadSuccess = success ;
    _downloadFailure = failure;
    
    NSMutableArray *likedOffers = [NSMutableArray array];
    
    PFQuery *queryLikes = [PFQuery queryWithClassName:kHLCloudActivityClass];
    [queryLikes whereKey:kHLActivityKeyUser equalTo:user];
    [queryLikes includeKey:kHLActivityKeyOffer];
    [queryLikes findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *activity in objects) {
                
                PFObject *offerOriginal = [activity objectForKey:kHLActivityKeyOffer];
                
                if(offerOriginal){
                    
                    OfferModel *offerModel = [[OfferModel alloc]initOfferWithPFObject:offerOriginal];
                    
                    [likedOffers addObject:offerModel];
                    
                }
                
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

//-(BOOL)checkBalanceStatus:(NSString *)offeredPrice{
//    
//    NSInteger _offeredPrice = [[self strRemovePrefix:offeredPrice] integerValue];
//    
//    NSInteger _currentBalance = [[self strRemovePrefix:[[PFUser currentUser]objectForKey:kHLUserModelKeyCredits]] integerValue];
//    
//    if (_currentBalance - _offeredPrice < 0) {
//        
//        return NO;
//    }
//    
//    return YES;
//}


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
            for (PFObject *object in activities) {
                
                [self updateCreditsForUser:[object objectForKey:kHLNotificationToUserKey] price:price type:khlNotificationAddValue block:^(BOOL succeeded, NSError *error) {
                    
                    if(succeeded){
                        
                        [object deleteInBackground];
                        
                    }
                    
                }];
            }
        }
        
        // proceed to creating new like
        
        PFUser *toUser = (PFUser *)offerObject.user;
        
        PFObject *notificationFeedObject = [PFObject objectWithClassName:kHLCloudNotificationClass];
        [notificationFeedObject setObject:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offerObject.offerId] forKey:kHLNotificationOfferKey];
        [notificationFeedObject setObject:toUser forKey:kHLNotificationToUserKey];
        [notificationFeedObject setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey];
        [notificationFeedObject setObject:khlNotificationTypMakeOffer forKey:kHLNotificationTypeKey];
        [notificationFeedObject setObject:price forKey:kHLNotificationContentKey];
        
        //                [likeActivity setObject:[[PFUser currentUser]objectId ] forKey:kHLActivityKeyUser];
        PFACL *aACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [aACL setPublicReadAccess:YES];
        [aACL setPublicWriteAccess:YES];
        
        [notificationFeedObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                [self updateCreditsForUser:[PFUser currentUser] price:price type:khlNotificationSubValue block:^(BOOL succeeded, NSError *error) {
                    
                    if (completionBlock) {
                        completionBlock(succeeded,error);
                        
                        NSLog(@"Make offer success");
                    }
                    
                }];
            }
            
        }];
        
    }];
    
}


-(void)updateCreditsValueForAllWithOffer:(PFObject *)offerObject
                                  toUser:(PFUser *)toUser
                                   price:(NSString *)price
                                   block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    
//    PFQuery *query =  [PFQuery queryWithClassName:kHLCloudNotificationClass];
//    [query whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offerObject.objectId]];
//    //[query whereKey:kHLNotificationFromUserKey equalTo:toUser];
//    [query whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypMakeOffer];
//    //  [query whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypAcceptOffer];
//    [query includeKey:kHLNotificationToUserKey];
//    [query setCachePolicy:kPFCachePolicyNetworkOnly];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *notifications, NSError *error) {
//        //
//        if (!error && [notifications count] != 0) {
//            for (PFObject *notif in notifications) {
//                
//                if([[notif objectForKey:kHLNotificationTypeKey] isEqual:[notif objectForKey:khlNotificationTypMakeOffer]]){
//                    
//                    if(![[notif objectForKey:kHLNotificationFromUserKey] isEqual:toUser]){
//                        
//                        [self updateCreditsForUser:toUser price:[notif objectForKey:kHLNotificationContentKey] type:khlNotificationAddValue block:^(BOOL succeeded, NSError *error) {
//                            
//                            if(succeeded){
//                                
//                                [notif deleteInBackground];
//                                
//                            }
//                            
//                        }];
//                        
//                    }
//                    
//                }
//            }
//            
//            [self updateCreditsForUser:[PFUser currentUser] price:price type:khlNotificationAddValue block:^(BOOL succeeded, NSError *error) {
//                
//                if(succeeded){
//                    
//                    if (completionBlock) {
//                        completionBlock(YES,error);
//                    }
//                }
//                
//                
//            }];
//            
//            
//        }
//        else{
//            
//            if (completionBlock) {
//                completionBlock(NO,error);
//            }
//            
//            
//        }
//    }];
    
    if (completionBlock) {
        completionBlock(NO,nil);
    }

    
}

-(void)updateCreditsForUser:(PFUser *)user
                      price:(NSString *)price
                       type:(NSString *)type
                      block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
//    if([type isEqual:khlNotificationSubValue]){
//        
//        NSString *myCredits = [user objectForKey:kHLUserModelKeyCredits];
//        NSInteger updatedCredits = [[self strRemovePrefix:myCredits] integerValue] - [[self strRemovePrefix:price] integerValue];
//        [user setObject:[NSString stringWithFormat:@"$%@",[NSNumber numberWithInteger:updatedCredits] ]forKey:kHLUserModelKeyCredits];
//        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            
//            if(succeeded){
//                
//                if (completionBlock) {
//                    completionBlock(YES,error);
//                }
//            }
//            
//        }];
//    }
//    else if([type isEqual:khlNotificationAddValue]){
//        
//        NSString *myCredits = [user objectForKey:kHLUserModelKeyCredits];
//        NSInteger updatedCredits = [[self strRemovePrefix:myCredits] integerValue] + [[self strRemovePrefix:price] integerValue];
//        [user setObject:[NSString stringWithFormat:@"$%@",[NSNumber numberWithInteger:updatedCredits] ]forKey:kHLUserModelKeyCredits];
//        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            
//            if(succeeded){
//                
//                if (completionBlock) {
//                    completionBlock(YES,error);
//                }
//            }
//            
//        }];
//        
//    }
    if (completionBlock) {
        completionBlock(YES,nil);
    }

    
    
}


-(NSString *)strRemovePrefix:(NSString *)originalString{
    
    NSString *prefixToRemove = @"$";
    NSString *newString = [originalString copy];
    if ([originalString hasPrefix:prefixToRemove])
        newString = [originalString substringFromIndex:[prefixToRemove length]];
    return newString;
    
}


-(void)acceptingOfferWithOffer:(PFObject *)offer
                         price:(NSString *)price
                        toUser:(PFUser *) toUser
                         block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    
    PFQuery *queryExistingAcceptOffer = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryExistingAcceptOffer whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.objectId]];
    [queryExistingAcceptOffer whereKey:kHLNotificationFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingAcceptOffer includeKey:kHLNotificationToUserKey];
    [queryExistingAcceptOffer setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingAcceptOffer findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        
        if (!error) {
            for (PFObject *object in activities) {
                
                [object deleteInBackground];
                
            }
        }
        
        PFObject *acceptOfferObject = [PFObject objectWithClassName:kHLCloudNotificationClass];
        [acceptOfferObject setObject:price forKey:kHLNotificationContentKey];
        [acceptOfferObject setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey];
        [acceptOfferObject setObject:toUser forKey:kHLNotificationToUserKey];
        [acceptOfferObject setObject:khlNotificationTypAcceptOffer forKey:kHLNotificationTypeKey];
        [acceptOfferObject setObject:offer forKey:kHLNotificationOfferKey];
        
        PFACL *aACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [aACL setPublicReadAccess:YES];
        [aACL setPublicWriteAccess:YES];
        
        [acceptOfferObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                [self updateCreditsValueForAllWithOffer:offer toUser:toUser price:price block:^(BOOL succeeded, NSError *error) {
                    
                    if(succeeded){
                        
                        [self notifyOthersItemHasBeenSoldWithOffer:offer byUser:toUser block:NULL];
                        
                        [self deleteMakeOfferWithOffer:offer NoUser:toUser];
                        
                        if (completionBlock) {
                            completionBlock(YES,error);
                        }
                        
                    }
                    
                }];
            }
            
        }];
        
    }];
    
}


-(void)notifyOthersItemHasBeenSoldWithOffer:(PFObject *)offer
                                     byUser:(PFUser *) toUser
                                      block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFQuery *bidQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [bidQuery whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.objectId]];
    [bidQuery whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypMakeOffer];
    [bidQuery includeKey:kHLNotificationToUserKey];
    [bidQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [bidQuery findObjectsInBackgroundWithBlock:^(NSArray *activities, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in activities) {
                
                if(![[[object objectForKey:kHLNotificationFromUserKey]objectId] isEqual:toUser.objectId ]){
                    
                    PFObject *soldObject = [PFObject objectWithClassName:kHLCloudNotificationClass];
                    [soldObject setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey];
                    [soldObject setObject:toUser forKey:kHLNotificationToUserKey];
                    [soldObject setObject:khlNotificationTypeOfferSold forKey:kHLNotificationTypeKey];
                    [soldObject setObject:offer forKey:kHLNotificationOfferKey];
                    
                    PFACL *aACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    [aACL setPublicReadAccess:YES];
                    [aACL setPublicWriteAccess:YES];
                    
                    [soldObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         
                    }];
                     
               }
            
            }
            
        }
        
    }];
    
    
}

-(void)deleteAllOfferWithOfferId:(NSString *)offerId{
    
    PFQuery *deleteQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [deleteQuery whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:@"cqyzpN3hOs"]];
   // [deleteQuery whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypMakeOffer];
    [deleteQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [deleteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        }
        
    }];

}

-(void)deleteMakeOfferWithOffer:(PFObject *)offer NoUser:(PFUser *)user{
    
    PFQuery *deleteQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [deleteQuery whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.objectId]];
    [deleteQuery whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypMakeOffer];
    [deleteQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [deleteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *object in objects) {
                
                if (![object.objectId isEqualToString:user.objectId]) {
                    
                    [object deleteInBackground];
                    
                }
            }
        }
        
    }];
    
}

/*
-(void)returnCreditsWithOffer:(PFObject *)offer{
    
    
    PFQuery *addQuery =  [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [addQuery whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.objectId]];
    [addQuery whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypMakeOffer];
    [addQuery includeKey:kHLNotificationToUserKey];
    [addQuery includeKey:kHLNotificationFromUserKey];
    
    [addQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [addQuery findObjectsInBackgroundWithBlock:^(NSArray *notifications, NSError *error) {
        
        for (PFObject *notif in notifications) {
            
            PFUser *user = [notif objectForKey:kHLNotificationFromUserKey];
            [self updateCreditsForUser:user price:[notif objectForKey:kHLNotificationContentKey] type:khlNotificationAddValue block:NULL];
            
            [notif deleteInBackground];
        }
        
    }];
    
    PFQuery *subQuery =  [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [subQuery whereKey:kHLNotificationOfferKey equalTo: [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offer.objectId]];
    [subQuery whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypAcceptOffer];
    [subQuery includeKey:kHLNotificationToUserKey];
    [subQuery includeKey:kHLNotificationFromUserKey];
    
    [subQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [subQuery findObjectsInBackgroundWithBlock:^(NSArray *notifications, NSError *error) {
        
        for (PFObject *notif in notifications) {
            
            PFUser *user = [notif objectForKey:kHLNotificationFromUserKey];
            [self updateCreditsForUser:user price:[notif objectForKey:kHLNotificationContentKey] type:khlNotificationSubValue block:NULL];
            
            [notif deleteInBackground];
        }
        
    }];
    
    
}
*/

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
