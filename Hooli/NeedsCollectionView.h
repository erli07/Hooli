//
//  NeedsCollectionView.h
//  Hooli
//
//  Created by Er Li on 12/24/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface NeedsCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate>
-(void)configureView;
-(void)updateDataFromCloud;
-(void)reloadDataByNeedsArray:(NSArray *)needs;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *objectDataSource;

@end
