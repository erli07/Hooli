//
//  ActivityPicturesViewController.m
//  Hooli
//
//  Created by Er Li on 3/21/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityPicturesViewController.h"
#import "PhotoCell.h"
#import "HLConstant.h"
#import "MainCollectionViewFlowLayout.h"
@interface ActivityPicturesViewController ()

@property (nonatomic) NSMutableArray *photosArray;

@end

@implementation ActivityPicturesViewController
@synthesize photosArray = _photosArray;
@synthesize aObject = _aObject;


static NSString * const reuseIdentifier = @"PhotoCell";



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    [layout setItemSize:CGSizeMake(100, 100)];
    
    _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:_collectionView];
    
    self.title = @"活动图片";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    _photosArray = [NSMutableArray new];
    
    PFObject *eventImages = [_aObject objectForKey:kHLEventKeyImages];
    
    PFQuery *photoQuery = [PFQuery queryWithClassName:kHLCloudEventImagesClass];
    
    [photoQuery whereKey:@"objectId" equalTo:eventImages.objectId];
    
    [photoQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        for (int i = 0; i< 4; i ++) {
            
            
            PFFile *imageFile = [eventImages objectForKey:[NSString stringWithFormat:@"imageFile%d",i]];
            
            if (imageFile) {
                
                [_photosArray addObject:imageFile];
                
            }
            else{
                
                break;
            }
        }
        
        [_collectionView reloadData];
        
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PFFile *imageFile = [_photosArray objectAtIndex:indexPath.row];
    
    cell.photoImageView = [[UIImageView alloc]initWithFrame:cell.frame];
    
    [cell addSubview:cell.photoImageView];
        
    [cell updateCellWithImageFile:imageFile];
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(100, 100);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//    return UIEdgeInsetsMake(0,5,5,5);
//    
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    
//    return 10.0f;
//}

@end
