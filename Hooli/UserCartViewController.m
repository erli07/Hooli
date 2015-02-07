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
#import "ActivityManager.h"
#import "HLTheme.h"
@interface UserCartViewController ()
@property (nonatomic, assign) RelationshipType followStatus;
@property (nonatomic, strong) NSArray *followersArray;
@property (nonatomic, strong) NSArray *followingsArray;
@property (nonatomic, strong) NSString *friendsArray;

@end

@implementation UserCartViewController
@synthesize userNameLabel,profileImageView,userID,followersCount,followingCount,user,followButton,followStatus,friendsArray,followersArray,followingsArray;
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
        
        self.user = (PFUser *)object;
        
        UserModel *userModel =  [[UserModel alloc]initUserWithPFObject:object];
        
        self.userNameLabel.text = userModel.username;
        
        self.title = userModel.username;
        
        self.profileImageView.image = userModel.portraitImage;
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
        self.profileImageView.layer.masksToBounds = YES;
        
        [self updateRelationship];
        
        
    } Failure:^(id error) {
        
        NSLog(@"%@",error);
        
    }];
    
    
}

-(void)updateRelationship{
    
    if([self.user.objectId isEqual:[[PFUser currentUser]objectId]]){
        
        self.followButton.hidden = YES;
    }
    else{
        
        self.followButton.hidden = NO;

    }
    
    
    [[ActivityManager sharedInstance]getUserRelationshipWithUserOne:[PFUser currentUser] UserTwo:self.user WithBlock:^(RelationshipType relationType, NSError *error) {
        
        self.followStatus = relationType;
        
        NSLog(@"Get relationship %u", relationType);
        
        if(self.followStatus == HL_RELATIONSHIP_TYPE_FRIENDS || self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWING ){
            
            [self.followButton setTitle:@"Followed" forState:UIControlStateNormal] ;
            [self.followButton setBackgroundColor:[HLTheme mainColor]];
            [self.followButton setTintColor:[UIColor whiteColor]];
            
            
        }
        else{
            
            [self.followButton setTitle:@"Follow" forState:UIControlStateNormal] ;
            [self.followButton setBackgroundColor:[HLTheme mainColor]];
            [self.followButton setTintColor:[UIColor whiteColor]];

        }
        
        [self updateUserFollowCounts];

        
    }];
}


-(void)updateUserFollowCounts{
    
    
    
    [[ActivityManager sharedInstance]getFollowedUsersByUser:self.user block:^(NSArray *array, NSError *error) {
        
        if(array){
            
            self.followersCount.text = [NSString stringWithFormat:@"%d", [array count]];
            
        }

    }];
    
   [[ActivityManager sharedInstance]getFollowersByUser:self.user block:^(NSArray *array, NSError *error) {
       
       if(array){
           
           self.followingCount.text = [NSString stringWithFormat:@"%d", [array count]];
       }
   }];
    
    [[ActivityManager sharedInstance]getFriendsByUser:self.user block:^(NSArray *array, NSError *error) {
        
        if(array){
            
            self.friendsCount.text = [NSString stringWithFormat:@"%d", [array count]];
        }
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

- (IBAction)followItemOwner:(id)sender {
    
    if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWED || self.followStatus == HL_RELATIONSHIP_TYPE_NONE){
        
        [[ActivityManager sharedInstance]followUserInBackground:self.user block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                
                NSLog(@"Follow success!!!");
                
                [self updateRelationship];
                
                
            }
            
        }];
        
    }
    else{
        
        [[ActivityManager sharedInstance]unFollowUserInBackground:self.user block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                
                NSLog(@"UnFollow success!!!");
                
                [self updateRelationship];
                
            }
            
        }];
        
    }
    
    [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
    
}
@end
