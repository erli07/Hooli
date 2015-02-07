//
//  NeedTableViewCell.m
//  Hooli
//
//  Created by Er Li on 12/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedTableViewCell.h"
@interface NeedTableViewCell()
@property (nonatomic, strong) UILabel *distanceLabel;
@end

@implementation NeedTableViewCell
@synthesize portraitImage,needId;
- (void)awakeFromNib {
    
   
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        self.distanceLabel = [[UILabel alloc]initWithFrame:self.timeLabel.frame];
        [self.distanceLabel setFont:[UIFont systemFontOfSize:11]];
        [self.distanceLabel setTextColor:[UIColor colorWithRed:114.0f/255.0f green:114.0f/255.0f blue:114.0f/255.0f alpha:1.0f]];
        [self.distanceLabel setBackgroundColor:[UIColor clearColor]];
        self.distanceLabel.text = @"1.11 mi";
        [self.mainView addSubview:self.distanceLabel];

    }
    
    return self;
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.distanceLabel setFrame:CGRectMake(320 - 120, self.timeLabel.frame.origin.y, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height)];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNeedContentText:(NSString *)contentString{
    
    // If we have a user we pad the content with spaces to make room for the name
    if (self.user) {
        CGSize nameSize = [self.nameButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                                        context:nil].size;
        NSString *paddedString = [BaseTextCell padString:contentString withFont:[UIFont systemFontOfSize:13] toWidth:nameSize.width];
        [self.contentLabel setText:paddedString];
    } else { // Otherwise we ignore the padding and we'll add it after we set the user
        [self.contentLabel setText:contentString];
    }
    [self setNeedsDisplay];
    
}


@end
