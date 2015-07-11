//
//  HomeOffersViewController.m
//  Hooli
//
//  Created by Er Li on 6/23/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "HomeOffersViewController.h"
#import "HLConstant.h"
#import "MainCollectionViewFlowLayout.h"
#import <Parse/PFQuery.h>
#import <ParseUI/PFCollectionViewCell.h>
#import "HLUtilities.h"
#import "ItemDetailViewController.h"

@interface HomeOffersViewController ()

@end

@implementation HomeOffersViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [self initWithCoder:aDecoder];
    
    if(self){
        
        
    }
    
    return self;
}

//
//- (instancetype)initWithClassName:(NSString *)className {
//    self = [super initWithClassName:className];
//    if (self){
//      self.pullToRefreshEnabled = YES;
//      self.objectsPerPage = 10;
//      self.paginationEnabled = YES;
//    }
//    return self;
//}

-(void)loadView{
    
    [super loadView];
   // [self.collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:@"ItemCell"];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainCollectionViewFlowLayout *layout = (MainCollectionViewFlowLayout *)self.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    layout.minimumInteritemSpacing = 5.0f;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    MainCollectionViewFlowLayout *layout = (MainCollectionViewFlowLayout *)self.collectionViewLayout;
    
    const CGRect bounds = UIEdgeInsetsInsetRect(self.view.bounds, layout.sectionInset);
    CGFloat sideSize = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0f - layout.minimumInteritemSpacing;
    layout.itemSize = CGSizeMake(sideSize, sideSize);
}


#pragma mark -
#pragma mark Query

- (PFQuery *)queryForCollection {
    PFQuery *query = [super queryForCollection];
    return query;
}

#pragma mark -
#pragma mark CollectionView


//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString * const reuseIdentifier = @"ItemCell";
//    
//    OfferModel *offer = [[OfferModel alloc]initOfferWithPFObject:[self.objects objectAtIndex:indexPath.row]];
//    
//    ItemCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    
//   [cell updateCellWithOfferModel:offer];
//    
//    return cell;
//    
//}
- (OfferCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    
    OfferCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath object:object];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.imageView.file = [object objectForKey:kHLOfferModelKeyThumbNail];
    // If the image is nil - set the placeholder
    if (cell.imageView.image == nil) {
        [cell.imageView loadInBackground];
    }

    OfferModel *offer = [[OfferModel alloc]initOfferWithPFObject:object];    
    cell.textLabel.text = offer.offerName;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
   
    [cell layoutSubviews];

    return cell;
}


#pragma mark collectionview delegate


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([HLUtilities checkIfUserLoginWithCurrentVC:self]){
        
        OfferCell *cell = (OfferCell *)[collectionView cellForItemAtIndexPath:indexPath];
        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
        vc.offerId = [[self.objects objectAtIndex:indexPath.row]objectId];
        // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
