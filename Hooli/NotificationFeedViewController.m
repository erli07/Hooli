//
//  NotificationFeedViewController.m
//  Hooli
//
//  Created by Er Li on 1/27/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "NotificationFeedViewController.h"
#import "HLConstant.h"
#import "NotificationTableViewCell.h"
#import "MBProgressHUD.h"
#import "ItemDetailViewController.h"
#import "ChatView.h"
#import "messages.h"
#import "HLSettings.h"
#import "OffersManager.h"
#import "UserCartViewController.h"
#import "FollowListCell.h"
#import "NeedDetailViewController.h"
#import "NeedTableViewCell.h"
#import "HLUtilities.h"
#import "ActivityManager.h"
#import "ActivityDetailViewController.h"
#import "PAPLoadMoreCell.h"

@interface NotificationFeedViewController ()
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) PFUser *toUser;
@property (nonatomic, strong) NSString *bidPrice;
@property (nonatomic, strong) PFObject *eventObject;
@end

@implementation NotificationFeedViewController
@synthesize lastRefresh,blankView;
@synthesize notification = _notification;
@synthesize bidPrice = _bidPrice;
@synthesize toUser = _toUser;
@synthesize eventObject = _eventObject;

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudNotificationClass;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kHLLoadFeedObjectsNotification object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[HLSettings sharedInstance]setCurrentPageIndex:2];
    
    if(![HLUtilities checkIfUserLoginWithCurrentVC:self]){
        
        return;
        
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.title = @"Notification";
    
    // Add Settings button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:kHLLoadFeedObjectsNotification object:nil];
    
    self.blankView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [self.blankView setBackgroundColor:[UIColor whiteColor]];
    UILabel *noContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 44)];
    noContentLabel.text = @"No content at the moment";
    noContentLabel.textColor = [UIColor lightGrayColor];
    noContentLabel.font = [UIFont systemFontOfSize:17.0f];
    noContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.blankView addSubview:noContentLabel];
    
    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kHlUserDefaultsActivityFeedViewControllerLastRefreshKey];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[HLSettings sharedInstance]setCurrentPageIndex:2];
    
    if(![HLUtilities checkIfUserLoginWithCurrentVC:self]){
        
        return;
        
    }
    
    //[self.tableView reloadData];
    
}

- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kHLNotificationToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kHLNotificationFromUserKey notEqualTo:[PFUser currentUser]];
    [query whereKeyExists:kHLNotificationFromUserKey];
    [query includeKey:kHLNotificationFromUserKey];
    [query includeKey:kHLNotificationToUserKey];
    [query includeKey:kHLNotificationOfferKey];
    [query includeKey:kHLNotificationEventKey];
    [query orderByDescending:@"createdAt"];
    
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}


- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    lastRefresh = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:lastRefresh forKey:kHlUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        //  self.navigationController.tabBarItem.badgeValue = nil;
        
        if (!self.blankView.superview) {
            self.blankView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankView;
            [UIView animateWithDuration:0.200f animations:^{
                self.blankView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"NotificationFeedCell";
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    PFUser *fromUser = [object objectForKey:kHLNotificationFromUserKey];
        
    [cell setUser:fromUser];
    
    [cell setNotification:object];
    
    //    if ([lastRefresh compare:[object createdAt]] == NSOrderedAscending) {
    //        [cell setIsNew:YES];
    //    } else {
    //        [cell setIsNew:NO];
    //    }
    //
    //  [cell hideSeparator:(indexPath.row == self.objects.count - 1)];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.objects.count) {
        
        _notification = [self.objects objectAtIndex:indexPath.row];
        
        if ([[_notification objectForKey:kHLNotificationTypeKey]isEqualToString:kHLNotificationTypeFollow]) {
            
            [self seeUserDetail];
            
        }
        else if ([[_notification objectForKey:kHLNotificationTypeKey]isEqualToString:khlNotificationTypMakeOffer]) {
            
            [[OffersManager sharedInstance]getOfferSoldStatusWithOfferID:[[_notification objectForKey:kHLNotificationOfferKey]objectId] block:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"This item has been sold." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                }
                else{
                    
                    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                            @"Contact",
                                            @"See offer detail",
                                            nil];
                    
                    _bidPrice = [_notification objectForKey:kHLNotificationContentKey];
                    _toUser = [_notification objectForKey:kHLNotificationFromUserKey];
                    
                    popup.tag = 1;
                    [popup showInView:[UIApplication sharedApplication].keyWindow];
                }
            }];
        }
        else if ([[_notification objectForKey:kHLNotificationTypeKey]isEqualToString:kHLNotificationTypeOfferComment]) {
            
            [self seeOfferDetail];
        }
        else if ([[_notification objectForKey:kHLNotificationTypeKey]isEqualToString:kHLNotificationTypeNeedComment]) {
            
            [self seeNeedDetail];
        }
        else if ([[_notification objectForKey:kHLNotificationTypeKey]isEqualToString:kHLNotificationTypeJoinEvent]) {
            
            [self seeEventDetail];

//            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
//                                    @"Accept",
//                                    @"Decline",
//                                    nil];
//            popup.tag = 2;
//            [popup showInView:[UIApplication sharedApplication].keyWindow];
            
            _toUser = [_notification objectForKey:kHLNotificationFromUserKey];
            _eventObject = [_notification objectForKey:kHLNotificationEventKey];
            
        }
        
    } else if (self.paginationEnabled) {
        
        [self loadNextPage];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        //  cell.separatorImageTop.image = [UIImage imageNamed:@"SeparatorTimelineDark.png"];
        cell.hideSeparatorBottom = YES;
        cell.mainView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row < self.objects.count) {
    //        PFObject *object = [self.objects objectAtIndex:indexPath.row];
    //        NSString *notificationStr= [NotificationFeedViewController stringForNotificationType:(NSString*)[object objectForKey:kHLNotificationTypeKey]];
    //
    //        PFUser *user = (PFUser*)[object objectForKey:kHLNotificationFromUserKey];
    //        NSString *nameString = @"Someone";
    //
    //        if (user && [user objectForKey:kHLUserModelKeyUserName] && [[user objectForKey:kHLUserModelKeyUserName] length] > 0) {
    //            nameString = [user objectForKey:kHLUserModelKeyUserName];
    //        }
    //
    //        return [NotificationTableViewCell heightForCellWithName:nameString contentString:notificationStr];
    //    } else {
    //        return 44.0f;
    //    }
    
    return 59.0f;
}

+ (NSString *)stringForNotificationType:(NSString *)notificationType {
    
    if ([notificationType isEqualToString:kHLNotificationTypeLike]) {
        return NSLocalizedString(@"liked your item", nil);
    } else if ([notificationType isEqualToString:kHLNotificationTypeFollow]) {
        return NSLocalizedString(@"started following you", nil);
    } else if ([notificationType isEqualToString:kHLNotificationTypeOfferComment]) {
        return NSLocalizedString(@"commented on item", nil);
//    } else if ([notificationType isEqualToString:kHLNotificationTypeNeedComment]){
//        return NSLocalizedString(@"commented on your need", nil);
//    } else if ([notificationType isEqualToString:kHLNotificationTypeJoined]) {
//        return NSLocalizedString(@"joined Hooli", nil);
    } else if ([notificationType isEqualToString:khlNotificationTypMakeOffer]){
        return NSLocalizedString(@"bid on your item for", nil);
//    }else if ([notificationType isEqualToString:khlNotificationTypOfferItem]){
//        return NSLocalizedString(@"offer you an item", nil);
//    }else if ([notificationType isEqualToString:khlNotificationTypAcceptOffer]){
//        return NSLocalizedString(@"has accepted your bid", nil);
//    }else if ([notificationType isEqualToString:khlNotificationTypeOfferSold]){
//        return NSLocalizedString(@"Sorry,item has been sold.", nil);
//    }
//    else if ([notificationType isEqualToString:kHLNotificationTypeActivityComment]){
//        return NSLocalizedString(@"comment on your event", nil);
    }
    else if ([notificationType isEqualToString:kHLNotificationTypeJoinEvent]){
        return NSLocalizedString(@"has joined your event", nil);
    }
    else  {
        return nil;
    }
    
}

