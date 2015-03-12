//
//  ActivityListCell.m
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityListCell.h"
#import "HLConstant.h"
@implementation ActivityListCell

//@property (weak, nonatomic) IBOutlet UILabel *activityContentLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
//@property (weak, nonatomic) IBOutlet UILabel *extraInfoLabel;
//@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *groupNumberLabel;

@synthesize activityContentLabel = _activityContentLabel;
@synthesize portraitImageView = _portraitImageView;
@synthesize extraInfoLabel = _extraInfoLabel;
@synthesize locationLabel = _locationLabel;
@synthesize dateLabel = _dateLabel;
@synthesize groupNumberLabel = _groupNumberLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)updateCellDetail:(PFObject *)eventObject{
    
    
    _activityContentLabel.text = [eventObject objectForKey:kHLEventKeyDescription];
    
    
    
    _portraitImageView.image = [UIImage imageNamed:@"er"];
    
    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2;
    
    _portraitImageView.layer.masksToBounds = YES;
    
    _extraInfoLabel.text = @"aaaaaaaaaaaaajkdknfjksd";
    
    _dateLabel.text = @"今天";
    
    _groupNumberLabel.text = @"男女不限";

    
}

-(void)setUser:(PFUser *)aUser{
    
    
}

@end
