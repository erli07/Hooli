//
//  NeedsCollectionViewFlowLayout.m
//  Hooli
//
//  Created by Er Li on 12/24/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedsCollectionViewFlowLayout.h"

@implementation NeedsCollectionViewFlowLayout

-(void)configureLayout{
    
    self.sectionInset = UIEdgeInsetsMake(0,5,5,5);
    self.minimumInteritemSpacing = 3;
    self.minimumLineSpacing = 10;
    self.itemSize = CGSizeMake(150, 150);
}
@end
