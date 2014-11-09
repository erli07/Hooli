//
//  SearchResultViewController.m
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "SearchResultViewController.h"
#import "ItemDetailViewController.h"
#import "ItemCell.h"
#import "HLTheme.h"
#import "OffersManager.h"
@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [HLTheme mainColor];
    [self.layout configureLayout] ;
    [self.collectionView configureView];
    self.collectionView.delegate = self;
    self.navigationItem.title = @"Result";
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self updateCollectionViewData];
    
}

-(void)updateCollectionViewData{
    
    [[OffersManager sharedInstance]clearData];
    
    [self.collectionView updateDataFromCloud];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
    vc.offerId = cell.offerId;
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
