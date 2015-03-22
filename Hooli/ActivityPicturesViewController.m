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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
        
    }];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_photosArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    PFFile *imageFile = [_photosArray objectAtIndex:indexPath.row];
    
    [cell updateCellWithImageFile:imageFile];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