-(void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
//                case 0:
//                {
//                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to accept this bid?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//                    
//                    
//                    alertView.tag = 0;
//                    
//                    [alertView show];
//                }
//                    
//                    break;
//                    
                case 0:
                    
                    [self startChattingWithBidder];
                    break;
                    
                case 1:
                    
                    [self seeOfferDetail];
                    break;
                    
                    
                    
                default:
                    break;
            }
            break;
        }
        case 2:{
            switch (buttonIndex) {
                case 0:{
                    
                    if(_eventObject && _toUser){
                        
                                               
                    }
                    
                }
                    break;
                    
                case 1:{
                    
                    
                    PFQuery *deleteQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
                    [deleteQuery whereKey:kHLNotificationFromUserKey equalTo:_toUser];
                    [deleteQuery setCachePolicy:kPFCachePolicyNetworkOnly];
                    [deleteQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        
                        if(object){
                            
                            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                if(succeeded){
                                    
                                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"You have declined the request." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    
                                    [alertView show];
                                    
                                    [self loadObjects];
                                }
                            }];
                        }
                        
                    }];
                    
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }
        default:
            break;
    }
}

-(void)seeUserDetail{
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userAccount"];
    vc.userID = [[_notification objectForKey:kHLNotificationFromUserKey]objectId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)seeOfferDetail{
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
    vc.offerId = [[_notification objectForKey:kHLNotificationOfferKey]objectId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)seeEventDetail{
    
    ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc]init];
    detailVC.activityDetail = [_notification objectForKey:kHLNotificationEventKey];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)seeNeedDetail{
    
    NeedDetailViewController *detailVc = [[NeedDetailViewController alloc]init];
    detailVc.hidesBottomBarWhenPushed = YES;
    detailVc.needId = [[_notification objectForKey:kHLNotificationNeedKey]objectId];
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

-(void)startChattingWithBidder{
    
    NSString *roomId = StartPrivateChat([PFUser currentUser], [_notification objectForKey:kHLNotificationToUserKey]);
    ChatView *chatView = [[ChatView alloc] initWith:roomId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
    
}


- (void)cell:(FollowListCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userAccount"];
    vc.userID = aUser.objectId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    if(alertView.tag == 0){
//        
//        if(buttonIndex == 1){
//            
//            PFObject *offer = [_notification objectForKey:kHLNotificationOfferKey];
//            
//            [[ActivityManager sharedInstance]acceptingOfferWithOffer:offer price:_bidPrice toUser:_toUser block:^(BOOL succeeded, NSError *error) {
//                
//                if(succeeded){
//                    
//                    [[OffersManager sharedInstance]updateOfferSoldStatusWithOfferID:offer.objectId
//                                                                         soldStatus:YES
//                                                                              block:^(BOOL succeeded, NSError *error)
//                     {
//                         
//                         if(succeeded){
//                             
//                             NSString *userName = [[_notification objectForKey:kHLNotificationFromUserKey]objectForKey:kHLUserModelKeyUserName];
//                             
//                             NSString *message = [NSString stringWithFormat:@"You decide to sell the item to %@, %@ credits has been added to your account.",userName, _bidPrice];
//                             
//                             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Congratulations!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                             
//                             [alertView show];
//                             
//                             [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
//                         }
//                         
//                     }];
//                    
//                }
//                
//            }];
//            
//        }
//        
//    }
//    
//}




@end
