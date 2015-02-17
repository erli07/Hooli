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
static NSString * const reuseIdentifier = @"Cell";

@implementation MainCollectionView{
    
    MBProgressHUD *HUD;
}

@synthesize refreshControl, objectDataSource,isLoading,filterDictionaryType,disableRefreshFlag;
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
    
    if (!self.disableRefreshFlag) {
        
        [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
        
        if(!self.isLoading){
            
            self.isLoading = YES;
            NSLog(@"In loading" );
            
            [[OffersManager sharedInstance]retrieveOffersWithSuccess:^(NSArray *objects) {
                
                self.objectDataSource = [[NSMutableArray alloc]initWithArray:objects];
                
                if(self.objectDataSource){
                    
                    [self reloadData];
                }
                NSLog(@"Loading over" );
                
                self.isLoading = NO;
                
                [MBProgressHUD hideHUDForView:self.superview animated:YES];
                
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
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height )
    {
        [self updateDataFromCloud];
    }
    
}

-(void)reloadDataByOffersArray:(NSArray *)offers{
    
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
    
    //    NSLog(@"GET DATA SIZE %lu k", sizeof(offer) );
    //    NSLog(@"Size of %@: %zd k", NSSt       ringFromClass([OfferModel class]), malloc_size((__bridge const void *) offer));
    
    
    [cell updateCellWithOfferModel:offer];
    
    
    return cell;
}


#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [HUD removeFromSuperview];
    HUD = nil;
    
}


@end
