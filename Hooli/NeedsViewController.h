//
//  NeedsViewController.h
//  Hooli
//
//  Created by Er Li on 12/24/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NeedsCollectionViewFlowLayout.h"
#import "NeedsCollectionView.h"

@interface NeedsViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>


@property (nonatomic, weak) IBOutlet NeedsCollectionView * collectionView;

@property (nonatomic, weak) IBOutlet NeedsCollectionViewFlowLayout* layout;

@property (nonatomic, strong) NSArray* collections;

@end
