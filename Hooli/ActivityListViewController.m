//
//  ActivityListViewController.m
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListCell.h"
#import "ActivityDetailViewController.h"
#import "CreateActivityViewController.h"
#import "EventManager.h"
#import "HLConstant.h"
#import "LocationManager.h"
#import "ActivityCategoryViewController.h"
#import "HomeViewViewController.h"
#import "PAPLoadMoreCell.h"
@interface ActivityListViewController ()<HLCreateActivityDelegate,HLActivityCategoryDelegate>
@property (nonatomic) NSArray *eventCategories;
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic, strong) NSDate *lastRefresh;

@end

@implementation ActivityListViewController
@synthesize aObject,lastRefresh,blankView;
@synthesize eventCategories = _eventCategories;


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
        self.objectsPerPage = 20;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
    }
    return self;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if(_eventCategories && [_eventCategories count] > 0){
        
        [query whereKey:kHLEventKeyCategory containedIn:_eventCategories];
        
    }
    
    [query includeKey:kHLEventKeyHost];
    [query includeKey:kHLEventKeyImages];
    [query orderByDescending:@"updatedAt"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
//                                       initWithTitle:@"Post"
//                                       style:UIBarButtonItemStyleDone
//                                       target:self
//                                       action:@selector(postEvent)];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(postEvent)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
//    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
//                                      initWithTitle:@"Categories"
//                                      style:UIBarButtonItemStyleDone
//                                      target:self
//                                      action:@selector(seeCategories)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(seeCategories)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Events";
    
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

-(void)getdate {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:now];
    NSString *theDate = [dateFormat stringFromDate:now];
    NSString *theTime = [timeFormat stringFromDate:now];
    
    NSString *week = [dateFormatter stringFromDate:now];
    NSLog(@"\n"
          "theDate: |%@| \n"
          "theTime: |%@| \n"
          "Now: |%@| \n"
          "Week: |%@| \n"
          , theDate, theTime,dateString,week);
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self setNavBarVisible:YES animated:NO];
    [self setTabBarVisible:YES animated:NO];
    
}

-(void)postEvent{
    
    if([PFUser currentUser]){
        
        UIStoryboard *postSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
        
        CreateActivityViewController *postVC = [postSb instantiateViewControllerWithIdentifier:@"CreateActivityViewController"];
        
        postVC.delegate = self;
        
        postVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:postVC animated:YES];
        
    }
    else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Please sign up or login first", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        return;
    }
    
}


-(void)seeCategories{
    

    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    ActivityCategoryViewController *categoryVC = [detailSb instantiateViewControllerWithIdentifier:@"ActivityCategoryViewController"];
    categoryVC.isMultipleSelection = YES;
    categoryVC.selectedArray = _eventCategories;
    categoryVC.hidesBottomBarWhenPushed = YES;
    categoryVC.delegate = self;
    [self.navigationController pushViewController:categoryVC animated:YES];
    
}

-(void)didCreateActivity:(PFObject *)object{
    
    [self setNavBarVisible:YES animated:NO];
    [self setTabBarVisible:YES animated:NO];
    
    [self loadObjects];
    
}

-(void)didSelectEventCategories:(NSArray *)eventCategories{
    
    _eventCategories = eventCategories;
    
    [self loadObjects];
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
    
    static NSString *kCellIdentifier = @"ActivityListCell";
    
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell updateCellDetail:object];
    
    return cell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self setNavBarVisible:YES animated:NO];
    
    
    if([PFUser currentUser]){
        
        if (indexPath.row < self.objects.count) {
        
        ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc]init];
        detailVC.activityDetail = [self.objects objectAtIndex:indexPath.row];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
            
        }
        else if (self.paginationEnabled) {
            
            [self loadNextPage];
        }
        
    }
    else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Please sign up or login first", @"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alertView show];
        
        return;
        
    }
    //[self performSegueWithIdentifier:@"seeActivityDetail" sender:self];
    
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"seeActivityDetail"])
    {
        ActivityDetailViewController *detailVC = segue.destinationViewController;
        detailVC.hidesBottomBarWhenPushed = YES;
    }
    
    
}


#pragma mark scrollview delegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    CGPoint scrollVelocity = [self.tableView.panGestureRecognizer
                              velocityInView:self.tableView.superview];
    
    if ([self.objects count] < 4) {
        return;
    }
    
    if (scrollVelocity.y > 0.0f){
        
        [self setTabBarVisible:YES animated:YES];
        [self setNavBarVisible:YES animated:YES];
        
        
    }
    else if(scrollVelocity.y < 0.0f){
        
        [self setTabBarVisible:NO animated:YES];
        [self setNavBarVisible:NO animated:YES];
        
    }
    
}

- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}



- (void)setNavBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self navBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.navigationController.navigationBar.frame;
    CGFloat height = frame.size.height + 20;
    CGFloat offsetY = (visible)? height : -height;
    
    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        
        
        CGRect tableViewframe = self.tableView.frame;
        
        tableViewframe.origin.y = (visible)? 0 : 0;
        tableViewframe.size.height = (visible)? SCREEN_HEIGHT: [[UIScreen mainScreen]bounds].size.height - tableViewframe.origin.y;
        
        self.tableView.frame = tableViewframe;
        self.navigationController.navigationBar.frame = CGRectOffset(frame, 0, offsetY);
        
    }];
}

- (BOOL)navBarIsVisible {
    
    return self.navigationController.navigationBar.frame.origin.y >= 0;
    
}

@end
