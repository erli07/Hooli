//
//  ActivityListCell.m
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityListCell.h"

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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        
            _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2;
        
            _portraitImageView.layer.masksToBounds = YES;
   
    }
    
    return self;
}



-(void)updateCellDetails{
    
//    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2;
//    
//    _portraitImageView.layer.masksToBounds = YES;
    
//    _activityContentLabel.text = @"寻人一起去white mountain郊游 我可以开车 冬天过去了 大家一起出去happy吧 ^_^";
//    
//    _portraitImageView.image = [UIImage imageNamed:@"er"];
//    
//    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2;
//    
//    _portraitImageView.layer.masksToBounds = YES;
//    
//    _extraInfoLabel.text = @"aaaaaaaaaaaaajkdknfjksd";
//    
//    _dateLabel.text = @"本周五";
//    
//    _groupNumberLabel.text = @"5人参加";
    

}
@end
