//
//  HLConstant.m
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLConstant.h"

@implementation HLConstant

NSString *const kHLOfferCategoryHomeGoods = @"Home Goods";
NSString *const kHLOfferCategoryFurniture = @"Furniture";
NSString *const kHLOfferCategoryBabyKids = @"Baby & Kids";
NSString *const kHLOfferCategoryClothes = @"Clothes";
NSString *const kHLOfferCategoryBooks = @"Books";
NSString *const kHLOfferCategoryElectronics = @"Electronics";
NSString *const kHLOfferCategoryCollectiblesArt = @"Collectibles & Art";
NSString *const kHLOfferCategoryOther = @"Other";
NSString *const kHLOfferCategorySportingGoods = @"Sporting Goods";

int const kHLOfferCellHeight = 151.0;
int const kHLOfferCellWidth = 151.0;
int const kHLOffersNumberShowAtFirstTime = 6;
int const kHLMaxSearchDistance = 50;
int const kHLDefaultSearchDistance = 50;

NSString *const kHLOfferModelKeyImage = @"imageFile";
NSString *const kHLOfferModelKeyThumbNail = @"thumbNail";


NSString *const kHLOfferModelKeyPrice = @"price";
NSString *const kHLOfferModelKeyLikes = @"offerLikes";
NSString *const kHLOfferModelKeyOfferId = @"objectId";
NSString *const kHLOfferModelKeyDescription = @"description";
NSString *const kHLOfferModelKeyCategory = @"category";
NSString *const kHLOfferModelKeyUser = @"user";
NSString *const kHLOfferModelKeyOfferName = @"offerName";
NSString *const kHLOfferModelKeyGeoPoint = @"geoPoint";

NSString *const kHLOfferPhotoKeyOfferID = @"offerID";
NSString *const kHLOfferPhotKeyPhoto = @"photo";


NSString *const kHLCloudOfferClass = @"Offer";
NSString *const kHLCloudOfferPhotoClass = @"OfferPhoto";

NSString *const kHLFilterDictionarySearchType = @"searchType";
NSString *const kHLFilterDictionarySearchKeyCategory = @"searchByCategory";
NSString *const kHLFilterDictionarySearchKeyWords = @"searchByWords";
@end
