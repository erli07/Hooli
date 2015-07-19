//
//  BidHistoryViewController.m
//  Hooli
//
//  Created by Er Li on 2/24/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "BidHistoryViewController.h"
#import "HLConstant.h"
#import "MBProgressHUD.h"
#import "CreditHistoryCell.h"
#import "BidHisoryCell.h"
#import "UserAccountViewController.h"
#import "UserCartViewController.h"
@interface BidHistoryViewController ()
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) PFUser *toUser;
@end

@implementation BidHistoryViewController
@synthesize lastRefresh = _lastRefresh;
@synthesize blankView = _blankView;
@synthesize toUser = _toUser;
@synthesize offerId = _offerId;



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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bid History";
    self.blankView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [self.blankView setBackgroundColor:[UIColor whiteColor]];
    UILabel *noContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 44)];
    noContentLabel.text = @"No content at the moment";
    noContentLabel.textColor = [UIColor lightGrayColor];
    noContentLabel.font = [UIFont systemFontOfSize:17.0f];
    noContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.blankView addSubview:noContentLabel];
    
    // Do any additional setup after loading the view.
}

- (PFQuery *)queryForTable {
    
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kHLNotificationTypeKey equalTo:khlNotificationTypMakeOffer];
  //  [query whereKey:kHLNotificationFromUserKey notEqualTo:[PFUser currentUser]];
    [query whereKey:kHLNotificationOfferKey equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:_offerId]];
    
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
    
    _lastRefresh = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:_lastRefresh forKey:kHlUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
    
    static NSString *CellIdentifier = @"BidHisoryCell";
    
    BidHisoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[BidHisoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setDelegate:self];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    PFUser *fromUser = [object objectForKey:kHLNotificationFromUserKey];
    
    [cell setUser:fromUser];
    
    [cell setNotification:object];
    
    cell.activityImageView.hidden = YES;
    
    cell.activityImageView = nil;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userAccount"];
    PFObject *bidObject = [self.objects objectAtIndex:indexPath.row];
    PFUser *fromUser = [bidObject objectForKey:kHLNotificationFromUserKey];
    vc.userID = fromUser.objectId;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
