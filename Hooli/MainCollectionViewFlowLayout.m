
//
//  MainCollectionViewFlowLayout.m
//  Hooli
//
//  Created by Er Li on 10/28/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MainCollectionViewFlowLayout.h"
#import "HLConstant.h"
@implementation MainCollectionViewFlowLayout

-(void)configureLayout{
    
    self.sectionInset = UIEdgeInsetsMake(5,5,5,5);
    self.minimumInteritemSpacing = 5;
    self.minimumLineSpacing = 10;
    //self.itemSize = CGSizeMake(kHLOfferCellWidth, kHLOfferCellHeight);
    self.itemSize = CGSizeMake(ITEMCELL_LEGNTH,ITEMCELL_LEGNTH);
   // self.itemSize = CGSizeMake(120, 120);

}


@end
