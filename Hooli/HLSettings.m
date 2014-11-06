//
//  HLSettings.m
//  Hooli
//
//  Created by Er Li on 11/4/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLSettings.h"

@implementation HLSettings
@synthesize category,isPostingOffer;
+(HLSettings *)sharedInstance{
    
    static HLSettings *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[HLSettings alloc] init];
    });
    return _sharedInstance;
    
}


@end
