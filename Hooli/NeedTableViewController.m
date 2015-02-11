//
//  NeedTableViewController.m
//  Hooli
//
//  Created by Er Li on 12/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedTableViewController.h"
#import "HLConstant.h"
#import "NeedTableViewCell.h"
#import "NeedDetailViewController.h"
#import "HLTheme.h"
#import "LoginViewController.h"
#import "ActivityDetailViewController.h"
@interface NeedTableViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;

@end

static const CGFloat kHLCellInsetWidth = 0.0f;

@implementation NeedTableViewController
@synthesize firstLaunch,shouldReloadOnAppear,user;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewELements];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(![PFUser currentUser]){
    
    [self.navigationController popToRootViewControllerAnimated:NO];
        
    }
    
}

-(void)initViewELements{

    self.view.tintColor = [HLTheme mainColor];
    
    [self loadObjects];
    
}


#pragma mark - PFQueryTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        
        // The className to query on
        self.parseClassName = kHLCloudItemNeedClass;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        // Improve scrolling performance by reusing UITableView section headers
        
        self.shouldReloadOnAppear = NO;

        
    }
    return self;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if(self.user){
        
        [query whereKey:kHLNeedsModelKeyUser equalTo:user];
    }
    
    [query includeKey:kHLNeedsModelKeyUser];
    [query orderByDescending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult] & !self.firstLaunch) {
        self.tableView.scrollEnabled = NO;
        
        //        if (!self.blankTimelineView.superview) {
        //            self.blankTimelineView.alpha = 0.0f;
        //            self.tableView.tableHeaderView = self.blankTimelineView;
        //
        //            [UIView animateWithDuration:0.200f animations:^{
        //                self.blankTimelineView.alpha = 1.0f;
        //            }];
        //        }
    } else {
        
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *CellIdentifier = @"NeedCell";
    
    NeedTableViewCell *cell = (NeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[NeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.nameButton = nil;
    cell.needId = object.objectId;
    [cell setUser:[object objectForKey:kHLNeedsModelKeyUser]];
    [cell setNeedContentText:[object objectForKey:kHLNeedsModelKeyName]];
    [cell setDate:[object createdAt]];
    //[cell setDistanceLabelText:@"distance: 1.1 mi"];
    
    return cell;
    
}


#pragma mark tableview delegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self checkIfUserLogin]){
        
        NeedDetailViewController *detailVc = [[NeedDetailViewController alloc]init];
        NeedTableViewCell *cell = (NeedTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        detailVc.needId = cell.needId;
        [self.navigationController pushViewController:detailVc animated:YES];
        
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row < self.objects.count) { // A comment row
        
        NSString *commentString = [self.objects[indexPath.row] objectForKey:kHLNeedsModelKeyDescription];
        
        return [NeedTableViewCell heightForCellWithName:[[PFUser currentUser]objectForKey:kHLNeedsModelKeyUser] contentString:commentString cellInsetWidth:0];
        
    }
    
    // The pagination row
    return 44.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height)
    {
        [self loadNextPage];
    }
    
}

- (BOOL)checkIfUserLogin{
    
    
    if(![PFUser currentUser]){
        
        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *loginVC = [loginSb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        loginVC.navigationController.navigationBarHidden = NO;
        loginVC.navigationItem.hidesBackButton = YES;
        [self.navigationController pushViewController:loginVC animated:NO];
        return NO;
        
    }
    
    return YES;
}


@end
