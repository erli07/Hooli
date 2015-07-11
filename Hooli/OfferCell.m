//
//  OfferCell.m
//  Hooli
//
//  Created by Er Li on 6/23/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "OfferCell.h"
#import "HLRect.h"

@implementation OfferCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGRect bounds = self.contentView.bounds;
    
    CGRect imageViewFrame = CGRectZero;
    if (_imageView && _imageView.image){
        imageViewFrame = PFRectMakeWithSizeCenteredInRect(PFSizeMin(_imageView.image.size, bounds.size),
                                                          bounds);
    }
    CGRect textLabelFrame = CGRectZero;
    if (_textLabel) {
        CGSize maxImageViewSize = CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds) / 3.0f * 2.0f);
        CGSize imageViewSize = PFSizeMin(imageViewFrame.size, maxImageViewSize);
        
        imageViewFrame = PFRectMakeWithSizeCenteredInRect(imageViewSize, PFRectMakeWithSize(maxImageViewSize));
        CGFloat textLabelTopInset = (CGRectIsEmpty(imageViewFrame) ? 0.0f : CGRectGetMaxY(imageViewFrame));
        
        textLabelFrame = PFRectMakeWithOriginSize(CGPointMake(0.0f, textLabelTopInset),
                                                  CGSizeMake(CGRectGetWidth(bounds), CGRectGetHeight(bounds) - textLabelTopInset));
    }
    
    // Adapt content mode of _imageView to fit the image in bounds if the layout frame is smaller or center if it's bigger.
    if (!CGRectIsEmpty(imageViewFrame)) {
        if (CGRectContainsRect(PFRectMakeWithSize(_imageView.image.size), imageViewFrame)) {
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            _imageView.contentMode = UIViewContentModeCenter;
        }
    }
    
    _imageView.frame = CGRectIntegral(imageViewFrame);
    _textLabel.frame = CGRectIntegral(textLabelFrame);
}

#pragma mark -
#pragma mark Update

-(void)updateCellWithPFObject:(PFObject *)object{
    
    NSLog(@"Update cell with object %@", object);
    
}

#pragma mark -
#pragma mark Accessors

- (PFImageView *)imageView {
    if (!_imageView) {
        _imageView = [[PFImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 0;
        [self.contentView addSubview:_textLabel];
    }
    return _textLabel;
}



@end
