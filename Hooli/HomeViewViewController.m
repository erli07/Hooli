//
//  MapViewViewController.m
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HomeViewViewController.h"
#import "HLTheme.h"
#import "DataSource.h"
#import "ItemDetailViewController.h"
#import "OffersManager.h"
#import "HLSettings.h"
#import "SearchItemViewController.h"
#import "LoginWelcomeViewController.h"
#import "MyCameraViewController.h"
#import "ActivityManager.h"
#import "HLConstant.h"
#import "DCPathButton.h"
#import "PostNeedViewController.h"
#import "NeedDetailViewController.h"
#import "HLUtilities.h"
#import "NeedTableViewCell.h"
@interface HomeViewViewController ()<UpdateCollectionViewDelegate,DCPathButtonDelegate>{
    
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) UIButton *addItemButton;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic) UISearchController *searchController;
@property (nonatomic) SearchItemViewController *searchItemVC;
@property (nonatomic, assign) BOOL showCategoryVC;
//@property (nonatomic,strong) DCPathButton *addItemButton;

@property (nonatomic, strong) NSString *itemID;
@end

//static const CGFloat kHLCellInsetWidth = 0.0f;

static NSString * const reuseIdentifier = @"Cell";

@implementation HomeViewViewController
@synthesize refreshControl,addItemButton,needsViewController,searchBar,searchController,searchItemVC,showCategoryVC;

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCamera:)
                                                 name:kHLShowCameraViewNotification object:nil];
    
    [[HLSettings sharedInstance]setShowSoldItems:NO];
    
    [self initViewELements];
    
    [self updateCollectionViewData];
    
    [self getFollowedUserItems];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[HLSettings sharedInstance]setShowSoldItems:NO];
    [[HLSettings sharedInstance]setCurrentPageIndex:0];
    [[OffersManager sharedInstance]setFilterDictionary:nil];
    
    
    if(self.searchController.active){
        
        self.tabBarController.tabBar.hidden = YES;
    }
    else{
        
        self.tabBarController.tabBar.hidden = NO;
        
    }
    
    //  [self resetNavBar];
    
    
    //    if(![PFUser currentUser]){
    //
    //        [self initViewELements];
    //
    //    }
    
}

-(void)updateCollectionViewData{
    
    
    [self.collectionView updateDataFromCloud];
    
}

-(void)getFollowedUserItems{
    
    if([PFUser currentUser]){
        
        [[ActivityManager sharedInstance]getFollowedUsersByUser:[PFUser currentUser] block:^(NSArray *array, NSError *error) {
            
            if(array){
                
                [OffersManager sharedInstance].followedUserArray = array;
                
            }
            
            
        }];
        
    }
    
}

-(void)initViewELements{
    
    [[OffersManager sharedInstance]setPageCounter:0];
    
    [[HLSettings sharedInstance]setPreferredDistance:25];
    
    //
    self.collectionView.hidden = NO;
    
    
    //    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]
    //                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAction
    //                                       target:self
    //                                       action:@selector(showMoreItems)];
    //    self.navigationItem.leftBarButtonItem = settingsButton;
    
    self.view.tintColor = [HLTheme mainColor];
    
    [self.layout configureLayout] ;
    
    [self initNeedsViewController];
    
    [self.collectionView configureView];
    
    self.collectionView.delegate = self;
    
    [self registerNotifications];
    
    // self.navigationItem.title = @"Discover";
    
    [self addSwipeGesture];
    
    [self configureAddButton];
    
    [self configureSearchBar];
    
    //    self.searchCategoryVC = [[SearchItemViewController alloc]init];
    //
    //    [self.searchCategoryVC.view setFrame:CGRectMake(60, 100, 200, 200)];
    //
    //    [self.view addSubview:self.searchCategoryVC.view];
    
}

-(void)configureSearchBar{
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.showCategoryVC = NO;
    self.searchController.searchBar.tintColor = [HLTheme mainColor];
    //  self.searchController.searchResultsUpdater = self;
    self.searchController.active = NO;
    self.searchController.searchBar.placeholder =  @"Search Items...";
    self.searchController.searchBar.showsSearchResultsButton = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.navigationItem.titleView = self.searchController.searchBar;
    
}
#pragma mark - UISearchBarDelegate

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {

    if(!self.showCategoryVC){
        
        [self.view addSubview:[self getSearchCategoryView]];

    }
    else{
    
        [self removeCategoryView];

    }
    
}

#pragma mark - UISearchControllerDelegate

- (void)presentSearchController:(UISearchController *)searchController {
    
    [self.view addSubview:[self getSearchCategoryView]];
    
}

-(UIView *)getSearchCategoryView{
    
    if(!self.searchItemVC){
        
        self.searchItemVC = [[SearchItemViewController alloc]init];
        
        self.searchItemVC.view.tag = 99;
        
        [self.searchItemVC.view setFrame:CGRectMake(0, 64, 320, 568)];
        
        self.searchItemVC.delegate = self;
        
        
    }
    
    self.showCategoryVC = YES;

    self.tabBarController.tabBar.hidden = YES;
    
    return self.searchItemVC.view;

}

