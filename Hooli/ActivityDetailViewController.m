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
#import "ActivityDetailCell.h"
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
    
    self.title = @"周末去白山阿拉斯加州!";
    
    _detailArray = @[@"周末去白山hiking!", @"March 7th Saturday ", @"White Mountain", @"人数不限",@"讨论区"];
    // _hostArray = [[NSMutableArray alloc]initWithObjects:@"Eric", nil];
    _participantArray = [[NSMutableArray alloc]initWithObjects:@"Eric", @"Lucy", @"Emily", @"Jack",@"Lucy", @"Emily", @"Jack",@"Lucy", @"Emily", @"Jack", nil];
    
    [self configureBottomButtons];
    
    CGRect newFrame = CGRectMake(_activityDetailTableView.frame.origin.x, _activityDetailTableView.frame.origin.y , _activityDetailTableView.frame.size.width, _activityDetailTableView.frame.size.height + 64);
    
    [_activityDetailTableView setFrame: newFrame];
    //    [_activityDetailTableView beginUpdates];
    //    [_activityDetailTableView endUpdates];
    //
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareToFriends)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.tintColor = [HLTheme mainColor];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    [self.navigationController.navigationBar setTranslucent:YES];
    
    //  _iconsArray = @[ [UIImage imageNamed:@"calender-icon"], [UIImage imageNamed:@"map-icon"],[UIImage imageNamed:@"comment-icon"]];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)configureBottomButtons{
    
    _inviteButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 523, 145, 35)];
    
    [_inviteButton setBackgroundColor:[HLTheme mainColor]];
    
    [_inviteButton setTitle:@"Invite" forState:UIControlStateNormal];
    
    _joinButton = [[UIButton alloc]initWithFrame:CGRectMake(165, 523, 145, 35)];
    
    [_joinButton setBackgroundColor:[HLTheme mainColor]];
    
    [_joinButton setTitle:@"I'm in" forState:UIControlStateNormal];
    
    [self.view addSubview:_inviteButton];
    
    [self.view addSubview:_joinButton];
    
    [_inviteButton bringSubviewToFront:_activityDetailTableView];
    
    [_joinButton bringSubviewToFront:_activityDetailTableView];
    
}

-(void)shareToFriends{
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0 && indexPath.row == 0 ){
        
        //return 180;
        return 88;
    }
    else if(indexPath.section == 1){
        
        if(indexPath.row == 0){
            
            return 88;
            
        }
    }
    
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
    else{
        
        return [_participantArray count];
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"ActivityInfoCell";
    
    static NSString *kAnnoucementCellIdentifier = @"AnnoucementCell";
    
    //  static NSString *kDetailCellIdentifier = @"ActivityDetailCell";
    
    static NSString *kParticipantCellIdentifier = @"ActivityParticipantCell";
    
    
    
    //    if(indexPath.section == 0 && indexPath.row == 0){
    //
    //        ActivityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kDetailCellIdentifier];
    //
    //        if(cell == nil){
    //
    //            [tableView registerNib:[UINib nibWithNibName:kDetailCellIdentifier bundle:nil] forCellReuseIdentifier:kDetailCellIdentifier];
    //            cell = [[ActivityDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDetailCellIdentifier];
    //
    //        }
    //
    //        return cell;
    //
    //
    //    }
    //    else{
    
    
    
    
    
    
    if(indexPath.section == 0){
        
        UITableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        
        if(detailCell == nil){
            
            //  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
            detailCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
        }
        
        
        detailCell.textLabel.text = [_detailArray objectAtIndex:indexPath.row];
        
        [detailCell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        
        detailCell.imageView.image = [UIImage imageNamed:@"calender_bw"];
        
        detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if(indexPath.row == 0){
            
            detailCell.accessoryType = UITableViewCellAccessoryNone;
            detailCell.textLabel.text = @"寻人一起去white mountain郊游 冬天过去了 大家一起出去happy吧 寻人一起去white mountain郊游 冬天过去了 大家一起出去happy吧 ^_^";
            detailCell.textLabel.numberOfLines = 5;
            
        }
        
        return detailCell;

        
    }
    else if(indexPath.section == 1){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnnoucementCellIdentifier];
        
        if(cell == nil){
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAnnoucementCellIdentifier];
            
        }
        
        //   if(indexPath.row == 0){
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        cell.textLabel.numberOfLines = 5;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"请加微信群 我们会安排carpool 油费由司机以外的共同承担 初定于周六早上10点到达 地址为 white Mountain 111 NH 谢谢大家支持 ^_^";
        //    }
        //        else{
        //
        //            cell.imageView.image = [UIImage imageNamed:@"calender_bw"];
        //            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
        //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //            cell.textLabel.text = @"讨论区";
        //        }
        return cell;

    }
    else{
        
        UITableViewCell *memberCell = [tableView dequeueReusableCellWithIdentifier:kParticipantCellIdentifier];
        
        if(memberCell == nil){
            
            memberCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kParticipantCellIdentifier];
            
        }
        
        memberCell.textLabel.text = [_participantArray objectAtIndex:indexPath.row];
        
        memberCell.imageView.image = [UIImage imageNamed:@"er"];
        
        memberCell.imageView.layer.cornerRadius = 22;
        
        memberCell.imageView.layer.masksToBounds = YES;

        return memberCell;

    }
    
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
        
        return  @"公告栏";
        
    }
    else{
        
        return @"参加者";
        
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
            
            //[self performSegueWithIdentifier:@"seeItemComment" sender:self];
            
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
