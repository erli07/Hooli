//
//  OffersManager.m
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "OffersManager.h"
#import "HLConstant.h"
#import "LocationManager.h"
#import "HLSettings.h"
@implementation OffersManager
@synthesize retrivedObjects = _retrivedObjects;
@synthesize filterDictionary = _filterDictionary;
@synthesize downloadSuccess = _dowloadSuccess;
@synthesize downloadFailure = _downloadFailure;
@synthesize uploadFailure = _uploadFailure;
@synthesize uploadSuccess = _uploadSuccess;
@synthesize pageCounter;

+(OffersManager *)sharedInstance{
    
    static OffersManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[OffersManager alloc] init];
        
    });
    return _sharedInstance;
    
}

-(id)init{
    
    self = [super init];
    
    if(self){
        
        retrivedObjects = [[NSMutableArray alloc]init];
        offersArray = [[NSMutableArray alloc]init];
        
    }
    
    return self;
}

- (void)uploadImages:(NSArray *)imageArray
         withSuccess:(UploadSuccessBlock)success
         withFailure:(UploadFailureBlock)failure;
{
    _uploadSuccess = success ;
    _uploadFailure = failure;
    
    for (UIImage *image in imageArray) {
        
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:UIImagePNGRepresentation(image)];
        
        // Save PFFile
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                // Create a PFObject around a PFFile and associate it with the current user
                PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
                [userPhoto setObject:imageFile forKey:@"imageFile"];
                userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                
                PFUser *user = [PFUser currentUser];
                [userPhoto setObject:user forKey:@"user"];
                
                [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            _uploadSuccess();
                            
                        });
                        
                    }
                    else{
                        // Log details of the failure
                        _uploadFailure(error);
                        
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
            else{
                // Log details of the failure
                _uploadFailure(error);
                
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        } progressBlock:^(int percentDone) {
            
        }];
        
    }
}




-(NSData *)getResizeImageData:(UIImage *)image{
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [image drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    NSLog(@"Image size %u kb", [imageData length]/1024);
    
    return imageData;
}






-(void)updaloadOfferToCloud:(OfferModel *)offer
                withSuccess:(UploadSuccessBlock)success
                withFailure:(UploadFailureBlock)failure{
    
    _uploadSuccess = success ;
    _uploadFailure = failure;
    
    
    if(offer.imageArray == nil){
        
        _uploadFailure(nil);
        
    }
    
    PFObject *offerClass = [PFObject objectWithClassName:kHLCloudOfferClass];
    
    
    for (int i = 0; i <[offer.imageArray count]; i++) {
        
        NSData *imageData = [self compressImage:[offer.imageArray objectAtIndex:i] WithCompression:0.05f];
        PFFile *imageFile = [PFFile fileWithName:@"ImageFile.jpg" data:imageData];
        [offerClass setObject:imageFile forKey:[NSString stringWithFormat:@"imageFile%d",i]];
        
    }
    
    NSData *thumbnailData = [self compressImage:[offer.imageArray objectAtIndex:0] WithCompression:0.01f];
    PFFile *thumbNailFile = [PFFile fileWithName:@"thumbNail.jpg" data:thumbnailData];
    [offerClass setObject:thumbNailFile forKey:kHLOfferModelKeyThumbNail];
    
    // Save PFFile
    //    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //        if (!error) {
    
    // Create a PFObject around a PFFile and associate it with the current user
    
    offerClass.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    [offerClass.ACL setPublicReadAccess:YES];
    [offerClass.ACL setPublicWriteAccess:NO];
    
    PFUser *user = [PFUser currentUser];
    [offerClass setObject:user forKey:kHLOfferModelKeyUser];
    [offerClass setObject:offer.offerDescription forKey:kHLOfferModelKeyDescription];
    [offerClass setObject:offer.offerPrice forKey:kHLOfferModelKeyPrice];
    [offerClass setObject:offer.offerCategory forKey:kHLOfferModelKeyCategory];
    [offerClass setObject:offer.offerName forKey:kHLOfferModelKeyOfferName];
    [offerClass setObject:offer.geoPoint forKey:kHLOfferModelKeyGeoPoint];
    
    [offerClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _uploadSuccess();
                
            });

        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _uploadFailure(error);
                
            });
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    //        }
    //        else{
    //            // Log details of the failure
    //            NSLog(@"Error: %@ %@", error, [error userInfo]);
    //        }
    //    } progressBlock:^(int percentDone) {
    //
    //    }];
    
}