-(void)removeCategoryView{
    
    for (UIView *subView in self.view.subviews)
    {
        if (subView.tag == 99)
        {
            [subView removeFromSuperview];
        }
    }
    self.showCategoryVC = NO;

    self.tabBarController.tabBar.hidden = NO;
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    
    [self removeCategoryView];
    
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}


#pragma mark - init
-(void)initNeedsViewController{
    
    self.needsViewController = [[NeedTableViewController alloc]init];
    //
    [self.needsViewController.view setFrame:self.collectionView.frame];
    
    [self.needsViewController.view setBackgroundColor:[HLTheme viewBackgroundColor]];
    
    [self.view addSubview:self.needsViewController.view];
    
    self.needsViewController.tableView.delegate = self;
    //
    self.needsViewController.view.hidden = YES;
}

-(void)configureAddButton{
    
    
    self.addItemButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2, 64, 64)];
    self.addItemButton.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 + 168);
    [self.addItemButton setBackgroundImage:[UIImage imageNamed:@"camera_128x128"] forState:UIControlStateNormal];
    [self.addItemButton addTarget:self action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addItemButton];
    [self.addItemButton bringSubviewToFront:self.collectionView];
    //    self.addItemButton  = [[DCPathButton alloc]initWithCenterImage:[UIImage imageNamed:@"camera_64x64"]
    //                                                    hilightedImage:[UIImage imageNamed:@"camera_64x64"]];
    //
    //    [self.addItemButton setDcButtonCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 + 168) ];
    //    DCPathItemButton *itemButton_1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"camera_64x64"]
    //                                                           highlightedImage:[UIImage imageNamed:@"camera_64x64"]
    //                                                            backgroundImage:[UIImage imageNamed:@"camera_64x64"]
    //                                                 backgroundHighlightedImage:[UIImage imageNamed:@"camera_64x64"]];
    //
    //    DCPathItemButton *itemButton_2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"camera_64x64"]
    //                                                           highlightedImage:[UIImage imageNamed:@"camera_64x64"]
    //                                                            backgroundImage:[UIImage imageNamed:@"camera_64x64"]
    //                                                 backgroundHighlightedImage:[UIImage imageNamed:@"camera_64x64"]];
    //
    //    [self.addItemButton addPathItems:@[itemButton_1, itemButton_2]];
    //
    //    self.addItemButton.delegate = self;
    //     [self.addItemButton addTarget:self action:@selector(showCamera:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addItemButton];
    [self.addItemButton bringSubviewToFront:self.collectionView];
}

#pragma register notification


-(void)addSwipeGesture{
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.collectionView addGestureRecognizer:swipeLeft];
    [self.needsViewController.view addGestureRecognizer:swipeRight];
    
    
    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}

-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
}
-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Swipe Left");
    
    [self.segmentControl setSelectedSegmentIndex:0];
    //Do what you want here
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Swipe Right");
    
    [self.segmentControl setSelectedSegmentIndex:1];
    
    //Do what you want here
}

#pragma register notification

-(void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCollectionViewData)
                                                 name:@"Hooli.reloadHomeData" object:nil];
}




#pragma mark collectionview delegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([HLUtilities checkIfUserLoginWithCurrentVC:self]){
        
        ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
        vc.offerId = cell.offerId;
        // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
 For need view
 #pragma mark tableview delegate
 
 
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
 if([self checkIfUserLogin]){
 
 NeedDetailViewController *detailVc = [[NeedDetailViewController alloc]init];
 detailVc.hidesBottomBarWhenPushed = YES;
 NeedTableViewCell *cell = (NeedTableViewCell *)[self.needsViewController.tableView cellForRowAtIndexPath:indexPath];
 detailVc.needId = cell.needId;
 [self.navigationController pushViewController:detailVc animated:YES];
 
 
 }
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 
 if (indexPath.row < self.needsViewController.objects.count) { // A comment row
 
 NSString *commentString = [self.needsViewController.objects[indexPath.row] objectForKey:kHLNeedsModelKeyDescription];
 
 return [NeedTableViewCell heightForCellWithName:[[PFUser currentUser]objectForKey:kHLNeedsModelKeyUser] contentString:commentString cellInsetWidth:kHLCellInsetWidth];
 
 }
 
 // The pagination row
 return 44.0f;
 }
 
 */


-(void)showMoreItems{
    
    [self performSegueWithIdentifier:@"showMore" sender:self];
    
}

-(void)showSearchVC{
    
    [self performSegueWithIdentifier:@"Search" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"detail"])
    {
        ItemDetailViewController *detailVC = segue.destinationViewController;
        detailVC.hidesBottomBarWhenPushed = YES;
    }
    else if([segue.identifier isEqualToString:@"Search"])
    {
        SearchItemViewController *searchVC = segue.destinationViewController;
        searchVC.hidesBottomBarWhenPushed = YES;
    }
    
}

