//
//  ActivityPicturesViewController.h
//  Hooli
//
//  Created by Er Li on 3/21/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ActivityPicturesViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}

@property (nonatomic) PFObject *aObject;
@property (nonatomic) UICollectionView *_collectionView;

@end
