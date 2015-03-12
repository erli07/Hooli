//
//  ActivityListCell.h
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ActivityListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *activityContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UILabel *extraInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNumberLabel;

-(void)updateCellDetail:(PFObject *)eventObject;
-(void)setUser:(PFUser *)aUser;

@end
