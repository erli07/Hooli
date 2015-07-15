//
//  MyActivitiesViewController.m
//  Hooli
//
//  Created by Er Li on 3/24/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "MyActivitiesViewController.h"
#import "HLConstant.h"
#import "ActivityListCell.h"
#import "ActivityListViewController.h"
#import "ActivityDetailViewController.h"
@interface MyActivitiesViewController ()
@property (nonatomic, strong) UIView *blankView;

@end

@implementation MyActivitiesViewController
@synthesize aUser = _aUser;
@synthesize blankView = _blankView;
- (void)viewDidLoad {
    
    self.title = @"My Activities";
    [super viewDidLoad];
    
    self.blankView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [self.blankView setBackgroundColor:[UIColor whiteColor]];
    UILabel *noContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 44)];
    noContentLabel.text = @"No content at the moment";
    noContentLabel.textColor = [UIColor lightGrayColor];
    noContentLabel.font = [UIFont systemFontOfSize:17.0f];
    noContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.blankView addSubview:noContentLabel];
    // Do any additional setup after loading the view.
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudEventClass;
        
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


-(id)initWithUser:(PFUser *)_user{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudEventMemberClass;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of comments to show per page
        self.objectsPerPage = 10;
        
        self.aUser = _user;
        
        self.tableView.scrollEnabled = NO;
    }
    return self;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query1 = [PFQuery queryWithClassName:kHLCloudEventMemberClass];
    [query1 whereKey:kHLEventMemberKeyMember equalTo:_aUser];
    [query1 includeKey:kHLEventMemberKeyEvent];

    PFQuery *query = [PFQuery queryWithClassName:kHLCloudEventClass];
    [query whereKey:@"objectId" matchesKey:@"eventId" inQuery:query1];
    [query includeKey:kHLEventKeyHost];
    [query includeKey:kHLEventKeyImages];
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    
    [super objectsDidLoad:error];
    
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




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //return 125.0f;
    return 220.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *kCellIdentifier = @"MyActivityListCell";
    
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if(cell == nil){
        
        cell = [[ActivityListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        
    }
    
    [cell updateCellDetail:object];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc]init];
    detailVC.activityDetail = [self.objects objectAtIndex:indexPath.row];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}



@end
