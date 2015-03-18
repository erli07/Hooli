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
#import "ActivityLocationViewController.h"
#import "HLConstant.h"
#define text_color [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define light_grey [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]


@interface ActivityDetailViewController ()
@property (nonatomic) NSArray *detailArray;
@property (nonatomic) NSMutableArray *hostArray;
@property (nonatomic) NSMutableArray *participantArray;
@property (nonatomic) NSArray *iconsArray;
@property (nonatomic)  UIButton *inviteButton;
@property (nonatomic)  UIButton *joinButton;
@property (nonatomic) UIScrollView *parentScrollView;

@end

@implementation ActivityDetailViewController
@synthesize activityDetailTableView = _activityDetailTableView;
@synthesize detailArray = _detailArray;
@synthesize participantArray = _participantArray;
@synthesize hostArray = _hostArray;
@synthesize iconsArray = _iconsArray;
@synthesize inviteButton = _inviteButton;
@synthesize joinButton = _joinButton;
@synthesize activityDetail = _activityDetail;
@synthesize memberTableView = _memberTableView;
@synthesize parentScrollView = _parentScrollView;


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLItemDetailsReloadContentSizeNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContentsize) name:kHLItemDetailsReloadContentSizeNotification object:nil];
    
    self.title = @"详细";
    
    _detailArray = @[[_activityDetail objectForKey:kHLEventKeyDescription], [_activityDetail objectForKey:kHLEventKeyDateText], [_activityDetail objectForKey:kHLEventKeyEventLocation], @"微信群二维码"];
    // _hostArray = [[NSMutableArray alloc]initWithObjects:@"Eric", nil];
    _iconsArray = @[[UIImage imageNamed:@"megaphone-48"],[UIImage imageNamed:@"calender"],[UIImage imageNamed:@"location-map"],[UIImage imageNamed:@"wechat-48"]];
    _participantArray = [[NSMutableArray alloc]initWithObjects:@"Eric", nil];
    
    _parentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    [_parentScrollView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_parentScrollView];
    
    _activityDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 352) style:UITableViewStylePlain];
    
    _activityDetailTableView.scrollEnabled = NO;
    
    _activityDetailTableView.delegate = self;
    
    _activityDetailTableView.dataSource = self;
    
    [_parentScrollView addSubview:_activityDetailTableView];
    
    _memberTableView = [[ActivityMemberViewController alloc]initWithObject:_activityDetail];
    
    _memberTableView.view.frame = CGRectMake(0, _activityDetailTableView.frame.size.height + _activityDetailTableView.frame.origin.y - 1, 320, 300);
    
    _memberTableView.tableView.scrollEnabled = NO;
    
    [_parentScrollView addSubview:_memberTableView.view];
    
    [self reloadContentsize];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *rightBarButton1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareToFriends)];
    
    UIBarButtonItem *rightBarButton2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(shareToFriends)];
    
    NSArray *buttonsArray = @[rightBarButton1, rightBarButton2];
    
    self.navigationItem.rightBarButtonItems = buttonsArray;
    
    [self configureBottomButtons];
    
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.tintColor = [HLTheme mainColor];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    [self.navigationController.navigationBar setTranslucent:YES];
    
    //  _iconsArray = @[ [UIImage imageNamed:@"calender-icon"], [UIImage imageNamed:@"map-icon"],[UIImage imageNamed:@"comment-icon"]];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)reloadContentsize{
    
    [self.parentScrollView setContentSize:CGSizeMake(320, 760)];
    
}

