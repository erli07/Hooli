//
//  UserCartViewController.m
//  Hooli
//
//  Created by Er Li on 11/12/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "UserCartViewController.h"
#import "MyCartViewController.h"
#import "ItemCell.h"
#import "MainCollectionViewFlowLayout.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "ItemDetailViewController.h"
#import "OffersManager.h"
#import "HLSettings.h"
#import "AccountManager.h"
@interface UserCartViewController ()

@end

@implementation UserCartViewController
@synthesize userNameLabel,profileImageView,userID;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.tintColor = [HLTheme mainColor];
    [self.layout configureLayout] ;
    [self.collectionView configureView];
    self.collectionView.delegate = self;
    [self updateProfileData];
    //[self registerNotifications];
    [self updateCollectionViewData];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [[OffersManager sharedInstance]clearData];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if([[HLSettings sharedInstance]isRefreshNeeded]){
        
        [self updateCollectionViewData];
        [[HLSettings sharedInstance]setIsRefreshNeeded:NO];
    }
}

#pragma register notification

-(void)registerNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCollectionViewData)
                                                 name:@"Hooli.reloadMyCartData" object:nil];
}

-(void)updateCollectionViewData{
    
    
    PFQuery *query = [PFUser query];
    
    [query whereKey:@"objectId" equalTo:self.userID];
    
    
      [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
          
          if(object){
              
              NSDictionary *filterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                kHLFilterDictionarySearchKeyUser, kHLFilterDictionarySearchType, object, kHLFilterDictionarySearchKeyUser,nil];
              
              [[OffersManager sharedInstance]clearData];
              
              [[OffersManager sharedInstance]setFilterDictionary:filterDictionary];
              
              [self.collectionView updateDataFromCloud];
              
          }
          
      }];

    
    
}

- (void)updateProfileData {
    
    [[AccountManager sharedInstance]loadAccountDataWithUserId:self.userID Success:^(id object) {
        
        
        UserModel *userModel = (UserModel *)object;
        
        self.userNameLabel.text = userModel.username;
        
        self.title = userModel.username;

        self.profileImageView.image = userModel.portraitImage;
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
        self.profileImageView.layer.masksToBounds = YES;
        
        
    } Failure:^(id error) {
        
        NSLog(@"%@",error);
        
    }];
    

}

#pragma mark collectionview delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *cell = (ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
    vc.offerId = cell.offerId;
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height )
    {
        [self.collectionView updateDataFromCloud];
    }
}

@end
