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
#import "KZImageViewer.h"
#import "KZImage.h"
#import "KZPhotoBrowser.h"

#define kScreenHeight         [UIScreen mainScreen].bounds.size.height
#define kScreenWidth          [UIScreen mainScreen].bounds.size.width

static TTTTimeIntervalFormatter *timeFormatter;

@implementation ActivityListCell

@synthesize eventImage1,eventImage2,eventImage3,imagesArray;

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
    
    if([[eventHost objectForKey:kHLUserModelKeyGender] isEqualToString:@"Male"]){
        
        self.userGenderImageView.image = [UIImage imageNamed:@"male_symbol"];
        
    }
    else{
        
        self.userGenderImageView.image = [UIImage imageNamed:@"female_symbol"];
        
    }
    
    PFGeoPoint *geoPoint = [eventObject objectForKey:kHLEventKeyEventGeoPoint];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"ccc d MMM"];
    NSString *week = [dateFormatter stringFromDate:[eventObject objectForKey:kHLEventKeyDate]];
    
    [[LocationManager sharedInstance]convertGeopointToAddressWithGeoPoint:coord
                                                                    block:^(NSString *address, NSError *error) {
                                                                        
                                                                        if([[eventObject objectForKey:kHLEventKeyMemberNumber] intValue] > 0){
                                                                            
                                                                            self.activityInfoLabel.text  = [NSString stringWithFormat:@"%@ | %@ | %@人", address,week,  [eventObject objectForKey:kHLEventKeyMemberNumber]];
                                                                            
                                                                        }
                                                                        else{
                                                                            self.activityInfoLabel.text  = [NSString stringWithFormat:@"%@ | %@ | %@", address,week,  [eventObject objectForKey:kHLEventKeyMemberNumber]];
                                                                            
                                                                        }
                                                                    }];
    
    self.activityCategoryImageView.image = [self getActivityCategoryImageFromString:[eventObject objectForKey:kHLEventKeyCategory]];
    
    PFGeoPoint *userGeoPoint = [eventObject objectForKey:kHLEventKeyUserGeoPoint];
    
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(userGeoPoint.latitude, userGeoPoint.longitude);
    
    if (!timeFormatter) {
        timeFormatter = [[TTTTimeIntervalFormatter alloc] init];
    }
    
    self.userInfoLabel.text = [NSString stringWithFormat:@"%@ | %@",[[LocationManager sharedInstance]getApproximateDistanceInKm:userLocation], [timeFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:[eventObject createdAt]]];
    
    self.imagesArray = [NSMutableArray new];
    
    PFObject *eventImages = [eventObject objectForKey:kHLEventKeyImages];
    
    PFFile *imageFile0 = [eventImages objectForKey:@"imageFile0"];
    
    if (imageFile0 ) {
        
        [imageFile0 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if(!error){
                
                UIImage *image1 = [UIImage imageWithData:data];
                
                [self.imagesArray addObject:image1];
                
                [self.eventImageButton1 setBackgroundImage:image1 forState:UIControlStateNormal];
                
                self.eventImageButton1.hidden = NO;
                
            }
        }];
    }
    else{
        
        self.eventImageButton1.hidden = YES;
        
        [self.eventImageButton1 setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    
    
    PFFile *imageFile1 = [eventImages objectForKey:@"imageFile1"];
    
    if (imageFile1) {
        
        [imageFile1 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if(!error){
                
                UIImage *image2 = [UIImage imageWithData:data];
                
                [self.imagesArray addObject:image2];
                
                self.eventImageButton2.hidden = NO;
                
                [self.eventImageButton2 setBackgroundImage:image2 forState:UIControlStateNormal];
                
            }
        }];
    }
    else{
        
        self.eventImageButton2.hidden = YES;
        
        [self.eventImageButton2 setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    
    PFFile *imageFile2 = [eventImages objectForKey:@"imageFile2"];
    
    if (imageFile2) {
        
        [imageFile2 getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if(!error){
                
                UIImage *image3 = [UIImage imageWithData:data];
                
                [self.imagesArray addObject:image3];
                
                self.eventImageButton3.hidden = NO;
                
                [self.eventImageButton3 setBackgroundImage:image3 forState:UIControlStateNormal];
                
            }
        }];
    }
    else{
        
        self.eventImageButton3.hidden = YES;
        
        [self.eventImageButton3 setBackgroundImage:nil forState:UIControlStateNormal];
        
    }
    
    
}

-(void)setUser:(PFUser *)aUser{
    
    
}


-(UIImage *)getActivityCategoryImageFromString:(NSString *)category{
    
    
    
    if([category isEqualToString:@"吃货小分队"]){
        
        return [UIImage imageNamed:@"restaurant-48"];
    }
    else if([category isEqualToString:@"体育健身"]){
        
        return [UIImage imageNamed:@"basketball-48"];
        
    }
    else if([category isEqualToString:@"学术会议"]){
        
        return [UIImage imageNamed:@"study-48"];
        
    }
    else if([category isEqualToString:@"娱乐活动"]){
        
        return [UIImage imageNamed:@"movie-48"];
        
    }
    else if([category isEqualToString:@"户外旅行"]){
        
        return [UIImage imageNamed:@"backpack-48"];
        
    }
    else if([category isEqualToString:@"电子游戏"]){
        
        return [UIImage imageNamed:@"controller-48"];
        
    }
    else if([category isEqualToString:@"逛街购物"]){
        
        return [UIImage imageNamed:@"shopping_bag-48"];
        
    }
    else{
        
        return nil;
    }
    
}





- (IBAction)eventImageButtonPressed:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"event image %ld pressed", (long)button.tag);
    
    NSMutableArray  *kzImageArray = [NSMutableArray array];
    
    for (int i = 0; i < [self.imagesArray count]; i++)
    {
        UIImageView *imageView =  [[UIImageView alloc]init];
        imageView.image = [self.imagesArray objectAtIndex:i];
        KZImage *kzImage = [[KZImage alloc] initWithImage:[self.imagesArray objectAtIndex:i]];
        kzImage.thumbnailImage = [self.imagesArray objectAtIndex:i];
        
        kzImage.srcImageView = imageView;
        [kzImageArray addObject:kzImage];
    }
    KZImageViewer *imageViewer = [[KZImageViewer alloc] init];
    [imageViewer showImages:kzImageArray atIndex:button.tag];
    
}
@end
