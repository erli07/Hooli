//
//  HLConstant.m
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "HLConstant.h"
#import <Parse/Parse.h>

@implementation HLConstant

NSString *const kHLOfferCategoryHomeGoods = @"Home Goods";
NSString *const kHLOfferCategoryFurniture = @"Furniture";
NSString *const kHLOfferCategoryBabyKids = @"Baby & Kids";
NSString *const kHLOfferCategoryWomenClothes = @"Women Clothes & Shoes";
NSString *const kHLOfferCategoryMenClothes = @"Men Clothes & Shoes";
NSString *const kHLOfferCategoryBooks = @"Books";
NSString *const kHLOfferCategoryElectronics = @"Electronics";
NSString *const kHLOfferCategoryCollectiblesArt = @"Collectibles & Art";
NSString *const kHLOfferCategoryOther = @"Other";
NSString *const kHLOfferCategorySportingGoods = @"Sporting Goods";

NSString *const kHLNeedCategory1 = @"聚餐吃饭";
NSString *const kHLNeedCategory2 = @"生活服务";
NSString *const kHLNeedCategory3 = @"拼车搭伙";
NSString *const kHLNeedCategory4 = @"户外活动";
NSString *const kHLNeedCategory5 = @"娱乐休闲";
NSString *const kHLNeedCategory6=  @"找工作";
NSString *const kHLNeedCategory7 = @"找室友";
NSString *const kHLNeedCategory8 = @"情感咨询";
NSString *const kHLNeedCategory9 = @"其他";


/*
 
 活动种类：
 
 结伴旅行
 户外活动
 娱乐休闲
 
 
 
 */



int const kHLOfferCellHeight = 151.0;
int const kHLOfferCellWidth = 151.0;
int const kHLOffersNumberShowAtFirstTime = 100;
int const kHLNeedsNumberShowAtFirstTime = 30;
int const kHLMaxSearchDistance = 50;
int const kHLDefaultSearchDistance = 50;

NSString *const kHLUserModelKeyEmail = @"email";
NSString *const kHLUserModelKeyUserName = @"username";
NSString *const kHLUserModelKeyPortraitImage = @"PortraitImage";
NSString *const kHLUserModelKeyUserId = @"objectId";
NSString *const kHLUserModelKeyPassword = @"password";
NSString *const kHLUserModelKeyUserIdMD5 = @"objectId_MD5";
NSString *const kHLUserFacebookIDKey = @"facebookId";



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
NSString *const kHLOfferModelKeyOfferStatus = @"offerStatus";


NSString *const kHLNeedsModelKeyPrice= @"price";
//NSString *const kHLNeedsModelKeyLikes;
NSString *const kHLNeedsModelKeyDescription = @"description";
NSString *const kHLNeedsModelKeyCategory = @"category";
NSString *const kHLNeedsModelKeyUser = @"user";
NSString *const kHLNeedsModelKeyId = @"objectId";
NSString *const kHLNeedsModelKeyName = @"name";
NSString *const kHLNeedsModelKeyGeoPoint = @"geoPoint";
NSString *const kHLNeedsModelKeyStatus = @"status";

//Installation

NSString *const kHLInstallationUserKey = @"user";

//Offer Class
NSString *const kHLOfferPhotoKeyOfferID = @"offerID";
NSString *const kHLOfferPhotKeyPhoto = @"photo";

NSString *const kHLCloudOfferClass = @"Offer";
NSString *const kHLCloudNeedClass = @"Need";
NSString *const kHLCloudNotificationClass = @"Notification";

NSString *const kHLCloudUserClass = @"_User";
NSString *const kHLCloudActivityClass = @"Activity";

NSString *const kHLActivityKeyOffer = @"offer";
NSString *const kHLActivityKeyUser = @"user";

