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
            PFUser *user = [PFUser currentUser];
            [offerClass setObject:user forKey:kHLOfferModelKeyUser];
            [offerClass setObject:offer.offerDescription forKey:kHLOfferModelKeyDescription];
            [offerClass setObject:offer.offerPrice forKey:kHLOfferModelKeyPrice];
            [offerClass setObject:offer.offerCategory forKey:kHLOfferModelKeyCategory];
            [offerClass setObject:offer.offerName forKey:kHLOfferModelKeyOfferName];
            
            [offerClass saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        _uploadSuccess();
                        
                    });
                    // [self refresh:nil];
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
    
    self.pageCounter = 0;
}

-(void)retrieveOffersWithSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure{
    
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    [self retrieveOffersByFilter:self.filterDictionary];
    
}

-(void)retrieveOffersByFilter:(NSDictionary *)filterDictionary{
    
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudOfferClass];
    PFUser *user = [PFUser currentUser];
    
    [query whereKey:@"user" equalTo:user];
    [query setLimit:kHLOffersNumberShowAtFirstTime];
    [query setSkip:kHLOffersNumberShowAtFirstTime * self.pageCounter];
    // [query whereKey:kHLOfferModelKeyCategory equalTo:@"Home Goods"];
    [query orderByAscending:@"createdAt"];
    //  [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
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


-(void)getAllOffersFromObjects:(NSMutableArray *)objects{
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [self parseFethcedObjects:retrivedObjects];
        // Dispatch to main thread to update the UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _dowloadSuccess(offersArray);
            
        });
    });
    
}

-(NSArray *)parseFethcedObjects:(NSMutableArray *)objects{
    
    CLLocationCoordinate2D location;
    location.latitude = 40.00;
    location.longitude = -70.00;
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
        [query whereKey:@"objectId" equalTo:offerID];
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

@end
