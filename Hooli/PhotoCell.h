//
//  PhotoCell.h
//  Hooli
//
//  Created by Er Li on 3/21/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UICollectionViewCell

@property (nonatomic) UIImageView *photoImageView;

-(void)updateCellWithImageFile:(PFFile *)imageFile;

@end
