//
//  NeedsManager.h
//  Hooli
//
//  Created by Er Li on 12/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NeedsModel.h"

typedef void (^DownloadSuccessBlock) (id downloadObjects);
typedef void (^DownloadFailureBlock) (id error);

typedef void (^UploadSuccessBlock) ();
typedef void (^UploadFailureBlock) (id error);

@interface NeedsManager : NSObject
{
    NSMutableArray *retrivedObjects;
    
    NSMutableArray *needsArray;
    
}
@property (nonatomic, strong) DownloadSuccessBlock downloadSuccess;
@property (nonatomic, strong) DownloadFailureBlock downloadFailure;
@property (nonatomic, strong) UploadFailureBlock uploadFailure;
@property (nonatomic, strong) UploadSuccessBlock uploadSuccess;
@property (nonatomic, strong) NSMutableArray *retrivedObjects;
@property (nonatomic, strong) NSDictionary *filterDictionary;
@property (nonatomic, strong) NSMutableArray *needsArray;
@property (nonatomic, assign) NSInteger pageCounter;


+(NeedsManager *)sharedInstance;

-(void)clearData;

-(void)uploadNeedToCloud:(NeedsModel *)need
                withSuccess:(UploadSuccessBlock)uploadSuccess
                withFailure:(UploadFailureBlock)uploadFailure;

-(void)retrieveNeedsWithSuccess:(DownloadSuccessBlock)dowloadSuccess
                         failure:(DownloadFailureBlock)downloadFailure;

-(void)fetchNeedByID:(NSString *)needId
         withSuccess:(DownloadSuccessBlock)dowloadSuccess
             failure:(DownloadFailureBlock)downloadFailure;

-(void)updateNeedSoldStatusWithNeedID:(NSString *)needId
                            soldStatus:(BOOL)soldStatus
                                  block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)deleteNeedModelWithNeedId:(NSString *)needId
                             block:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)uploadDemoNeedModel;

@end
