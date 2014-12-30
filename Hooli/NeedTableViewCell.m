//
//  NeedTableViewCell.m
//  Hooli
//
//  Created by Er Li on 12/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedTableViewCell.h"

@implementation NeedTableViewCell
@synthesize portraitImage;
- (void)awakeFromNib {
    [self.portraitImage setImage:[UIImage imageNamed:@"chat_default_portrait"]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
