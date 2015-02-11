//
//  MyProfileDetailViewController.m
//  Hooli
//
//  Created by Er Li on 2/9/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "MyProfileDetailViewController.h"
#import "AccountManager.h"
#import "HLTheme.h"
#import "camera.h"

@interface MyProfileDetailViewController ()
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSArray *subtitleArray;
@property (nonatomic) UIImage *portraitImage;
@end

@implementation MyProfileDetailViewController
@synthesize userId,user;
@synthesize titleArray = _titleArray;
@synthesize subtitleArray = _subtitleArray;
@synthesize portraitImage = _portraitImage;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[@"Username",@"Gender", @"Email",@"Phone Number",@"Wechat"];
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:self.user.objectId Success:^(id object) {
        
        PFFile *imageFile = [object objectForKey:kHLUserModelKeyPortraitImage];
        _portraitImage = [UIImage imageWithData:[imageFile getData]];
        NSString *email = [object objectForKey:kHLUserModelKeyEmail];
        NSString *username = [object objectForKey:kHLUserModelKeyUserName];
        _subtitleArray = @[username, @"Male", email,@"6179557673", @"eric_boston"];
        [self.tableView reloadData];
        
    } Failure:^(id error) {
        
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0){
        
        return 1;
        
    }
    else{
        
        return 5;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        
        static NSString *imageCellID = @"imageProfileDetailCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:imageCellID];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellID];
            
        }
        
        cell.textLabel.text =@"click to edit";
        cell.textLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = _portraitImage;
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;
        cell.imageView.layer.masksToBounds = YES;
        
    }
    else{
        
        static NSString *cellID = @"profileDetailCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:11.0f];
        cell.detailTextLabel.text = [_subtitleArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:14.0f];
        
    }
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 88;
    }
    else{
        return 64;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {

    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    [action showInView:self.view];
        
    }
    else if (indexPath.section == 1){
        
        
    }
    

}


#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex == 0)	ShouldStartCamera(self, YES);
        if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
    }
}


/*
  // Override to support conditional editing of the table view.
  - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  // Return NO if you do not want the specified item to be editable.
  return YES;
  }
  */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
