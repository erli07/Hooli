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
#import "LoginViewController.h"
#import "MyCameraViewController.h"
#import "ActivityManager.h"
#import "HLConstant.h"
#import "DCPathButton.h"
#import "PostNeedViewController.h"
#import "NeedDetailViewController.h"
#import "NeedTableViewCell.h"
@interface HomeViewViewController ()<UpdateCollectionViewDelegate,DCPathButtonDelegate>{
    
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic,strong) UIButton *addItemButton;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic) UISearchDisplayController *searchDisplayController;
@property (nonatomic) SearchItemViewController *searchCategoryVC;
//@property (nonatomic,strong) DCPathButton *addItemButton;

@property (nonatomic, strong) NSString *itemID;
@end

static const CGFloat kHLCellInsetWidth = 0.0f;

static NSString * const reuseIdentifier = @"Cell";

@implementation HomeViewViewController
@synthesize refreshControl,addItemButton,needsViewController,searchBar,searchDisplayController,searchCategoryVC;

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
    
    
    [[HLSettings sharedInstance]setCurrentPageIndex:0];
    
  //  [self resetNavBar];
    
    
    //    if(![PFUser currentUser]){
    //
    //        [self initViewELements];
    //
    //    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
//    if([[HLSettings sharedInstance]isRefreshNeeded]){
//        
//        
//        
//        [self updateCollectionViewData];
//        [[HLSettings sharedInstance]setIsRefreshNeeded:NO];
//        [self getFollowedUserItems];
//        
//    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[OffersManager sharedInstance]clearData];
    
}


-(void)updateCollectionViewData{
    
    [[OffersManager sharedInstance]clearData];
    
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
    

    
}

-(void)configureSearchBar{
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
//    self.navigationItem.titleView.frame = CGRectMake(100, 0, 100, 44);
    self.searchBar.placeholder = @"Search Items...";
    self.searchCategoryVC = [[SearchItemViewController alloc]init];
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self.searchCategoryVC ];
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self.searchCategoryVC ;
    self.searchDisplayController.searchResultsDelegate = self.searchCategoryVC ;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchDisplayController setActive:YES animated:YES];
}

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
    
    if([self checkIfUserLogin]){
        
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
        
      //  [self updateCollectionViewData];
        
    }
    else if(self.segmentControl.selectedSegmentIndex == 1){
        
        self.collectionView.hidden = NO;
        
        self.needsViewController.view.hidden = YES;
        
        
        if([PFUser currentUser]){
            
            [[OffersManager sharedInstance]clearData];
            
            [OffersManager sharedInstance].filterDictionary = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:kHLFilterDictionarySearchKeyFollowedUsers , nil] forKeys:[NSArray arrayWithObjects:kHLFilterDictionarySearchType ,nil]];
            
            if([[[OffersManager sharedInstance]followedUserArray] count] > 0 && [[[OffersManager sharedInstance]filterDictionary]objectForKey:kHLFilterDictionarySearchType]){
                
                [self.collectionView updateDataFromCloud];
                
            }
            else{
                
                self.collectionView.hidden = YES;
                
            }
            
        }
    }
    
    
}

-(void)getOffersFromFollowedUsers{
    
    
    if([PFUser currentUser]){
        
        [[OffersManager sharedInstance]clearData];
        
        [OffersManager sharedInstance].filterDictionary = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:kHLFilterDictionarySearchKeyFollowedUsers , nil] forKeys:[NSArray arrayWithObjects:kHLFilterDictionarySearchType ,nil]];
        
        if([[[OffersManager sharedInstance]followedUserArray] count] > 0 && [[[OffersManager sharedInstance]filterDictionary]objectForKey:kHLFilterDictionarySearchType]){
            
            [self.collectionView updateDataFromCloud];
            
        }
        else{
            
            self.collectionView.hidden = YES;
            
        }
        
    }
}
/*
#pragma mark DCPathButtonDelegate

- (void)itemButtonTappedAtIndex:(NSUInteger)index
{
    if(index == 0){
        
        NSLog(@"Tap on button 1");
        
        [self showCamera:nil];
        // When the user tap index 1 here ...
    }
    else{
        
//        NSLog(@"Tap on button 2");
//        
//        PostNeedViewController *postVC = [[PostNeedViewController alloc]initWithStyle:UITableViewStyleGrouped];
//        
//        postVC.hidesBottomBarWhenPushed = YES;
//        
//        [self.navigationController pushViewController:postVC animated:YES];

    }
}
 
 */
@end
