//
//  MapViewViewController.h
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionView.h"
#import "MainCollectionViewFlowLayout.h"
#import "ItemCell.h"
#import "MBProgressHUD.h"

@interface HomeViewViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet MainCollectionView * collectionView;

@property (nonatomic, weak) IBOutlet MainCollectionViewFlowLayout* layout;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, strong) NSArray* collections;


@end