-(NSData *)compressImage:(UIImage *)image WithCompression: (CGFloat) compressionQuality{
    
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [image drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(smallImage, compressionQuality);
    
    NSLog(@"Get Image Size %u", [imageData length]/1024);
    
    return imageData;
    
}
-(void)clearData{
    
    if(retrivedObjects){
        
        [retrivedObjects removeAllObjects];
    }
    
    if(offersArray){
        
        [offersArray removeAllObjects];
    }
    
    self.filterDictionary = nil;
    
    self.pageCounter = 0;
}

-(void)retrieveOffersWithSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure{
    
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    
    [self retrieveOffersByFilter:self.filterDictionary];

    
}



-(void)retrieveOffersByFilter:(NSDictionary *)filterDictionary{
    
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudOfferClass];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
//    if(![[HLSettings sharedInstance]showSoldItems]){
//        
//        [query whereKey:kHLOfferModelKeyOfferStatus notEqualTo:[NSNumber numberWithBool:YES]];
//        
//    }

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
//        else if([[filterDictionary objectForKey:kHLFilterDictionarySearchType] isEqualToString:kHLFilterDictionarySearchKeyUserLikes]){
//            
//            id user = [filterDictionary objectForKey:kHLFilterDictionarySearchKeyUserLikes];
//            
//            [query whereKey:kHLOfferModelKeyUser equalTo:user];
//
//        }
    }
    
    [query orderByAscending:@"createdAt"];
    [query setLimit:kHLOffersNumberShowAtFirstTime];
    [query setSkip:kHLOffersNumberShowAtFirstTime * self.pageCounter];
    //    [query whereKey:kHLOfferModelKeyGeoPoint nearGeoPoint:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] withinMiles:[[HLSettings sharedInstance]preferredDistance]];
    // [query whereKey:kHLOfferModelKeyCategory equalTo:@"Home Goods"];
    //  [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            [PFQuery clearAllCachedResults];

            for (id object in objects) {
                
                [retrivedObjects addObject:object];
                
            }
            // retrivedObjects = [objects copy];
            [self getAllOffersFromObjects:retrivedObjects];
            
        } else {
            // Log details of the failure
            _downloadFailure(error);
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


-(void)updateTableByOffersArray:(NSArray *)offers{
    

    
    
}

-(void)getAllOffersFromObjects:(NSMutableArray *)objects{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [self parseFethcedObjects:retrivedObjects];
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
  //          [[HLSettings sharedInstance]setIsRefreshNeeded:NO];

            _dowloadSuccess(offersArray);
            
        });
    });
    
}

-(NSArray *)parseFethcedObjects:(NSMutableArray *)objects{
    
    // Iterate over all images and get the data from the PFFile
    for (int i = kHLOffersNumberShowAtFirstTime * self.pageCounter; i < objects.count; i++) {
        
        PFObject *eachObject = [objects objectAtIndex:i];
        OfferModel *newOffer = [[OfferModel alloc]initOfferWithPFObject:eachObject];
        [offersArray addObject:newOffer];
    }
    
    self.pageCounter += 1;
    
    return offersArray;
    
}

