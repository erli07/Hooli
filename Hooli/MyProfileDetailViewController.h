//
//  MyProfileDetailViewController.h
//  Hooli
//
//  Created by Er Li on 2/9/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EditProfileDetailViewController.h"
#import "EditProfileViewController.h"
#import "AccountManager.h"
#import "HLTheme.h"
#import "camera.h"

@interface MyProfileDetailViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate>
@property (nonatomic) NSString* userId;
@property (nonatomic) PFUser *user;
@end
