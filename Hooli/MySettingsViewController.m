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
         
         NSString *textToShare = @"Use Hooli to sell your unused stuff!";
         NSURL *myApp = [NSURL URLWithString:@"http://itunes.apple.com/app/id378458261"];
         
         NSArray *objectsToShare = @[textToShare, myApp];
         
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
     else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            MFMailComposeViewController* mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            [mailVC setSubject:@"My Subject"];
            [mailVC setMessageBody:@"Hello there." isHTML:NO];
            [mailVC setToRecipients:[NSArray arrayWithObject:@"123@gmail.com"]];
            
            if (mailVC)
                
                [self presentViewController:mailVC animated:YES completion:^{
                    
                }];
            
            
        }
        else if(indexPath.row == 1){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/app/id378458261"]];
        }
        else if(indexPath.row == 2){
            
            AboutViewController *about = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:about animated:YES];
            
        }
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"FAQ";
            
        }
        else if(indexPath.row == 1){
            
            cell.textLabel.text = @"Share to Friends";
            
        }
        
        
        
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            cell.textLabel.text = @"Send Feedback";
            
        }
        else if(indexPath.row == 1){
            
            cell.textLabel.text = @"Rate Us";
            
        }
        else{
            
            cell.textLabel.text = @"About Hooli";
        }
    }
    
    
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
        return 2;
    else
        return 3;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  2;
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
@end
