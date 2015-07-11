//
//  MainCollectionView.m
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MainCollectionView.h"
#import "ItemCell.h"
#import "DataSource.h"
#import <malloc/malloc.h>
#import "HLTheme.h"
#import "OffersManager.h"
#import <Parse/Parse.h>
#import "HLConstant.h"
#import "LocationManager.h"
#import "ItemDetailViewController.h"
static NSString * const reuseIdentifier = @"ItemCell";

@implementation MainCollectionView{
    
    MBProgressHUD *HUD;
}

@synthesize refreshControl, objectDataSource,isLoading,filterDictionaryType,disableRefreshFlag,noContentLabel;
-(id)init{
    
    if(!self){
        self = [super init];
        
    }
    
    return self;
}


-(void)configureView{
    
    self.backgroundColor = [HLTheme viewBackgroundColor];
    self.dataSource = self;
    //  self.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle: nil];
    [self registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //  self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadOffersCollectionViews)
                  forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.refreshControl];
    self.disableRefreshFlag = NO;
    self.scrollEnabled = YES;
    self.alwaysBounceVertical = YES;
}

-(void)updateDataFromCloud{
    
    NSLog(@"Start loading" );
    
    [self.noContentLabel removeFromSuperview];
    
    if (!self.disableRefreshFlag) {
        
        
        if(!self.isLoading){
            
            [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            
            self.isLoading = YES;
            NSLog(@"In loading" );
            
            [[OffersManager sharedInstance]retrieveOffersWithSuccess:^(NSArray *objects) {
                
                self.isLoading = NO;
                
                [MBProgressHUD hideHUDForView:self.superview animated:YES];
                
                if ([self.objectDataSource count]==0 && [objects count] == 0) {
                    
                    [self addNoContentView];
                    
                    return ;
                }
                
                if([[OffersManager sharedInstance]pageCounter] == 1){
                    
                    self.objectDataSource = [[NSMutableArray alloc]initWithArray:objects];
                    
                    [self reloadData];
                    
                }
                else{
                    
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
                    
                    for (int i = [self.objectDataSource count]; i < [self.objectDataSource count] + [objects count]; i++) {
                        
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                        [indexPaths addObject:indexPath];
                        
                    }
                    
                    [self.objectDataSource addObjectsFromArray:objects];
                    
                    if([objects count]!= 0){
                        
                        [self reloadData];
                        
                    }
                    //                    [UIView setAnimationsEnabled:NO];
                    //
                    //                    [self performBatchUpdates:^{
                    //                        [self reloadItemsAtIndexPaths:indexPaths];
                    //                    } completion:^(BOOL finished) {
                    //                        [UIView setAnimationsEnabled:YES];
                    //                    }];
                }
                NSLog(@"Loading over" );
                
                
            } failure:^(id error) {
                
                self.isLoading = NO;
                
                [MBProgressHUD hideHUDForView:self.superview animated:YES];
                
            }];
            
        }
        
        [MBProgressHUD hideHUDForView:self.superview animated:YES];
        
    }
    
}

-(void)reloadOffersCollectionViews{
    
    
    if (self.refreshControl) {
        
        
        [self updateDataFromCloud];
        
        [self.refreshControl endRefreshing];
        
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height )
    {
        [self updateDataFromCloud];
    }
    
}

-(void)reloadDataByOffersArray:(NSArray *)offers{
    
    
    if ([offers count]==0 || !offers) {
        
        [self addNoContentView];
        
    }
    
    self.objectDataSource = [[NSMutableArray alloc]initWithArray:offers];
    
    if(self.objectDataSource){
        
        [self reloadData];
        
    }
    
    
}

#pragma mark collectionview delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.objectDataSource count];
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    ItemCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    OfferModel *offer = [self.objectDataSource objectAtIndex:indexPath.row];
    
    [cell updateCellWithOfferModel:offer];
    
    
    return cell;
}


#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [HUD removeFromSuperview];
    HUD = nil;
    
}

-(void)addNoContentView{
    
    self.noContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 44)];
    self.noContentLabel.text = @"No offers at the moment";
    self.noContentLabel.textColor = [UIColor lightGrayColor];
    self.noContentLabel.font = [UIFont systemFontOfSize:17.0f];
    self.noContentLabel.textAlignment = NSTextAlignmentCenter;

    UIView *contentView = [[UIView alloc]initWithFrame:self.frame];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:noContentLabel];
    [self addSubview:self.noContentLabel];
}
@end
