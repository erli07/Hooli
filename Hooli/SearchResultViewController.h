//
//  SearchResultViewController.h
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionView.h"
#import "MainCollectionViewFlowLayout.h"
@interface SearchResultViewController : UIViewController
@property (weak, nonatomic) IBOutlet MainCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MainCollectionViewFlowLayout *layout;

@end
