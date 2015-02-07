//
//  NeedsManager.m
//  Hooli
//
//  Created by Er Li on 12/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedsManager.h"
#import "HLConstant.h"
#import "HLSettings.h"
#import "LocationManager.h"
#import "HLUtilities.h"

@implementation NeedsManager

@synthesize retrivedObjects = _retrivedObjects;
@synthesize filterDictionary = _filterDictionary;
@synthesize downloadSuccess = _dowloadSuccess;
@synthesize downloadFailure = _downloadFailure;
@synthesize uploadFailure = _uploadFailure;
@synthesize uploadSuccess = _uploadSuccess;
@synthesize pageCounter = _pageCounter;

+(NeedsManager *)sharedInstance{
    
    static NeedsManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[NeedsManager alloc] init];
        
    });
    return _sharedInstance;
    
}

-(id)init{
    
    self = [super init];
    
    if(self){
        
        retrivedObjects = [[NSMutableArray alloc]init];
        needsArray = [[NSMutableArray alloc]init];
        
    }
    
    return self;
}

-(void)clearData{
    
    if(retrivedObjects){
        
        [retrivedObjects removeAllObjects];
    }
    
    if(needsArray){
        
        [needsArray removeAllObjects];
    }
    
    self.filterDictionary = nil;
    
    self.pageCounter = 0;
}



-(void)uploadNeedToCloud:(NeedsModel *)need
                   block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFObject *needClass = [PFObject objectWithClassName:kHLCloudItemNeedClass];
    
    needClass.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [needClass.ACL setPublicReadAccess:YES];
    [needClass.ACL setPublicWriteAccess:NO];
    
    PFUser *user = [PFUser currentUser];
    [needClass setObject:user forKey:kHLNeedsModelKeyUser];
    [needClass setObject:need.needsDescription forKey:kHLNeedsModelKeyDescription];
    [needClass setObject:need.budget forKey:kHLNeedsModelKeyPrice];
    [needClass setObject:need.category forKey:kHLNeedsModelKeyCategory];
//    [needClass setObject:need.name forKey:kHLNeedsModelKeyName];
//    [needClass setObject:[[LocationManager sharedInstance]currentLocation] forKey:kHLNeedsModelKeyGeoPoint];
    
    [needClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {

            completionBlock(YES, error);

        }
        else{

            completionBlock(NO, error);
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    
}
-(void)retrieveNeedsWithSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure{
    
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    
    [self retrieveNeedsByFilter:self.filterDictionary];
    
}

-(void)retrieveNeedsByFilter:(NSDictionary *)filterDictionary{
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudItemNeedClass];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    if(filterDictionary){
        
        if([[filterDictionary objectForKey:kHLFilterDictionarySearchType] isEqualToString:kHLFilterDictionarySearchKeyCategory]){
            
            NSString *searchType = [filterDictionary objectForKey:kHLFilterDictionarySearchKeyCategory];
            [query whereKey:kHLOfferModelKeyCategory containsString:searchType];
            
        }
        
        else if([[filterDictionary objectForKey:kHLFilterDictionarySearchType] isEqualToString:kHLFilterDictionarySearchKeyWords]){
            
            NSString *searchWords = [filterDictionary objectForKey:kHLFilterDictionarySearchKeyWords];
            
            [query whereKey:kHLOfferModelKeyOfferName containsString:searchWords];
            
        }
        
        else if([[filterDictionary objectForKey:kHLFilterDictionarySearchType] isEqualToString:kHLFilterDictionarySearchKeyUser]){
            
            id user = [filterDictionary objectForKey:kHLFilterDictionarySearchKeyUser];
            
            [query whereKey:kHLOfferModelKeyUser equalTo:user];
            
        }

    }
    
    [query orderByAscending:@"createdAt"];
    [query setLimit:kHLNeedsNumberShowAtFirstTime];
    [query setSkip:kHLNeedsNumberShowAtFirstTime * self.pageCounter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            [PFQuery clearAllCachedResults];
            
            for (id object in objects) {
                
                [retrivedObjects addObject:object];
                
            }
            // retrivedObjects = [objects copy];
            [self getAllNeedsFromObjects:retrivedObjects];
            
        } else {
            // Log details of the failure
            _downloadFailure(error);
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void)getAllNeedsFromObjects:(NSMutableArray *)objects{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [self parseFethcedObjects:retrivedObjects];
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //          [[HLSettings sharedInstance]setIsRefreshNeeded:NO];
            
            _dowloadSuccess(needsArray);
            
        });
    });
    
}

-(NSArray *)parseFethcedObjects:(NSMutableArray *)objects{
    
    // Iterate over all images and get the data from the PFFile
    for (int i = kHLOffersNumberShowAtFirstTime * self.pageCounter; i < objects.count; i++) {
        
        PFObject *eachObject = [objects objectAtIndex:i];
        NeedsModel *newOffer = [[NeedsModel alloc]initNeedsObjectDetailsWithPFObject:eachObject];
        [needsArray addObject:newOffer];
    }
    
    self.pageCounter += 1;
    
    return needsArray;
    
}

-(void)fetchNeedByID:(NSString *)needId block:(void (^)(PFObject* object, NSError *error))completionBlock{
    

    if(needId!=nil){
        
        PFQuery *query = [PFQuery queryWithClassName:kHLCloudItemNeedClass];
        [query whereKey:@"objectId" equalTo:needId];
        [query includeKey:kHLNeedsModelKeyUser];
        [query getObjectInBackgroundWithId:needId block:^(PFObject *object, NSError *error) {
            if (!error) {
                
                if (completionBlock) {
                    completionBlock(object,error);
                }
                
            } else {
                // Log details of the failure
               NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
        
    }
    
}

-(void)updateNeedSoldStatusWithNeedID:(NSString *)needId soldStatus:(BOOL)soldStatus block:(void (^)(BOOL, NSError *))completionBlock{
    
    PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudItemNeedClass objectId:needId];
    
    [object setObject:[NSNumber numberWithBool:soldStatus] forKey:kHLNeedsModelKeyStatus];
    
    // Save
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (completionBlock) {
            completionBlock(succeeded,error);
        }
        
    }];
}


-(void)deleteNeedModelWithNeedId:(NSString *)needId block:(void (^)(BOOL, NSError *))completionBlock{
    
    PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudItemNeedClass
                                                       objectId:needId];
    
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            
            if (completionBlock) {
                completionBlock(succeeded,error);
            }
            
        }
        else{
            
            NSLog(@"Delete self error %@", [error description]);
            
        }
    }];
    
}



@end
