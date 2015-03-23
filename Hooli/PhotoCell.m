//
//  PhotoCell.m
//  Hooli
//
//  Created by Er Li on 3/21/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//
#import <Parse/Parse.h>
#import "PhotoCell.h"

@implementation PhotoCell
@synthesize photoImageView = _photoImageView;

-(void)updateCellWithImageFile:(PFFile *)imageFile{
        
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        if(!error){
            
            UIImage *image = [UIImage imageWithData:data];
            
            _photoImageView.image = image;
            
        }
    }];
    
}

- (void)awakeFromNib {
    
}

@end
