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
@interface NotificationFeedViewController ()
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, strong) UIView *blankTimelineView;
@end

@implementation NotificationFeedViewController
@synthesize lastRefresh,blankTimelineView;
@synthesize notification = _notification;

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
        self.objectsPerPage = 50;
        
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
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.title = @"Notification";
    
    // Add Settings button
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadObjects) name:kHLLoadFeedObjectsNotification object:nil];
    
    self.blankTimelineView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [self.blankTimelineView setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"Ariel1"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(24.0f, 113.0f, 271.0f, 271.0f)];
    // [button addTarget:self action:@selector(inviteFriendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.blankTimelineView addSubview:button];
    
    
    lastRefresh = [[NSUserDefaults standardUserDefaults] objectForKey:kHlUserDefaultsActivityFeedViewControllerLastRefreshKey];
    
    // Do any additional setup after loading the view.
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
        
        if (!self.blankTimelineView.superview) {
            self.blankTimelineView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankTimelineView;
            
            [UIView animateWithDuration:0.200f animations:^{
                self.blankTimelineView.alpha = 1.0f;
            }];
        }
    } else {
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
        
//        NSUInteger unreadCount = 0;
//        for (PFObject *activity in self.objects) {
//            if ([lastRefresh compare:[activity createdAt]] == NSOrderedAscending && ![[activity objectForKey:kHLNotificationTypeKey] isEqualToString:kHLNotificationTypeJoined]) {
//                unreadCount++;
//            }
//        }
//        
//        if (unreadCount > 0) {
//            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)unreadCount];
//        } else {
//            self.navigationController.tabBarItem.badgeValue = nil;
//        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"NotificationFeedCell";
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
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
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"This item has been sold. Change the status in your items list." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alertView show];
                    
                }
                else{
                    
                    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                            @"Accept Bid",
                                            @"Contact",
                                            @"See offer detail",
                                            nil];
                    popup.tag = 1;
                    [popup showInView:[UIApplication sharedApplication].keyWindow];
                }
            }];
        }
        else if ([[_notification objectForKey:kHLNotificationTypeKey]isEqualToString:kHLNotificationTypeComment]) {
            
            [self seeOfferDetail];
        }
        
    } else if (self.paginationEnabled) {
        
        [self loadNextPage];
    }
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
        return NSLocalizedString(@"liked your photo", nil);
    } else if ([notificationType isEqualToString:kHLNotificationTypeFollow]) {
        return NSLocalizedString(@"started following you", nil);
    } else if ([notificationType isEqualToString:kHLNotificationTypeComment]) {
        return NSLocalizedString(@"commented on your item", nil);
    } else if ([notificationType isEqualToString:kHLNotificationTypeJoined]) {
        return NSLocalizedString(@"joined Hooli", nil);
    } else if ([notificationType isEqualToString:khlNotificationTypMakeOffer]){
        return NSLocalizedString(@"bid on your item for", nil);
    }
    else  {
        return nil;
    }
    
}

-(void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to accept this bid?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                    
                    alertView.tag = 0;
                    
                    [alertView show];
                }
                    
                    break;
                    
                case 1:
                    
                    [self startChattingWithBidder];
                    break;
                    
                case 2:
                    
                    [self seeOfferDetail];
                    break;
                    
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(void)seeUserDetail{
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userCart"];
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

-(void)startChattingWithBidder{
    
    NSString *roomId = StartPrivateChat([PFUser currentUser], [_notification objectForKey:kHLNotificationToUserKey]);
    ChatView *chatView = [[ChatView alloc] initWith:roomId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 0){
        
        if(buttonIndex == 1){
            
            PFObject *offer = [_notification objectForKey:kHLNotificationOfferKey];
            
            [[OffersManager sharedInstance]updateOfferSoldStatusWithOfferID:offer.objectId
                                                                 soldStatus:YES
                                                                      block:^(BOOL succeeded, NSError *error)
             {
                 
                 if(succeeded){
                     
                     NSString *userName = [[_notification objectForKey:kHLNotificationFromUserKey]objectForKey:kHLUserModelKeyUserName];
                     
                     NSString *message = [NSString stringWithFormat:@"You decide to sell the item to %@, other can't see the item unless you change the status in your items list.", userName];
                     
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     
                     [alertView show];
                     
                     [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
                 }
                 
             }];
            
            
        }
        
    }
    
}




@end
