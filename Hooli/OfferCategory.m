//
//  OfferCategory.m
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "OfferCategory.h"
#import "HLConstant.h"
@implementation OfferCategory

+(NSString *)homeGoods{
    return kHLOfferCategoryHomeGoods;
}
+(NSString *)furniture{
    return kHLOfferCategoryFurniture;
}
+(NSString *)babyKids{
    return kHLOfferCategoryBabyKids;
}
+(NSString *)books{
    return kHLOfferCategoryBooks;
}

+(NSArray *)allCategories{
    
    return [[NSArray alloc]initWithObjects:kHLOfferCategoryHomeGoods,kHLOfferCategoryFurniture,kHLOfferCategoryBabyKids,kHLOfferCategoryBooks,kHLOfferCategoryClothes,kHLOfferCategoryCollectiblesArt,kHLOfferCategoryElectronics,kHLOfferCategorySportingGoods,kHLOfferCategoryOther,nil];
}
@end
