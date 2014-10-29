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
@interface MyCartViewController ()<UICollectionViewDelegate>
@property (nonatomic, strong) UISegmentedControl *typeSegmentedControl;
@property (nonatomic, strong) UIViewController *currentViewController;
@end
static NSString * const reuseIdentifier = @"Cell";

@implementation MyCartViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Items";
    self.view.tintColor = [HLTheme mainColor];

    [self.collectionView configureView];
    [self.layout configureLayout] ;
    self.collectionView.delegate = self;


}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"detailViewController"];
   // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

