


//
//  EventManager.m
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "EventManager.h"

@implementation EventManager

+(EventManager *)sharedInstance{
    
    static EventManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[EventManager alloc] init];
        
    });
    return _sharedInstance;
    
}



-(void)uploadEventToCloud:(PFObject *)event withBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if(succeeded){
            
            completionBlock(YES, nil);
        }
        
    }];
    
}

-(void)getAllEventsWithBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    
    
    
}

@end
