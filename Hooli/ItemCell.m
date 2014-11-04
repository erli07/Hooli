//
//  ItemCell.m
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ItemCell.h"
#import "HLTheme.h"
@implementation ItemCell

@synthesize productImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib{
    

//    self.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:11.0f];
//    self.timeLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
    self.likesLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
    
    self.contentView.tintColor = [HLTheme mainColor];
    
//    self.titleLabel.textColor = [UIColor blackColor];
//    self.timeLabel.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.likesLabel.textColor = [HLTheme mainColor];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
}

-(void)updateCellWithData:(NSDictionary*)data{
    
    self.productImageView.image = [UIImage imageNamed:data[@"image"]];
    self.priceLabel.text = data[@"price"];
    self.titleLabel.text = data[@"company"];
    self.timeLabel.text = data[@"dates"];
    self.likesLabel.text = data[@"hearts"];
    
}

- (IBAction)likesButtonClicked:(id)sender {
    
    NSLog(@"Like button clicked");
}


@end
