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

@implementation NeedTableViewController
@synthesize firstLaunch,shouldReloadOnAppear;

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

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.title = @"Need";
        // self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];
        
        // The className to query on
        self.parseClassName = kHLCloudNeedClass;
        
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
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self checkIfUserLogin]){
        
        
        ActivityDetailViewController *adVC = [[ActivityDetailViewController alloc]initWithNibName:@"ActivityDetailViewController" bundle:nil];

//        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
//        NeedDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"NeedDetail"];
        adVC.hidesBottomBarWhenPushed = YES;
        //  vc.needId = cell.needId;
        // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:adVC animated:YES];
        
    }
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
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController pushViewController:loginVC animated:YES];
        return NO;
        
    }
    
    return YES;
}

@end
