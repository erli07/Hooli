//
//  OffersManager.h
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OfferModel.h"

typedef void (^DownloadSuccessBlock) (id downloadObjects);
typedef void (^DownloadFailureBlock) (id error);

typedef void (^UploadSuccessBlock) ();
typedef void (^UploadFailureBlock) (id error);

@interface OffersManager : NSObject
{
    NSMutableArray *retrivedObjects;
    
    NSMutableArray *offersArray;
    
}
@property (nonatomic, strong) DownloadSuccessBlock downloadSuccess;
@property (nonatomic, strong) DownloadFailureBlock downloadFailure;
@property (nonatomic, strong) UploadFailureBlock uploadFailure;
@property (nonatomic, strong) UploadSuccessBlock uploadSuccess;
@property (nonatomic, strong)  NSMutableArray *retrivedObjects;
@property (nonatomic, strong)  NSDictionary *filterDictionary;
@property (nonatomic) NSArray *filterArray;
@property (nonatomic, strong)  NSMutableArray *offersArray;
@property (nonatomic, assign) NSInteger pageCounter;
@property (nonatomic, strong) NSArray *followedUserArray;

+(OffersManager *)sharedInstance;

-(void)clearData;

-(void)checkIfOfferExist:(NSString *)offerId
                   block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

- (void)uploadImages:(NSArray *)imageArray
         withSuccess:(UploadSuccessBlock)success
         withFailure:(UploadFailureBlock)failure;

-(void)updaloadOfferToCloud:(OfferModel *)offer
                withSuccess:(UploadSuccessBlock)uploadSuccess
                withFailure:(UploadFailureBlock)uploadFailure;

-(void)retrieveOffersWithSuccess:(DownloadSuccessBlock)dowloadSuccess
                         failure:(DownloadFailureBlock)downloadFailure;

-(void)fetchOfferByID:(NSString *)offerID withSuccess:(DownloadSuccessBlock)dowloadSuccess
              failure:(DownloadFailureBlock)downloadFailure;

-(void)fetchOffersByDistance:(double)distance withSuccess:(DownloadSuccessBlock)dowloadSuccess
              failure:(DownloadFailureBlock)downloadFailure;

-(void)updateOfferSoldStatusWithOfferID:(NSString *)offerID  soldStatus:(BOOL)soldStatus
                            block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)getOfferSoldStatusWithOfferID:(NSString *)offerID block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)deleteOfferModelWithOfferId:(NSString *)offerId
                             block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)updateOfferModelWithOfferId:(NSString *)offerID newOfferModel:(OfferModel *)newOfferModel
                             block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)fetchChattingIdByOfferId:(NSString *)offerID withSuccess:(DownloadSuccessBlock)dowloadSuccess failure:(DownloadFailureBlock)downloadFailure;

-(void)getLastestBillWithOfferId:(NSString *)offerId
                           block:(void (^)(PFObject *object, NSError *error))completionBlock;

@end
