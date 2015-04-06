//
//  PushSettingsViewController.m
//  Hooli
//
//  Created by Er Li on 4/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "PushSettingsViewController.h"
#import "HLSettings.h"
@interface PushSettingsViewController ()
@property (nonatomic) UISwitch *pushSwitch;
@end

@implementation PushSettingsViewController
@synthesize pushSwitch = _pushSwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UILabel  *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 100, 30)];
    label.text = @"消息免打扰";
    _pushSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(220, 100, 64, 30)];
    [_pushSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pushSwitch];
    [self.view addSubview:label];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if([[HLSettings sharedInstance]getPushFlag]){
        
        [_pushSwitch setOn:YES];
    }
    else{
        
        [_pushSwitch setOn:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if(!_pushSwitch.on){
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    }
    else{
        
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
    }
    
}

- (void)changeSwitch:(id)sender{
    
    if([sender isOn]){
        
        [[HLSettings sharedInstance]savePushFlag:YES];
        NSLog(@"Switch is ON");
    } else{
        
        [[HLSettings sharedInstance]savePushFlag:NO];
        NSLog(@"Switch is OFF");
    }
}

@end