NSString *const kHLFilterDictionarySearchType = @"searchType";
NSString *const kHLFilterDictionarySearchKeyCategory = @"searchByCategory";
NSString *const kHLFilterDictionarySearchKeyWords = @"searchByWords";
NSString *const kHLFilterDictionarySearchKeyUser = @"searchByUser";
NSString *const kHLFilterDictionarySearchKeyUserLikes = @"searchByUserLikes";
NSString *const kHLFilterDictionarySearchKeyFollowedUsers = @"searchByFollowedUsers";

NSString *const kHLOfferAttributesLikeCountKey = @"likeCount";
NSString *const kHLOfferAttributesLikersKey = @"likers";
NSString *const kHLOfferAttributesLikerdOffersKey = @"likedOffers";
NSString *const kHLOfferAttributesIsLikedByCurrentUserKey = @"islikedByCurrentUser";

NSString *const kHLNotificationTypeKey = @"type";
NSString *const kHLNotificationFromUserKey = @"fromUser";
NSString *const kHLNotificationToUserKey = @"toUser";
NSString *const kHLNotificationContentKey = @"content";
NSString *const kHLNotificationOfferKey = @"offer";

NSString *const kHLNotificationTypeLike       = @"like";
NSString *const kHLNotificationTypeFollow     = @"follow";
NSString *const kHLNotificationTypeComment    = @"comment";
NSString *const kHLNotificationTypeJoined     = @"joined";
NSString *const khlNotificationTypMakeOffer     = @"make offer";

//Cache
NSString *const kHLUserAttributesIsFollowedByCurrentUserKey    = @"isFollowedByCurrentUser";

NSString *const kHLAppDelegateApplicationDidReceiveRemoteNotification = @"com.Hooli.ApplicationDidReceiveRemoteNotification";
NSString *const kHlUserDefaultsActivityFeedViewControllerLastRefreshKey = @"com.Hooli.Feed.lastRefresh";
NSString *const kHLUtilityUserLikedUnlikedPhotoCallbackFinishedNotification = @"com.Hooli.userLikedUnlikedPhotoCallbackFinished";
NSString *const kHLUtilityDidFinishProcessingProfilePictureNotification  = @"com.Hooli.didFinishProcessingProfilePictureNotification";
NSString *const kHLItemDetailsUserCommentedNotification = @"com.Hooli.itemDetailsUserCommentedNotification";
NSString *const kHLItemDetailsReloadContentSizeNotification = @"com.Hooli.itemDetailsReloadContentSizeNotification";
NSString *const kHLItemDetailsLiftCommentViewNotification = @"com.Hooli.itemDetailsLiftCommentViewNotification";
NSString *const kHLItemDetailsPutDownCommentViewNotification = @"com.Hooli.itemDetailsPutDownCommentViewNotification";
NSString *const kHLUserDefaultsCacheFacebookFriendsKey = @"com.Hooli.userDefaultsCacheFacebookFriendsKey";
NSString *const kHLLoadFeedObjectsNotification = @"com.Hooli.loadFeedObjects";
NSString *const kHLLoadMessageObjectsNotification = @"com.Hooli.loadMessageObjects";

#pragma mark - Push Notification Payload Keys

NSString *const kAPNSKey = @"aps";
NSString *const kAPNSAlertKey = @"alert";
NSString *const kAPNSBadgeKey = @"badge";
NSString *const kAPNSSoundKey = @"sound";

// the following keys are intentionally kept short, APNS has a maximum payload limit
NSString *const kHLPushPayloadPayloadTypeKey          = @"p";
NSString *const kHLPushPayloadPayloadTypeNotificationFeedKey  = @"nf";
NSString *const kHLPushPayloadPayloadTypeMessagesKey = @"m";


NSString *const kHLPushPayloadActivityTypeKey     = @"t";
NSString *const kHLPushPayloadActivityLikeKey     = @"l";
NSString *const kHLPushPayloadActivityCommentKey  = @"c";
NSString *const kHLPushPayloadActivityFollowKey   = @"f";

NSString *const kHLPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kHLPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kHLPushPayloadItemObjectIdKey      = @"objId";

@end
