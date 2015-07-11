//
//  OfferCell.h
//  Hooli
//
//  Created by Er Li on 6/23/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseUI/ParseUIConstants.h>

PFUI_ASSUME_NONNULL_BEGIN

@class PFImageView;
@class PFObject;

@interface OfferCell : UICollectionViewCell

-(void)updateCellWithPFObject:(PFUI_NULLABLE PFObject *)object;

@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, strong, readonly) PFImageView *imageView;

@end

PFUI_ASSUME_NONNULL_END
