//
//  ImageManager.m
//  Hooli
//
//  Created by Er Li on 11/2/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+(ImageManager *)sharedInstance{
    
    static ImageManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ImageManager alloc] init];
    });
    return _sharedInstance;
    
}
- (UIImage *)loadImageWithName:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat: @"%@.png",imageName]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (void)saveImage: (UIImage*)image WithName:(NSString *)imageName
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat: @"%@.png",imageName] ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}
@end
