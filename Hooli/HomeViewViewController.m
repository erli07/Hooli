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
@interface HomeViewViewController ()<UpdateCollectionViewDelegate>{
    
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSString *itemID;
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation HomeViewViewController
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[OffersManager sharedInstance]setPageCounter:0];
    [[HLSettings sharedInstance]setPreferredDistance:25];
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Filter"
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(showMoreItems)];
    self.navigationItem.rightBarButtonItem = moreButton;
    
    self.view.tintColor = [HLTheme mainColor];
    [self.layout configureLayout] ;
    [self.collectionView configureView];
    self.collectionView.delegate = self;
    [self registerNotifications];
    self.navigationItem.title = @"Discover";
    [self updateCollectionViewData];
    [self addSwipeGesture];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    if([[HLSettings sharedInstance]isRefreshNeeded]){
        
        [self updateCollectionViewData];
        [[HLSettings sharedInstance]setIsRefreshNeeded:NO];
        
    }
    
}
#pragma register notification


-(void)addSwipeGesture{
    
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


#pragma register notification

-(void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCollectionViewData)
                                                 name:@"Hooli.reloadHomeData" object:nil];
}

-(void)updateCollectionViewData{
    
    [[OffersManager sharedInstance]setFilterDictionary:nil];
    
    [[OffersManager sharedInstance]clearData];
    
    [self.collectionView updateDataFromCloud];
    
}


#pragma mark collectionview delegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
    vc.offerId = cell.offerId;
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma Navigation

-(void)showMoreItems{
    
    [self performSegueWithIdentifier:@"showMore" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"detail"])
    {
        ItemDetailViewController *detailVC = segue.destinationViewController;
        
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
        self.collectionView.frame = collectionView;
        self.navigationController.navigationBar.frame = CGRectOffset(frame, 0, offsetY);
        
    }];
}

// know the current state
- (BOOL)navBarIsVisible {
    
    return self.navigationController.navigationBar.frame.origin.y >= 0;
    
}



@end