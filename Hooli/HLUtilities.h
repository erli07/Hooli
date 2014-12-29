//
//  HLUtilities.h
//  Hooli
//
//  Created by Er Li on 11/13/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfferModel.h"
@interface HLUtilities : NSObject


+ (NSData *)compressImage:(UIImage *)image WithCompression: (CGFloat) compressionQuality;

@end
