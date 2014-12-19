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

@end
