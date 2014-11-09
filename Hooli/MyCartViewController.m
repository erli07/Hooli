//
//  MyCartViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyCartViewController.h"
#import "ItemCell.h"
#import "MainCollectionViewFlowLayout.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "ItemDetailViewController.h"
#import "OffersManager.h"
@interface MyCartViewController ()<UICollectionViewDelegate,UpdateCollectionViewDelegate>
@property (nonatomic, strong) UISegmentedControl *typeSegmentedControl;
@property (nonatomic, strong) UIViewController *currentViewController;
@end
static NSString * const reuseIdentifier = @"Cell";

@implementation MyCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Items";
    self.view.tintColor = [HLTheme mainColor];
    [self.layout configureLayout] ;
    [self.collectionView configureView];
    self.collectionView.delegate = self;
 //   [self.collectionView updateDataFromCloud];
    [self registerNotifications];
}

-(void)viewDidAppear:(BOOL)animated{

    [self updateCollectionViewData];
    
}

#pragma register notification

-(void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCollectionViewData)
                                                 name:@"Hooli.reloadMyCartData" object:nil];
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


#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height )
    {
        [self.collectionView updateDataFromCloud];
    }
}

@end

