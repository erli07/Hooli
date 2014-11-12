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

}


-(void)viewDidAppear:(BOOL)animated{

    if([[HLSettings sharedInstance]isRefreshNeeded]){
        
        [self updateCollectionViewData];
        [[HLSettings sharedInstance]setIsRefreshNeeded:NO];

    }
    
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


@end
