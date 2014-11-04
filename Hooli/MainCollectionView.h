//
//  MainCollectionView.h
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MainCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate>
-(void)configureView;
-(void)updateDataFromCloud;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *objectDataSource;
@end