-(void)fetchOfferByID:(NSString *)offerID withSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure{
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    if(offerID!=nil){
        
        PFQuery *query = [PFQuery queryWithClassName:kHLCloudOfferClass];
        [query whereKey:kHLOfferModelKeyOfferId equalTo:offerID];

        // [query orderByAscending:@"createdAt"];
        [query getObjectInBackgroundWithId:offerID block:^(PFObject *object, NSError *error) {
            if (!error) {
                
                _dowloadSuccess(object);
                
            } else {
                // Log details of the failure
                _downloadFailure(error);
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
        
    }
    
}

-(void)fetchChattingIdByOfferId:(NSString *)offerID withSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure{
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    if(offerID!=nil){
        
        PFQuery *query = [PFQuery queryWithClassName:kHLCloudOfferClass];
        [query includeKey:kHLCloudUserClass];
        //[query whereKey:kHLOfferModelKeyOfferId equalTo:offerID];
        
        // [query orderByAscending:@"createdAt"];
        [query getObjectInBackgroundWithId:offerID block:^(PFObject *object, NSError *error) {
            if (object) {
                
         
                    // This does not require a network access.
                    PFObject *band = [object objectForKey:kHLCloudUserClass];
                
                id objects = [band objectForKey:kHLUserModelKeyEmail];
                
                _dowloadSuccess(object);
                
            } else {
                // Log details of the failure
                _downloadFailure(error);
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
        }];
        
    }
    
}

-(void)fetchOfferImagesWithOfferId:(NSString *)offerID withSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure{
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudOfferClass];
    [query whereKey:kHLOfferModelKeyOfferId equalTo:offerID];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            _dowloadSuccess(objects);
            
        } else {
            // Log details of the failure
            _downloadFailure(error);
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
}

-(void)fetchOffersByDistance:(double)distance withSuccess:(DownloadSuccessBlock)dowloadSuccess
                     failure:(DownloadFailureBlock)downloadFailure{
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudOfferClass];
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc]init];
    geoPoint.latitude = [[LocationManager sharedInstance]currentLocation].latitude;
    geoPoint.longitude = [[LocationManager sharedInstance]currentLocation].longitude;
    [query whereKey:kHLOfferModelKeyOfferId nearGeoPoint:geoPoint withinKilometers:distance];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            _dowloadSuccess(objects);
            
        } else {
            // Log details of the failure
            _downloadFailure(error);
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
    
}

-(void)updateOfferSoldStatusWithOfferID:(NSString *)offerID  soldStatus:(BOOL)soldStatus withSuccess:(DownloadSuccessBlock)dowloadSuccess
                                failure:(DownloadFailureBlock)downloadFailure{
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    PFObject *offerClass = [PFObject objectWithClassName:kHLCloudOfferClass];
    [offerClass setObject:[NSNumber numberWithBool:soldStatus] forKey:kHLOfferModelKeyOfferStatus];
    [offerClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            _uploadSuccess();
            
        }
        else{
            
            _uploadFailure(error);
            
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

-(void)updateOfferSoldStatusWithOfferID:(NSString *)offerID  soldStatus:(BOOL)soldStatus
                                  block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offerID];
    
    [object setObject:[NSNumber numberWithBool:soldStatus] forKey:kHLOfferModelKeyOfferStatus];
    
    // Save
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (completionBlock) {
            completionBlock(succeeded,error);
        }
        
    }];
}

-(void)updateOfferModelWithOfferId:(NSString *)offerID newOfferModel:(OfferModel *)newOfferModel
                             block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:offerID];
    
    if(newOfferModel.offerName){
        
        [object setObject:newOfferModel.offerName forKey:kHLOfferModelKeyOfferName];

    }
    
    if(newOfferModel.offerDescription){
        
        [object setObject:newOfferModel.offerDescription forKey:kHLOfferModelKeyDescription];
        
    }
    
    if(newOfferModel.offerPrice){
        
        [object setObject:newOfferModel.offerPrice forKey:kHLOfferModelKeyPrice];
        
    }
    
    // Save
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (completionBlock) {
            completionBlock(succeeded,error);
        }
        
    }];
        
}

-(void)deleteOfferModelWithOfferId:(NSString *)offerId  block:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFObject *object = [PFObject objectWithoutDataWithClassName:kHLCloudOfferClass
                                                       objectId:offerId];
    
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
