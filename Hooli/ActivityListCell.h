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
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userGenderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage1;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage2;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage3;
@property (nonatomic) NSMutableArray *imagesArray;

@property (weak, nonatomic) IBOutlet UIButton *eventImageButton1;
@property (weak, nonatomic) IBOutlet UIButton *eventImageButton2;
@property (weak, nonatomic) IBOutlet UIButton *eventImageButton3;


- (IBAction)eventImageButtonPressed:(id)sender;



-(void)updateCellDetail:(PFObject *)eventObject;
-(void)setUser:(PFUser *)aUser;

@end
