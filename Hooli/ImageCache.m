//
//  ImageCache.m
//  Hooli
//
//  Created by Er Li on 11/9/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ImageCache.h"

@implementation ImageCache
@synthesize image4,image3,image2,image1;
+(ImageCache *)sharedInstance{
    
    static ImageCache *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ImageCache alloc] init];
        
    });
    return _sharedInstance;
    
}

-(void)setImage:(UIImage *)image withImageIndex:(int)imageIndex{
    
    switch (imageIndex) {
        case 1:
            self.image1 = image;
            break;
        case 2:
            self.image2 = image;
            break;
        case 3:
            self.image3 = image;
            break;
        case 4:
            self.image4 = image;
            break;
            
        default:
            break;
    }
    
}

-(NSArray *)getimagesArray{
    
    NSArray *imagesArray = [NSArray arrayWithObjects:self.image1,self.image2,self.image3,self.image4, nil];

    return imagesArray;
}


@end
