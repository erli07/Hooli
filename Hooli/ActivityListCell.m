//
//  ActivityListCell.m
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityListCell.h"
#import "HLConstant.h"
#import "LocationManager.h"
#import "TTTTimeIntervalFormatter.h"

static TTTTimeIntervalFormatter *timeFormatter;

@implementation ActivityListCell

@synthesize eventImage1,eventImage2,eventImage3;
//@property (weak, nonatomic) IBOutlet UILabel *activityContentLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
//@property (weak, nonatomic) IBOutlet UILabel *extraInfoLabel;
//@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *groupNumberLabel;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)updateCellDetail:(PFObject *)eventObject{
    

    PFUser *eventHost = [eventObject objectForKey:kHLEventKeyHost];
        
    PFFile *portraitImageFile = [eventHost objectForKey:kHLUserModelKeyPortraitImage];
    
    NSData *imageData = [portraitImageFile getData];
    
    self.portraitImageView.image = [UIImage imageWithData:imageData];
    
    self.userNameLabel.text = [eventHost objectForKey:kHLUserModelKeyUserName];
    
    self.activityContentLabel.text = [eventObject objectForKey:kHLEventKeyDescription];
    
    self.activityTitleLabel.text = [eventObject objectForKey:kHLEventKeyTitle];
    
    self.userGenderImageView.image = [UIImage imageNamed:@"male_symbol"];
    
    self.activityInfoLabel.text  = [NSString stringWithFormat:@"%@ | %@ | %@人", [eventObject objectForKey:kHLEventKeyEventLocation], @"今天",  [eventObject objectForKey:kHLEventKeyMemberNumber]];
    

    PFGeoPoint *userGeoPoint = [eventObject objectForKey:kHLEventKeyUserGeoPoint];
    
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(userGeoPoint.latitude, userGeoPoint.longitude);
    
    
    if (!timeFormatter) {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    self.userInfoLabel.text = [NSString stringWithFormat:@"%@ | %@",[[LocationManager sharedInstance]getApproximateDistanceInKm:userLocation], [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[eventObject createdAt]]];
    
    PFObject *eventImages = [eventObject objectForKey:kHLEventKeyImages];
    
   PFFile *imageFile0 = [eventImages objectForKey:@"imageFile0"];
    
    if (imageFile0 ) {
        
        [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if(!error){
                
                self.eventImage1.image = [UIImage imageWithData:data];
                
            }
        }];
    }
    else{
        
        self.eventImage1.image = [UIImage imageNamed:@"hotpot_3.png"];
    }
    
    PFFile *imageFile1 = [eventImages objectForKey:@"imageFile1"];
    
    if (imageFile1) {
        
        [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if(!error){
                
                self.eventImage2.image = [UIImage imageWithData:data];
                
            }
        }];
    }
    else{
        
        self.eventImage2.image = nil;
        
    }
    
    PFFile *imageFile2 = [eventImages objectForKey:@"imageFile2"];
    
    if (imageFile2) {
        
        [imageFile2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if(!error){
                
                self.eventImage3.image = [UIImage imageWithData:data];
                
            }
        }];
    }
    else{
        
        self.eventImage3.image = nil;
        
    }

    
//    _activityContentLabel.text = [eventObject objectForKey:kHLEventKeyDescription];
//    
//    
//    _portraitImageView.image = [UIImage imageNamed:@"er"];
//    
//    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2;
//    
//    _portraitImageView.layer.masksToBounds = YES;
//    
//    _extraInfoLabel.text = @"aaaaaaaaaaaaajkdknfjksd";
//    
//    _dateLabel.text = @"今天";
//    
//    _groupNumberLabel.text = @"男女不限";

    
}

-(void)setUser:(PFUser *)aUser{
    
    
}

@end
