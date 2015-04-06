//
//  MySettingsViewController.m
//  Hooli
//
//  Created by Er Li on 11/21/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MySettingsViewController.h"
#import "HLTheme.h"
#import "AboutViewController.h"
#import "IntroViewController.h"
#import "AppDelegate.h"
#import "AccountManager.h"
#import "PushSettingsViewController.h"

@interface MySettingsViewController ()
@property (nonatomic)  NSArray *sectionArray;

@end

@implementation MySettingsViewController
@synthesize sectionArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.sectionArray = [[NSArray alloc]initWithObjects:@"",@"", nil];
    self.navigationController.navigationBarHidden = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            UIStoryboard *introSB = [UIStoryboard storyboardWithName:@"Intro" bundle:nil];
            IntroViewController *introVC = [introSB instantiateViewControllerWithIdentifier:@"IntroViewController"];
            introVC.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:introVC animated:NO];
            
        }
        else if(indexPath.row == 1){
            NSString *textToShare = @"海圈圈，您海外生活的好帮手!";
           // NSURL *myApp = [NSURL URLWithString:@"http://itunes.apple.com/app/id378458261"];
            
            NSArray *objectsToShare = @[textToShare];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                           UIActivityTypePrint,
                                           UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList,
                                           UIActivityTypePostToFlickr,
                                           UIActivityTypePostToVimeo];
            
            activityVC.excludedActivityTypes = excludeActivities;
            
            [self presentViewController:activityVC animated:YES completion:nil];
        }
        else{
            
            PushSettingsViewController *pvc = [[PushSettingsViewController alloc]init];
            
            [self.navigationController pushViewController:pvc animated:YES];
        }
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            [mailVC setSubject:@"My Subject"];
            [mailVC setMessageBody:@"Hello there. " isHTML:NO];
            [mailVC setToRecipients:[NSArray arrayWithObject:@"erli.0715@gmail.com"]];
            
            if (mailVC)
                
                [self presentViewController:mailVC animated:YES completion:^{
                    
                }];
            
            
        }
        else if(indexPath.row == 1){
            
            AboutViewController *about = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
            
        }
        
    }
    else if(indexPath.section == 2){
        
                UIAlertView *logoutAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                logoutAlert.delegate = self;
                [logoutAlert show];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"Intro";
            
        }
        else if(indexPath.row == 1){
            
            cell.textLabel.text = @"Share to Friends";
            
        }
        else if(indexPath.row == 2){
            
            cell.textLabel.text = @"Push notification settings";
            
        }
        
        
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"Send Feedback";
            
        }
        else{
            
            cell.textLabel.text = @"About";
        }
    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = @"Log Out";
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell setBackgroundColor:[HLTheme mainColor]];
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 3;
    else if(section == 1)
        return 2;
    else
        return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
    }
    else{
        
        [[AccountManager sharedInstance]logOut];
        
        UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
        vc.selectedIndex = 0;
        [self presentViewController:vc animated:NO completion:^{
            
            
        }];
    }
}
@end