#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height )
    {
        [self.collectionView updateDataFromCloud];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    CGPoint scrollVelocity = [self.collectionView.panGestureRecognizer
                              velocityInView:self.collectionView.superview];
    
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
    CGFloat duration = (animated)? 0.6 : 0.0;
    
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
    CGFloat duration = (animated)? 0.6 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        
        CGRect segmentControlFrame = self.segmentControl.frame;
        segmentControlFrame.origin.y = (visible)? 71 : 20;
        self.segmentControl.frame = segmentControlFrame;
        CGRect collectionView = self.collectionView.frame;
        
        collectionView.origin.y = (visible)? 107 : 55;
        collectionView.size.height = (visible)? 431 : [[UIScreen mainScreen]bounds].size.height - collectionView.origin.y;
        self.addItemButton.alpha =(visible)?1:0;
        
        self.addItemButton.center = (visible)?CGPointMake(160, 452):CGPointMake(160,568);
        self.collectionView.frame = collectionView;
        self.navigationController.navigationBar.frame = CGRectOffset(frame, 0, offsetY);
        
    }];
}

-(void)resetNavBar{
    
    CGRect frame = self.navigationController.navigationBar.frame;
    
    CGRect segmentControlFrame = self.segmentControl.frame;
    segmentControlFrame.origin.y = 71;
    self.segmentControl.frame = segmentControlFrame;
    CGRect collectionView = self.collectionView.frame;
    
    collectionView.origin.y = 107;
    self.collectionView.frame = collectionView;
    self.navigationController.navigationBar.frame = CGRectOffset(frame, 0, 0);
    
}

// know the current state
- (BOOL)navBarIsVisible {
    
    return self.navigationController.navigationBar.frame.origin.y >= 0;
    
}

//- (BOOL)checkIfUserLogin{
//    
//    
//    if(![PFUser currentUser]){
//        
//        UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        LoginWelcomeViewController *loginVC = [loginSb instantiateViewControllerWithIdentifier:@"LoginWelcomeViewController"];
//        self.navigationController.navigationBarHidden = NO;
//        loginVC.title = self.title;
//        [self.navigationController pushViewController:loginVC animated:YES];
//        return NO;
//        
//    }
//    
//    return YES;
//}


-(void)showCamera:(id)sender{
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    MyCameraViewController *cameraVC = [mainSb instantiateViewControllerWithIdentifier:@"MyCameraViewController"];
    
    
    [cameraVC initCameraPickerWithCompletionBlock:^(BOOL succeeded) {
        
        //  [self presentViewController:cameraVC animated:YES completion:^{
        //  }];
        
        [self.navigationController pushViewController:cameraVC animated:NO];
        
        
    }];
    
}



- (IBAction)segmentChange:(id)sender {
    
    if(self.segmentControl.selectedSegmentIndex == 0){
        
        self.collectionView.hidden = NO;
        
        self.needsViewController.view.hidden = YES;
        
        [self getOffersFormAll];
        
    }
    else if(self.segmentControl.selectedSegmentIndex == 1){
        
        self.collectionView.hidden = NO;
        
        self.needsViewController.view.hidden = YES;
        
        [self getOffersFromFollowedUsers];
        
    }
    
}

-(void)getOffersFromFollowedUsers{
    
    
    if([PFUser currentUser]){
        
        self.collectionView.refreshControl.enabled = NO;
        
     //   [[OffersManager sharedInstance]clearData];
        
        [OffersManager sharedInstance].filterDictionary = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:kHLFilterDictionarySearchKeyFollowedUsers , nil] forKeys:[NSArray arrayWithObjects:kHLFilterDictionarySearchType ,nil]];
        
        [self.collectionView updateDataFromCloud];

        
//        if([[[OffersManager sharedInstance]followedUserArray] count] > 0 && [[[OffersManager sharedInstance]filterDictionary]objectForKey:kHLFilterDictionarySearchType]){
//            
//            
//        }
//        else{
//            
//            self.collectionView.hidden = YES;
//            
//        }
        
    }
}

-(void)getOffersFormAll{
    
    [[OffersManager sharedInstance]clearData];
    
    [[OffersManager sharedInstance]setFilterDictionary:nil];
    
    [self updateCollectionViewData];

    
}


-(void)showSearchResultVCWithCategory:(NSString *)category{
    
    NSDictionary *filterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kHLFilterDictionarySearchKeyCategory, kHLFilterDictionarySearchType,
                                      category,kHLFilterDictionarySearchKeyCategory,nil];
    
    [[OffersManager sharedInstance]setFilterDictionary:filterDictionary];
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchResultViewController *resultVC = [mainSb instantiateViewControllerWithIdentifier:@"searchResult"];
    resultVC.title = category;
    resultVC.hidesBottomBarWhenPushed = YES;
    [self.searchController.searchBar resignFirstResponder];
    [self.navigationController pushViewController:resultVC animated:YES];
    
}
@end
