//
//  HLConstant.h
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLConstant : NSObject


extern NSString *const kHLOfferCategoryHomeGoods;
extern NSString *const kHLOfferCategoryFurniture;
extern NSString *const kHLOfferCategoryBabyKids;
extern NSString *const kHLOfferCategoryBooks;
extern NSString *const kHLOfferCategoryClothes;
extern NSString *const kHLOfferCategoryBooks;
extern NSString *const kHLOfferCategoryElectronics ;
extern NSString *const kHLOfferCategorySportingGoods;
extern NSString *const kHLOfferCategoryCollectiblesArt;
extern NSString *const kHLOfferCategoryOther;

extern int const kHLOfferCellHeight;
extern int const kHLOfferCellWidth;
extern int const kHLOffersNumberShowAtFirstTime;
extern int const kHLNeedsNumberShowAtFirstTime;
extern int const kHLMaxSearchDistance;
extern int const kHLDefaultSearchDistance;

extern NSString *const kHLUserModelKeyEmail;
extern NSString *const kHLUserModelKeyUserName;
extern NSString *const kHLUserModelKeyPortraitImage;
extern NSString *const kHLUserModelKeyUserId;
extern NSString *const kHLUserModelKeyPassword;
extern NSString *const kHLUserModelKeyUserIdMD5;
extern NSString *const kHLOfferModelKeyImage;
extern NSString *const kHLOfferModelKeyThumbNail;


extern NSString *const kHLOfferModelKeyPrice;
extern NSString *const kHLOfferModelKeyLikes;
extern NSString *const kHLOfferModelKeyDescription;
extern NSString *const kHLOfferModelKeyCategory;
extern NSString *const kHLOfferModelKeyUser;
extern NSString *const kHLOfferModelKeyOfferId;
extern NSString *const kHLOfferModelKeyOfferName;
extern NSString *const kHLOfferModelKeyGeoPoint;
extern NSString *const kHLOfferModelKeyOfferStatus;

extern NSString *const kHLNeedsModelKeyPrice;
extern NSString *const kHLNeedsModelKeyLikes;
extern NSString *const kHLNeedsModelKeyDescription;
extern NSString *const kHLNeedsModelKeyCategory;
extern NSString *const kHLNeedsModelKeyUser;
extern NSString *const kHLNeedsModelKeyId;
extern NSString *const kHLNeedsModelKeyName;
extern NSString *const kHLNeedsModelKeyGeoPoint;
extern NSString *const kHLNeedsModelKeyStatus;

extern NSString *const kHLOfferPhotoKeyOfferID;
extern NSString *const kHLOfferPhotKeyPhoto;

extern NSString *const kHLCloudOfferClass;
extern NSString *const kHLCloudActivityClass;
extern NSString *const kHLCloudNeedClass;
extern NSString *const kHLCloudUserClass;

extern NSString *const kHLActivityKeyOffer;
extern NSString *const kHLActivityKeyUser;


extern NSString *const kHLFilterDictionarySearchType;
extern NSString *const kHLFilterDictionarySearchKeyCategory;
extern NSString *const kHLFilterDictionarySearchKeyWords;
extern NSString *const kHLFilterDictionarySearchKeyUser;
extern NSString *const kHLFilterDictionarySearchKeyUserLikes;

extern NSString *const kHLOfferAttributesLikeCountKey;
extern NSString *const kHLOfferAttributesLikersKey;
extern NSString *const kHLOfferAttributesIsLikedByCurrentUserKey;
extern NSString *const kHLOfferAttributesLikerdOffersKey;

@end
