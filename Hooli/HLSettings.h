//
//  HLSettings.h
//  Hooli
//
//  Created by Er Li on 11/4/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSettings : NSObject
+(HLSettings *)sharedInstance;
@property (nonatomic, strong) NSArray *category;
@property (nonatomic, assign) BOOL isPostingOffer;
@end
