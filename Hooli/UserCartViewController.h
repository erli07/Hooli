//
//  UserCartViewController.h
//  Hooli
//
//  Created by Er Li on 11/12/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCollectionViewFlowLayout.h"
#import "MainCollectionView.h"
#import "OfferModel.h"
@interface UserCartViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet MainCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet MainCollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic, strong) NSString *userID;
- (IBAction)followItemOwner:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;

@end
