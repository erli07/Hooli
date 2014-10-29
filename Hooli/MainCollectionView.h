//
//  MainCollectionView.h
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
-(void)configureView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
