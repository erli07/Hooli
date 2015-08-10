//
//  AdminManager.m
//  Hooli
//
//  Created by Er Li on 8/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "AdminManager.h"
#import "HLConstant.h"
@implementation AdminManager

+(AdminManager *)sharedInstance{
    
    static AdminManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[AdminManager alloc] init];
        
    });
    
    return _sharedInstance;
    
}

+(void)addToBlackList:(PFUser *)user{
    
    PFObject *blackList = [PFObject objectWithClassName:kHLCloudBlackListClass];
    [blackList setObject:user.objectId forKey:@"objectId"];
    
    [blackList saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        }
        else{
            
        }
    }];
    
}
-(void)checkIfOnBlackList:(PFUser *)user withBlock:(void (^)(BOOL, NSError *))completionBlock{

    NSString *userId = user.objectId;
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudBlackListClass];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query whereKey:@"objectId" equalTo:userId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!object) {
            
            completionBlock(NO,error);
        }
        else{
            
            completionBlock(YES,error);
            
        }
    }];


}


@end
