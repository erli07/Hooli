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
#import "ShoppingItemCell.h"
#import "ItemDetailViewController.h"
@interface HomeViewViewController (){
    
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSString *itemID;
@end

static NSString * const reuseIdentifier = @"Cell";

@implementation HomeViewViewController
@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView addSubview:self.refreshControl];
    
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
    self.navigationItem.title = @"Discover";
//    self.collectionView.scrollEnabled = YES;
//    
//    self.layout.sectionInset = UIEdgeInsetsMake(0,5,5,5);
//    self.layout.itemSize = CGSizeMake(151, 202);
//    self.layout.minimumInteritemSpacing = 3;
//    self.layout.minimumLineSpacing = 10;
//
//    // Do any additional setup after loading the view.
//    
//    self.collections = [DataSource collections];
//    
//    self.view.tintColor = [HLTheme mainColor];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadInputViews];
}


#pragma mark collectionview delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.collections count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingItemCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary* data = self.collections[indexPath.row];

    [cell updateCellWithData:data];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UIViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
  //rs [self performSegueWithIdentifier:@"detail" sender:self];
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

#pragma mark

-(void)reloadAllViews{
    
    
    if (self.refreshControl) {
        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateFormat:@"MMM d, h:mm a"];
//        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
//        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
//                                                                    forKey:NSForegroundColorAttributeName];
//        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
//        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

@end
