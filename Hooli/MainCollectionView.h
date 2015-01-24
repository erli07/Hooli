//
//  MainCollectionView.h
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MainCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate,UIScrollViewDelegate>
-(void)configureView;
-(void)updateDataFromCloud;
-(void)reloadDataByOffersArray:(NSArray *)offers;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *objectDataSource;
@property (nonatomic) __block BOOL isLoading;

@end
