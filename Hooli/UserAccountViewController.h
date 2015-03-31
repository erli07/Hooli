//
//  UserAccountViewController.h
//  Hooli
//
//  Created by Er Li on 2/10/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) IBOutlet UIButton *contactButton;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *userID;

@property (nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *joinDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *selfIntroLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImage;
- (IBAction)followTheUser:(id)sender;
- (IBAction)contactUser:(id)sender;

@end
