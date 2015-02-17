//
//  OfferCondition.m
//  Hooli
//
//  Created by Er Li on 2/16/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "OfferCondition.h"
#import "HLConstant.h"
@implementation OfferCondition



+(NSArray *)allConditions{
    
    //  return [[NSArray alloc]initWithObjects:kHLOfferCategoryHomeGoods,kHLOfferCategoryFurniture,kHLOfferCategoryBabyKids,kHLOfferCategoryBooks,kHLOfferCategoryWomenClothes,kHLOfferCategoryMenClothes,kHLOfferCategoryCollectiblesArt,kHLOfferCategoryElectronics,kHLOfferCategorySportingGoods,kHLOfferCategoryOther,nil];
    
    return [[NSArray alloc]initWithObjects:@"New",@"Rarely Used",@"Used",nil];
}
@end
