//
//  ActivityDetailViewController.m
//  Hooli
//
//  Created by Er Li on 1/7/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import <EventKit/EventKit.h>
#import "MapViewController.h"
#import "ItemCommentViewController.h"
#import "LocationManager.h"
#import "HLTheme.h"
@interface ActivityDetailViewController ()
@property (nonatomic) NSArray *detailArray;
@property (nonatomic) NSMutableArray *hostArray;
@property (nonatomic) NSMutableArray *participantArray;
@property (nonatomic) NSArray *iconsArray;
@property (nonatomic)  UIButton *inviteButton;
@property (nonatomic)  UIButton *joinButton;

@end

@implementation ActivityDetailViewController
@synthesize activityDetailTableView = _activityDetailTableView;
@synthesize detailArray = _detailArray;
@synthesize participantArray = _participantArray;
@synthesize hostArray = _hostArray;
@synthesize iconsArray = _iconsArray;
@synthesize inviteButton = _inviteButton;
@synthesize joinButton = _joinButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _detailArray = @[@"Title", @"Calender", @"Location", @"Comment" ];
    _hostArray = [[NSMutableArray alloc]initWithObjects:@"Eric", nil];
    _participantArray = [[NSMutableArray alloc]initWithObjects:@"Lucy", @"Emily", @"Jack", @"Tom", @"Emily", @"Jack", @"Tom", nil];
    
    [self configureBottomButtons];
     //  _iconsArray = @[ [UIImage imageNamed:@"calender-icon"], [UIImage imageNamed:@"map-icon"],[UIImage imageNamed:@"comment-icon"]];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)configureBottomButtons{
    
    _inviteButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 513, 145, 44)];
    
    [_inviteButton setBackgroundColor:[HLTheme mainColor]];
    
    [_inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    
    _joinButton = [[UIButton alloc]initWithFrame:CGRectMake(165, 513, 145, 44)];
    
    [_joinButton setBackgroundColor:[HLTheme mainColor]];
    
    [_joinButton setTitle:@"I'm in" forState:UIControlStateNormal];
    
    [self.view addSubview:_inviteButton];
    
    [self.view addSubview:_joinButton];
    
    [_inviteButton bringSubviewToFront:_activityDetailTableView];
    
    [_joinButton bringSubviewToFront:_activityDetailTableView];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0){
        
        return [_detailArray count];
        
    }
    else if(section == 1){
        
        return 1;
        
    }
    else if(section == 2){
        
        return [_hostArray count];
        
    }
    else{
        
        return [_participantArray count];
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"ActivityDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        
    }

    if(indexPath.section == 0){
        
        cell.textLabel.text = [_detailArray objectAtIndex:indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //cell.imageView.image = [UIImage imageNamed:@"calender_bw"];
        
    }
    else if(indexPath.section == 1){
        
        cell.textLabel.text = @"detail";
        
    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = [_hostArray objectAtIndex:indexPath.row];
        
    }
    else{
        
        cell.textLabel.text = [_participantArray objectAtIndex:indexPath.row];
        
    }
    
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, tableView.frame.size.width, 12)];
//    [label setFont:[UIFont boldSystemFontOfSize:12.0f]];
//    NSString *titleForHeader = [NSString stringWithFormat:@"Comment"];
//    /* Section header is in 0th index... */
//    [label setText:titleForHeader];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
//    return view;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
   // NSString *titleForHeader = [NSString stringWithFormat:@"Comment"];
    
    if(section == 0){
        
        return  nil;
        
    }
    else if(section == 1){
        
        return  @"Detail";
        
    }
    else if(section == 2){
        
        return @"1 Hosting";
        
    }
    else{
        
        return @"5 Going";
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 1){
            
            UIAlertView *addCalenderAlert =  [[UIAlertView alloc]initWithTitle:@"Add to calender?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
            
            [addCalenderAlert show];
            
            
        }
        else if(indexPath.row == 2){
            
            [self performSegueWithIdentifier:@"seeMap" sender:self];
            
            
        }
        else if(indexPath.row == 3){
            
            [self performSegueWithIdentifier:@"seeItemComment" sender:self];
            
        }
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"seeMap"])
    {
        MapViewController *mapVC = segue.destinationViewController;
        mapVC.offerLocation = [[LocationManager sharedInstance]currentLocation];
        mapVC.hidesBottomBarWhenPushed = YES;
    }
    else if([segue.identifier isEqualToString:@"seeItemComment"])
    {
        ItemCommentViewController *commentVC = segue.destinationViewController;
        commentVC.hidesBottomBarWhenPushed = YES;
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
        
    }
    else{
        
        EKEventStore *store = [[EKEventStore alloc] init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (!granted) { return; }
            EKEvent *event = [EKEvent eventWithEventStore:store];
            event.title = @"Event Title";
            event.startDate = [NSDate date]; //today
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            [event setCalendar:[store defaultCalendarForNewEvents]];
            NSError *err = nil;
            [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
           // NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
        }];

        
    }
    
    
}

@end
