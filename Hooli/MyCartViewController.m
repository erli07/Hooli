//
//  MyCartViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MyCartViewController.h"
#import "ItemCell.h"
#import "MainCollectionViewFlowLayout.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "ItemDetailViewController.h"
#import "OffersManager.h"
#import "HLSettings.h"
@interface MyCartViewController ()<UICollectionViewDelegate,UpdateCollectionViewDelegate,UIActionSheetDelegate>
@property (nonatomic, strong) UISegmentedControl *typeSegmentedControl;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, assign) BOOL offerStatus;

@end
static NSString * const reuseIdentifier = @"Cell";

@implementation MyCartViewController
@synthesize selectIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Items";
    self.view.tintColor = [HLTheme mainColor];
    [self.layout configureLayout] ;
    [self.collectionView configureView];
    self.collectionView.delegate = self;
    [self updateCollectionViewData];
    
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
    
    [[OffersManager sharedInstance]setFilterDictionary:nil];
    
    [[OffersManager sharedInstance]clearData];
    
    [self.collectionView updateDataFromCloud];
    
}
#pragma mark actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (self.actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self updateOfferModelStatus];
                    break;
                case 1:
                    [self deleteOfferCell];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

-(void)deleteOfferCell{
    
    OfferModel *offerModel = (OfferModel *)[self.collectionView.objectDataSource objectAtIndex:self.selectIndex];
    
    [[OffersManager sharedInstance]deleteOfferModelWithOfferId:offerModel.offerId block:^(BOOL succeeded, NSError *error) {
        
        if(succeeded){
            
            [[HLSettings sharedInstance]setIsRefreshNeeded:YES];
            [self updateCollectionViewData];

        }
        
    }];

}

-(void)updateOfferModelStatus{
    
    OfferModel *offerModel = (OfferModel *)[self.collectionView.objectDataSource objectAtIndex:self.selectIndex];
    
    [[OffersManager sharedInstance]updateOfferSoldStatusWithOfferID:offerModel.offerId soldStatus:![offerModel.isOfferSold boolValue] block:^(BOOL succeeded, NSError *error) {
        
        if(succeeded){
            
            [[HLSettings sharedInstance]setIsRefreshNeeded:YES];

            [self updateCollectionViewData];
            
        }
    }];
}

#pragma mark collectionview delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectIndex = indexPath.row;
    
    OfferModel *offerModel = (OfferModel *)[self.collectionView.objectDataSource objectAtIndex:self.selectIndex];
    
    NSString *soldStatusString;
    
    if([offerModel.isOfferSold boolValue]){
        
        soldStatusString = @"Mark as unsold";

    }
    else{
        
        soldStatusString = @"Mark as sold";

    }
    
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                        soldStatusString,
                        @"Delete",
                        nil];
    self.actionSheet.tag = 1;
    [self.actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
    
}


#pragma scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height )
    {
        [self.collectionView updateDataFromCloud];
    }
}

@end