-(void)configureBottomButtons{
    
    _inviteButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 523, 145, 35)];
    
    [_inviteButton addTarget:self action:@selector(joinEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [_inviteButton setBackgroundColor:[HLTheme buttonColor]];
    
    [_inviteButton setTitle:@"邀请" forState:UIControlStateNormal];
    
    _joinButton = [[UIButton alloc]initWithFrame:CGRectMake(165, 523, 145, 35)];
    
    [_joinButton addTarget:self action:@selector(joinEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [_joinButton setBackgroundColor:[HLTheme buttonColor]];
    
    [_joinButton setTitle:@"我要参加" forState:UIControlStateNormal];
    
    _joinButton.layer.cornerRadius = 10.0f;
    _joinButton.layer.masksToBounds = YES;
    
    _inviteButton.layer.cornerRadius = 10.0f;
    _inviteButton.layer.masksToBounds = YES;
    
    [self.view addSubview:_inviteButton];
    
    [self.view addSubview:_joinButton];
    
    [_inviteButton bringSubviewToFront:_activityDetailTableView];
    
    [_joinButton bringSubviewToFront:_activityDetailTableView];
    
}

-(void)shareToFriends{
    
    
}

-(void)joinEvent{
    
    PFQuery *queryExistingJoining = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    [queryExistingJoining whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeJoinEvent];
    [queryExistingJoining whereKey:kHLNotificationToUserKey equalTo: [_activityDetail objectForKey:kHLEventKeyHost]];
    [queryExistingJoining whereKey:kHLNotificationEventKey equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:_activityDetail.objectId]];
    [queryExistingJoining whereKey:kHLNotificationFromUserKey equalTo:[PFUser currentUser]];
    [queryExistingJoining setCachePolicy:kPFCachePolicyNetworkOnly];
    [queryExistingJoining getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
   
        if (object) {
            
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"你已经发出了活动申请" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
            return ;
            
        }
        else{
            
            UIAlertView *joinAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"确定参加？" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            
            joinAlert.tag = 1;
            
            [joinAlert show];

        }
        
    }];
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(tableView == _activityDetailTableView){
        
        return 2;
    }
    else{
        
        return 1;
        
    }
    
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        //for example [activityIndicator stopAnimating];
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _activityDetailTableView){
        
        if(indexPath.section == 0 && indexPath.row == 0 ){
            
            //return 180;
            return 76;
        }
        else if(indexPath.section == 1){
            
            if(indexPath.row == 0){
                
                return 88;
                
            }
        }
        
    }
    
    return 44.0f;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if(tableView == _activityDetailTableView){
        
        if(section == 0){
            
            return [_detailArray count];
            
        }
        
        else{
            
            return 1;
            
        }
        
    }
    else{
        
        return  [_participantArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(tableView == _activityDetailTableView){
        
        static NSString *kCellIdentifier = @"ActivityInfoCell";
        
        static NSString *kAnnoucementCellIdentifier = @"AnnoucementCell";
        
        
        if(indexPath.section == 0){
            
            UITableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
            
            if(detailCell == nil){
                
                //  cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
                detailCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
            }
            
            detailCell.textLabel.textColor = text_color;
            
            detailCell.textLabel.text = [_detailArray objectAtIndex:indexPath.row];
            
            [detailCell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
            
            detailCell.imageView.image = [_iconsArray objectAtIndex:indexPath.row];
            
            detailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            if(indexPath.row == 0){
                
                detailCell.accessoryType = UITableViewCellAccessoryNone;
                detailCell.textLabel.numberOfLines = 5;
                
            }
            
            return detailCell;
            
            
        }
        else {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAnnoucementCellIdentifier];
            
            if(cell == nil){
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAnnoucementCellIdentifier];
                
            }
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
            cell.textLabel.numberOfLines = 5;
            cell.textLabel.textColor = text_color;
            cell.imageView.image = [UIImage imageNamed:@"content"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = [_activityDetail objectForKey:kHLEventKeyAnnoucement];
            
            return cell;
            
        }
        
    }
    
    
    else{
        
//        static NSString *kParticipantCellIdentifier = @"ActivityMembertCell";
//        
//        UITableViewCell *memberCell = [tableView dequeueReusableCellWithIdentifier:kParticipantCellIdentifier];
//        
//        if(memberCell == nil){
//            
//            memberCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kParticipantCellIdentifier];
//            
//        }
//        
//        memberCell.textLabel.textColor = text_color;
//        
//        memberCell.detailTextLabel.textColor = [UIColor lightGrayColor];
//        
//        memberCell.textLabel.text = [_participantArray objectAtIndex:indexPath.row];
//        
//        [memberCell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
//        
//        [memberCell.detailTextLabel setFont:[UIFont systemFontOfSize:10.0f]];
//        
//        memberCell.detailTextLabel.text = @"iOS developer";
//        
//        memberCell.imageView.image = [UIImage imageNamed:@"rsz_1er"];
//        
//        memberCell.imageView.layer.cornerRadius = 16.0f;
//        
//        memberCell.imageView.layer.masksToBounds = YES;
        
        return nil;
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 10)];
    [label setFont:[UIFont boldSystemFontOfSize:11.0f]];
    
    [label setTextColor:[HLTheme textColor]];
    
    [view setBackgroundColor:light_grey]; //your background color...
    
    [view addSubview:label];
    
    if(tableView == _activityDetailTableView){
        
        if(section == 0){
            
            [label setText:[_activityDetail objectForKey:kHLEventKeyTitle]];
            
        }
        else {
            
            [label setText:@"公告"];
            
        }
        
    }
    else{
        
        [label setText:@"成员"];
        
    }
    
    return view;
    
    /* Section header is in 0th index... */
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    // NSString *titleForHeader = [NSString stringWithFormat:@"Comment"];
    
    if(tableView == _activityDetailTableView){
        
        if(section == 0){
            
            return  [_activityDetail objectForKey:kHLEventKeyTitle];
            
        }
        else {
            
            return  @"公告";
            
        }
    }
    else{
        return @"成员";
        
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 1){
            
            NSDateFormatter *dateFormater = [NSDateFormatter new];
            dateFormater.dateFormat = @"MM.dd HH:mm";
            NSString *msg = [dateFormater stringFromDate:[_activityDetail objectForKey:kHLEventKeyDate]];
            
            UIAlertView *addCalenderAlert =  [[UIAlertView alloc]initWithTitle:@"Add to calender?" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
            
            addCalenderAlert.tag = 0;
            
            [addCalenderAlert show];
            
            
        }
        else if(indexPath.row == 2){
            
            UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
            ActivityLocationViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"ActivityLocationViewController"];
            vc.showSearchBar = NO;
            vc.eventGeopoint = [_activityDetail objectForKey:kHLEventKeyEventGeoPoint];
            [self.navigationController pushViewController:vc animated:YES];
            
            
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
    
    if(alertView.tag == 0){
        if(buttonIndex == 0){
            
            
        }
        else{
            
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if (!granted) { return; }
                EKEvent *event = [EKEvent eventWithEventStore:store];
                event.title = [_activityDetail objectForKey:kHLEventKeyTitle];
                event.startDate = [_activityDetail objectForKey:kHLEventKeyDate];
                event.endDate = [event.startDate dateByAddingTimeInterval:60*60*24];  //set 1 hour meeting
                [event setCalendar:[store defaultCalendarForNewEvents]];
                NSError *err = nil;
                [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
                // NSString *savedEventId = event.eventIdentifier;  //this is so you can access this event later
            }];
            
        }
    }
    else if(alertView.tag == 1){
        
        if(buttonIndex == 0){
            
            
        }
        else{
            
            PFObject *joinEvent = [PFObject objectWithClassName:kHLCloudNotificationClass];
            [joinEvent setObject:[_activityDetail objectForKey:kHLEventKeyHost] forKey:kHLNotificationToUserKey];
            [joinEvent setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey];
            [joinEvent setObject:kHLNotificationTypeJoinEvent forKey:kHLNotificationTypeKey];
            [joinEvent setObject:[PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:_activityDetail.objectId] forKey:kHLNotificationEventKey];
            PFACL *joinEventACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [joinEventACL setPublicReadAccess:YES];
            [joinEventACL setWriteAccess:YES forUser:[_activityDetail objectForKey:kHLEventKeyHost]];
            joinEvent.ACL = joinEventACL;
            
            [joinEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"申请成功!" message:nil
                                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                    
                }
                
                
            }];

        }
        
    }
    
}
    

@end
