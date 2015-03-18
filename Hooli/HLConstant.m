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
NSString *const kHLOfferCategoryBooks = @"Books & Videos";
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
int const kHLOffersNumberShowAtFirstTime = 10;
int const kHLNeedsNumberShowAtFirstTime = 30;
int const kHLMaxSearchDistance = 50;
int const kHLDefaultSearchDistance = 50;
int const kHLInitialCredits = 200;


NSString *const kHLUserModelKeyEmail = @"email";
NSString *const kHLUserModelKeyUserName = @"username";
NSString *const kHLUserModelKeyGender = @"gender";
NSString *const kHLUserModelKeyPhoneNumber = @"phone_number";
NSString *const kHLUserModelKeyWechatNumber = @"wechat_number";
NSString *const kHLUserModelKeyPortraitImage = @"PortraitImage";
NSString *const kHLUserModelKeyUserId = @"objectId";
NSString *const kHLUserModelKeyPassword = @"password";
NSString *const kHLUserModelKeyUserIdMD5 = @"objectId_MD5";
NSString *const kHLUserFacebookIDKey = @"facebookId";
NSString *const kHLUserModelKeyCredits = @"credits";


NSString *const kHLOfferModelKeyImage = @"image";
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
NSString *const kHLOfferModelKeyToUser = @"toUser";

NSString *const kHLNeedsModelKeyPrice= @"price";
//NSString *const kHLNeedsModelKeyLikes;
NSString *const kHLNeedsModelKeyDescription = @"description";
NSString *const kHLNeedsModelKeyCategory = @"category";
NSString *const kHLNeedsModelKeyUser = @"user";
NSString *const kHLNeedsModelKeyId = @"objectId";
NSString *const kHLNeedsModelKeyName = @"name";
NSString *const kHLNeedsModelKeyGeoPoint = @"geoPoint";
NSString *const kHLNeedsModelKeyStatus = @"status";

//Event Class will fix the name later
NSString *const kHLActivityKeyId = @"objectId";
NSString *const kHLActivityKeyName = @"name";
NSString *const kHLActivityKeyGeoPoint = @"geoPoint";
NSString *const kHLActivityKeyDate = @"date";
NSString *const kHLActivityKeyThumbnail = @"thumbnail";


//Event Member Class

NSString *const kHLEventMemberKeyEvent = @"event";
NSString *const kHLEventMemberKeyMember = @"member";
NSString *const kHLEventMemberKeyMemberRole = @"memberRole";

//Installation

NSString *const kHLInstallationUserKey = @"user";

//Offer Class
NSString *const kHLOfferPhotoKeyOfferID = @"offerID";
NSString *const kHLOfferPhotKeyPhoto = @"photo";

//Cloud Class
NSString *const kHLCloudOfferClass = @"Offer";
NSString *const kHLCloudItemNeedClass = @"ItemNeed";
NSString *const kHLCloudNeedClass = @"Need";
NSString *const kHLCloudNotificationClass = @"Notification";
NSString *const kHLCloudUserClass = @"_User";
NSString *const kHLCloudActivityClass = @"Activity";
NSString *const kHLCloudOfferImagesClass = @"OfferImages";
NSString *const kHLCloudEventImagesClass = @"EventImages";
NSString *const kHLCloudCreditsClass = @"Credits";
NSString *const kHLCloudEventClass = @"Event";
NSString *const kHLCloudEventMemberClass = @"Event_Member";

//Activity Class

NSString *const kHLActivityKeyOffer = @"offer";
NSString *const kHLActivityKeyUser = @"user";

NSString *const kHLCreditsKeyFromUser = @"fromUser";
NSString *const kHLCreditsKeyToUser = @"toUser";
NSString *const kHLCreditsKeyOffer = @"offer";
NSString *const kHLCreditsKeyType = @"type";
NSString *const kHLCreditsKeyCreditsValue = @"credits";

NSString *const kHLCreditsKeyTypeEarn = @"earn";
NSString *const kHLCreditsKeyTypeSpend = @"spend";

NSString *const kHLCommentTypeKey = @"type";
NSString *const kHLCommentTypeOffer = @"offer";
NSString *const kHLCommentTypeNeed = @"need";

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

NSString *const kHLEventKeyTitle = @"title";
NSString *const kHLEventKeyThumbnail = @"thumbnail";
NSString *const kHLEventKeyDescription = @"description";
NSString *const kHLEventKeyUserGeoPoint = @"user_geopoint";
NSString *const kHLEventKeyEventGeoPoint = @"event_geopoint";
NSString *const kHLEventKeyEventLocation= @"event_location";
NSString *const kHLEventKeyDate = @"date";
NSString *const kHLEventKeyDateText = @"dateText";
NSString *const kHLEventKeyAnnoucement = @"annoucement";
NSString *const kHLEventKeyCategory = @"category";
NSString *const kHLEventKeyMemberNumber= @"memberNumber";
NSString *const kHLEventKeyImages= @"eventImages";
NSString *const kHLEventKeyHost = @"host";



NSString *const kHLEventCategoryEating = @"eating";
NSString *const kHLEventCategoryShopping = @"shopping";
NSString *const kHLEventCategoryMovie = @"movie";

NSString *const kHLNotificationTypeKey = @"type";
NSString *const kHLNotificationFromUserKey = @"fromUser";
NSString *const kHLNotificationToUserKey = @"toUser";
NSString *const kHLNotificationContentKey = @"content";
NSString *const kHLNotificationOfferKey = @"offer";
NSString *const kHLNotificationNeedKey = @"need";
NSString *const kHLNotificationEventKey = @"event";


NSString *const kHLNotificationTypeLike       = @"like";
NSString *const kHLNotificationTypeFollow     = @"follow";
NSString *const kHLNotificationTypeOfferComment    = @"offerComment";
NSString *const kHLNotificationTypeNeedComment    = @"needComment";
NSString *const kHLNotificationTypeActivityComment    = @"needComment";
NSString *const kHLNotificationTypeJoined     = @"joined";
NSString *const khlNotificationTypMakeOffer     = @"make offer";
NSString *const khlNotificationTypAcceptOffer     = @"accept offer";
NSString *const khlNotificationTypeOfferSold     = @"offer sold";
NSString *const khlNotificationTypOfferItem     = @"Offer Item";
NSString *const kHLNotificationTypeJoinEvent = @"join event";
NSString *const kHLNotificationTypeInvitation = @"invite";
NSString *const kHLNotificationTypeAcceptInvitation = @"accept invitation";

NSString *const khlNotificationAddValue     = @"add";
NSString *const khlNotificationSubValue     = @"sub";

NSString *const khlOfferImagesOfferKey     = @"offer";


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
NSString *const kHLShowCameraViewNotification = @"com.Hooli.showCameraView";


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
NSString *const kHLPushPayloadActivityCommentNeedKey  = @"cn";
NSString *const kHLPushPayloadActivityCommentOfferKey  = @"co";
NSString *const kHLPushPayloadActivityFollowKey   = @"f";

NSString *const kHLPushPayloadFromUserObjectIdKey = @"fu";
NSString *const kHLPushPayloadToUserObjectIdKey   = @"tu";
NSString *const kHLPushPayloadItemObjectIdKey      = @"objId";

@end
