//
//  ImageCache.h
//  Hooli
//
//  Created by Er Li on 11/9/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageCache : NSObject
+(ImageCache *)sharedInstance;
@property (nonatomic, strong) UIImage *image1;
@property (nonatomic, strong) UIImage *image2;
@property (nonatomic, strong) UIImage *image3;
@property (nonatomic, strong) UIImage *image4;
@property (nonatomic) unsigned int photoCount;
-(void)setImage:(UIImage *)image withImageIndex:(int)imageIndex;

-(NSArray *)getimagesArray;
@end
