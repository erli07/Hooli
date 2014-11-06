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
@synthesize retrivedObjects,filterDictionary;
@synthesize downloadSuccess = _dowloadSuccess;
@synthesize downloadFailure = _downloadFailure;
@synthesize uploadFailure = _uploadFailure;
@synthesize uploadSuccess = _uploadSuccess;

+(OffersManager *)sharedInstance{
    
    static OffersManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[OffersManager alloc] init];
    });
    return _sharedInstance;
    
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
    
    
    if(offer.image == nil){
        
        _uploadFailure(nil);
        
    }
    UIGraphicsBeginImageContext(CGSizeMake(640, 640));
    [offer.image drawInRect: CGRectMake(0, 0, 640, 640)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    
    NSLog(@"Image size %u kb", [imageData length]/1024);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *offerClass = [PFObject objectWithClassName:kHLCloudOfferClass];
            [offerClass setObject:imageFile forKey:kHLOfferModelKeyImage];
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
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        
    }];
    
}


-(void)retrieveOffersWithSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure{
    
    _dowloadSuccess = dowloadSuccess ;
    _downloadFailure = downloadFailure;
    
    [self retrieveOffersByFilter:self.filterDictionary];
    
}

-(void)retrieveOffersByFilter:(NSDictionary *)filterDictionary{
    
    retrivedObjects = [[NSMutableArray alloc]init];
    offersArray = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudOfferClass];
    PFUser *user = [PFUser currentUser];
    
    [query whereKey:@"user" equalTo:user];
    [query whereKey:kHLOfferModelKeyCategory equalTo:@"Home Goods"];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            retrivedObjects = [objects copy];
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
    for (int i = 1; i < objects.count; i++) {
        
        PFObject *eachObject = [objects objectAtIndex:objects.count - i];
        OfferModel *newOffer = [[OfferModel alloc]initOfferWithPFObject:eachObject];
        [offersArray addObject:newOffer];
    }
    
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
@end
