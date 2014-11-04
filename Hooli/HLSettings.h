//
//  HLSettings.h
//  Hooli
//
//  Created by Er Li on 10/31/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    HL_POST_ITEM,
    HL_MAKE_OFFER,
    HL_UNKNOWN
    
} HLPostItemStatus;

@interface HLSettings : NSObject

+(HLSettings *)sharedInstance;

@property (nonatomic, assign) HLPostItemStatus *postItemStatus;
-(HLPostItemStatus)getPostItemStatus;
@end
