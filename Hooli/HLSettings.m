//
//  HLSettings.m
//  Hooli
//
//  Created by Er Li on 10/31/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLSettings.h"

@implementation HLSettings
@synthesize postItemStatus = _postItemStatus;

+(HLSettings *)sharedInstance{
    
    static HLSettings *sharedInstance = nil;
    
    if (!sharedInstance) {
        sharedInstance = [[HLSettings alloc] init];
    }
    return sharedInstance;
}


-(HLPostItemStatus )getPostItemStatus{
    
    return _postItemStatus;
}
@end
