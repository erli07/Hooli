//
//  NeedsCollectionView.m
//  Hooli
//
//  Created by Er Li on 12/24/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedsCollectionView.h"
#import "NeedsManager.h"
#import "HLTheme.h"
#import "NeedsCell.h"

static NSString * const reuseIdentifier = @"NeedsCell";

@implementation NeedsCollectionView{

MBProgressHUD *HUD;
    
}

@synthesize refreshControl, objectDataSource;
-(id)init{
    
    if(!self){
        self = [super init];
        
    }
    
    return self;
}


-(void)configureView{
    
    self.backgroundColor = [HLTheme viewBackgroundColor];
    self.dataSource = self;
    //  self.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"NeedsCell" bundle: nil];
    [self registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //  self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(reloadCollectionViews)
                  forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.refreshControl];
    
    self.scrollEnabled = YES;
    self.alwaysBounceVertical = YES;
}

-(void)updateDataFromCloud{
    

   [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    
    [[NeedsManager sharedInstance]retrieveNeedsWithSuccess:^(NSArray *objects) {
        
        self.objectDataSource = [[NSMutableArray alloc]initWithArray:objects];
        
        if(self.objectDataSource){
            
            [self reloadData];
        }
        
        [MBProgressHUD hideHUDForView:self.superview animated:YES];

        
        
    } failure:^(id error) {
        
        NSLog(@"Retrived Images Error %@",[error description] );
        
        [MBProgressHUD hideHUDForView:self.superview animated:YES];


        
    }];
}

-(void)reloadCollectionViews{
    
    if (self.refreshControl) {
        
         [MBProgressHUD hideHUDForView:self.superview animated:YES];

        [[NeedsManager sharedInstance]retrieveNeedsWithSuccess:^(NSArray *objects) {
            
            self.objectDataSource = [[NSMutableArray alloc]initWithArray:objects];
            
            if(self.objectDataSource){
                
                [self reloadData];
            }
            
            [self.refreshControl endRefreshing];
            
            
        } failure:^(id error) {
            
            NSLog(@"Retrived Images Error %@",[error description] );
            
            [self.refreshControl endRefreshing];
            
        }];
    }
    
}

-(void)reloadDataByOffersArray:(NSArray *)offers{
    
    self.objectDataSource = [[NSMutableArray alloc]initWithArray:offers];
    
    if(self.objectDataSource){
        
        [self reloadData];
    }
    
    
}

#pragma mark collectionview delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.objectDataSource count];
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NeedsCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NeedsModel *need = [self.objectDataSource objectAtIndex:indexPath.row];
    
    [cell updateCellWithNeedModel:need];
    
    
    return cell;
}


#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    [HUD removeFromSuperview];
    HUD = nil;
    
}
@end
