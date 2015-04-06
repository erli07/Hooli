//
//  ViewController.m
//  Hooli
//
//  Created by Er Li on 12/18/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyCartViewController.h"
#import "ItemCell.h"
#import "MainCollectionViewFlowLayout.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "ItemDetailViewController.h"
#import "OffersManager.h"
#import "HLSettings.h"
#import "HLConstant.h"
#import "ActivityManager.h"
@interface MyCartViewController ()<UICollectionViewDelegate,UpdateCollectionViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UISegmentedControl *typeSegmentedControl;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) NSString *currentOfferId;
@property (nonatomic, assign) BOOL currentOfferSoldStatus;

@end
static NSString * const reuseIdentifier = @"Cell";

@implementation MyCartViewController
@synthesize  currentOfferId = _currentOfferId;
@synthesize segmentedControl = _segmentedControl;
@synthesize currentOfferSoldStatus = _currentOfferSoldStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Items";
    self.view.tintColor = [HLTheme mainColor];
    [self.layout configureLayout] ;
    [self.collectionView configureView];
    self.collectionView.delegate = self;
    self.collectionView.disableRefreshFlag = YES;
    [self registerNotifications];
    _segmentedControl.selectedSegmentIndex = 0;
    [self getGivingItems];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    if([[HLSettings sharedInstance]isRefreshNeeded]){
        
        if(self.segmentedControl.selectedSegmentIndex == 0){
            
            [self getGivingItems];
            
        }
        else if(self.segmentedControl.selectedSegmentIndex == 1){
            
            [self getLikedItems];
        }
        else if(self.segmentedControl.selectedSegmentIndex == 2){
            
            [self getBidItems];
        }
        
        [[HLSettings sharedInstance]setIsRefreshNeeded:NO];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[OffersManager sharedInstance]clearData];
    
    [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
    
}

#pragma register notification

-(void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCollectionViewData)
                                                 name:@"Hooli.reloadMyCartData" object:nil];
}

-(void)getGivingItems{
    
    self.collectionView.disableRefreshFlag = NO;
    
    [[OffersManager sharedInstance]setPageCounter:0];
    
    NSDictionary *filterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      kHLFilterDictionarySearchKeyUser, kHLFilterDictionarySearchType,
                                      [PFUser currentUser],kHLFilterDictionarySearchKeyUser,nil];
    
    [[OffersManager sharedInstance]setFilterDictionary:filterDictionary];
    
    [[HLSettings sharedInstance]setShowSoldItems:YES];
    
    [self.collectionView updateDataFromCloud];
    
}

-(void)getLikedItems{
    
    self.collectionView.disableRefreshFlag = YES;
    
    [[OffersManager sharedInstance]setPageCounter:0];
    
    //    NSDictionary *filterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                      kHLFilterDictionarySearchKeyUserLikes, kHLFilterDictionarySearchType,
    //                                      [PFUser currentUser],kHLFilterDictionarySearchKeyUser,nil];
    //
    //    [[OffersManager sharedInstance]setFilterDictionary:filterDictionary];
    //
    //    [self.collectionView updateDataFromCloud];
    
    [[ActivityManager sharedInstance]getLikedOffersByUser:[PFUser currentUser] WithSuccess:^(id downloadObjects) {
        
        [self.collectionView reloadDataByOffersArray:downloadObjects];
        
    } Failure:^(id error) {
        
        
    }];
    
    
}

-(void)getBidItems{
    
    // self.collectionView.disableRefreshFlag = NO;
    
    [[OffersManager sharedInstance]setPageCounter:0];
    
    [[ActivityManager sharedInstance]getBidOffersByUser:[PFUser currentUser] WithSuccess:^(id downloadObjects) {
        
        [self.collectionView reloadDataByOffersArray:downloadObjects];
        
    } Failure:^(id error) {
        
        
    }];
    
}

#pragma mark collectionview delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.segmentedControl.selectedSegmentIndex == 0){
        
        ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        _currentOfferId = cell.offerId;
        
        _currentOfferSoldStatus = cell.isOfferSold;
        
        NSString *other1;
        
        if (cell.isOfferSold) {
            
            other1  = @"Mark as unsold";
            
        }
        else{
            
            other1 = @"Mark as sold";
            
        }
        
        NSString *other2 = @"Delete";
        NSString *cancelTitle = @"Cancel";
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:other1, other2, nil];
        [actionSheet showInView:self.view];
        
    }
    else{
        
        ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
        vc.offerId = cell.offerId;
        // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma acrionsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
        [[OffersManager sharedInstance]updateOfferSoldStatusWithOfferID:_currentOfferId soldStatus:!_currentOfferSoldStatus block:^(BOOL succeeded, NSError *error) {
            
            //return all credits
            //          [[ActivityManager sharedInstance]returnCreditsWithOffer:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:_currentOfferId]];
            
            [self getGivingItems];
            
            [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
            
        }];
        
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to mark this item as sold?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        //
        //        [alertView show];
        
        
    }
    else if(buttonIndex == 1){
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alertView.tag = 1;
        [alertView show];
        
        
    }
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 0){
        
        if(buttonIndex== 1){
            
            [[OffersManager sharedInstance]updateOfferSoldStatusWithOfferID:_currentOfferId soldStatus:!_currentOfferSoldStatus block:^(BOOL succeeded, NSError *error) {
                
                [self getGivingItems];
                
                [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
                
            }];
            
        }
    }
    else{
        
        if(buttonIndex== 1){
            
            [[OffersManager sharedInstance]deleteOfferModelWithOfferId:_currentOfferId block:^(BOOL succeeded, NSError *error) {
                
                [self getGivingItems];
                
                [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kHLLoadFeedObjectsNotification object:self];
                
            }];
        }
    }
    
    
}

#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height )
    {
        [self.collectionView updateDataFromCloud];
    }
    
}


- (IBAction)segmentControlChanged:(id)sender{
    
    if(self.segmentedControl.selectedSegmentIndex == 0){
        
        [self getGivingItems];
        
    }
    else if(self.segmentedControl.selectedSegmentIndex == 1){
        
        [self getLikedItems];
    }
    else if(self.segmentedControl.selectedSegmentIndex == 2){
        
        [self getBidItems];
    }
    
}

@end
