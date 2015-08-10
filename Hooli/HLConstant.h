//
//  HLConstant.h
//  Hooli
//
//  Created by Er Li on 11/1/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>


#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define     FIRST_LAUNCH_KEY @"FIRST_LAUNCH_KEY"

#define     ITEM_CONDITION_NEW @"New"
#define     ITEM_CONDITION_RARELY_USED @"Rarely used"
#define     ITEM_CONDITION_USED @"USED"

#define     USER_GENDER_MALE @"Male"
#define     USER_GENDER_FEMALE @"Female"

#define     TAB_BAR_INDEX_EVENT_PAGE 0
#define     TAB_BAR_INDEX_ITEM_PAGE 1
#define     TAB_BAR_INDEX_MESSAGES 2
#define     TAB_BAR_INDEX_NOTIFICATION 3
#define     TAB_BAR_INDEX_MY_PROFILE 4

@interface HLConstant : NSObject

extern NSString *const kHLOfferCategoryHomeGoods;
extern NSString *const kHLOfferCategoryFurniture;
extern NSString *const kHLOfferCategoryBabyKids;
extern NSString *const kHLOfferCategoryBooks;
extern NSString *const kHLOfferCategoryWomenClothes;
extern NSString *const kHLOfferCategoryMenClothes;

extern NSString *const kHLOfferCategoryClothes;
extern NSString *const kHLOfferCategoryBooks;
extern NSString *const kHLOfferCategoryElectronics ;
extern NSString *const kHLOfferCategorySportingGoods;
extern NSString *const kHLOfferCategoryCollectiblesArt;
extern NSString *const kHLOfferCategoryOther;

extern int const KHLInitialCredits;
extern int const kHLOfferCellHeight;
extern int const kHLOfferCellWidth;
extern int const kHLOffersNumberShowAtFirstTime;
extern int const kHLNeedsNumberShowAtFirstTime;
extern int const kHLMaxSearchDistance;
extern int const kHLDefaultSearchDistance;

extern NSString *const kHLCommentTypeKey;
extern NSString *const kHLCommentTypeOffer;
extern NSString *const kHLCommentTypeNeed;

extern NSString *const kHLUserModelKeyEmail;
extern NSString *const kHLUserModelKeyUserName;
extern NSString *const kHLUserModelKeyPortraitImage;
extern NSString *const kHLUserModelKeyUserId;
extern NSString *const kHLUserModelKeyPassword;
extern NSString *const kHLUserModelKeyUserIdMD5;
extern NSString *const kHLUserModelKeyGender;
extern NSString *const kHLUserModelKeyPhoneNumber;
extern NSString *const kHLUserModelKeyWechatNumber;
extern NSString *const kHLUserModelKeySignature;
extern NSString *const kHLUserModelKeyHobby;
extern NSString *const kHLUserModelKeyAge;
extern NSString *const kHLUserModelKeyWork;
extern NSString *const kHLUserModelKeyCredits;
extern NSString *const kHLUserFacebookIDKey;

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
extern NSString *const kHLOfferModelKeyToUser;
extern NSString *const kHLOfferModelKeyCondition;

extern NSString *const kHLNeedsModelKeyPrice;
extern NSString *const kHLNeedsModelKeyLikes;
extern NSString *const kHLNeedsModelKeyDescription;
extern NSString *const kHLNeedsModelKeyCategory;
extern NSString *const kHLNeedsModelKeyUser;
extern NSString *const kHLNeedsModelKeyId;
extern NSString *const kHLNeedsModelKeyName;
extern NSString *const kHLNeedsModelKeyGeoPoint;
extern NSString *const kHLNeedsModelKeyStatus;

extern NSString *const kHLInstallationUserKey;

extern NSString *const kHLOfferPhotoKeyOfferID;
extern NSString *const kHLOfferPhotKeyPhoto;

extern NSString *const kHLCloudOfferClass;
extern NSString *const kHLCloudActivityClass;
extern NSString *const kHLCloudMessagesClass;
extern NSString *const kHLCloudChatClass;
extern NSString *const kHLCloudNotificationClass;
extern NSString *const kHLCloudItemNeedClass;
extern NSString *const kHLCloudNeedClass;
extern NSString *const kHLCloudUserClass;
extern NSString *const kHLCloudOfferImagesClass;
extern NSString *const kHLCloudEventImagesClass;
extern NSString *const kHLCloudCreditsClass;
extern NSString *const kHLCloudEventClass;
extern NSString *const kHLCloudEventMemberClass;
extern NSString *const kHLCloudBlackListClass;

extern NSString *const kHLActivityKeyOffer;
extern NSString *const kHLActivityKeyUser;


extern NSString *const kHLFilterDictionarySearchType;
extern NSString *const kHLFilterDictionarySearchKeyCategory;
extern NSString *const kHLFilterDictionarySearchKeyWords;
extern NSString *const kHLFilterDictionarySearchKeyUser;
extern NSString *const kHLFilterDictionarySearchKeyUserLikes;
extern NSString *const kHLFilterDictionarySearchKeyFollowedUsers;

extern NSString *const kHLOfferAttributesLikeCountKey;
extern NSString *const kHLOfferAttributesLikersKey;
extern NSString *const kHLOfferAttributesIsLikedByCurrentUserKey;
extern NSString *const kHLOfferAttributesLikerdOffersKey;

//Event Member Class
extern NSString *const kHLEventMemberKeyEvent;
extern NSString *const kHLEventMemberKeyEventId;
extern NSString *const kHLEventMemberKeyMember;
extern NSString *const kHLEventMemberKeyMemberRole;

//Event Class


extern NSString *const kHLEventKeyTitle;
extern NSString *const kHLEventKeyThumbnail;
extern NSString *const kHLEventKeyDescription;
extern NSString *const kHLEventKeyUserGeoPoint;
extern NSString *const kHLEventKeyEventGeoPoint;
extern NSString *const kHLEventKeyDate;
extern NSString *const kHLEventKeyAnnoucement;
extern NSString *const kHLEventKeyHost;
extern NSString *const kHLEventKeyCategory ;
extern NSString *const kHLEventKeyMemberNumber;
extern NSString *const kHLEventKeyImages;
extern NSString *const kHLEventKeyEventLocation;
extern NSString *const kHLEventKeyDateText;

extern NSString *const kHLEventCategoryEating ;
extern NSString *const kHLEventCategoryShopping ;
extern NSString *const kHLEventCategoryMovie ;


extern NSString *const kHLActivityKeyId;
extern NSString *const kHLActivityKeyName;
extern NSString *const kHLActivityKeyGeoPoint;
extern NSString *const kHLActivityKeyDate;
extern NSString *const kHLActivityKeyThumbnail;

extern NSString *const kHLActivityRelationshipKeyActivity;
extern NSString *const kHLActivityRelationshipKeyUser;
extern NSString *const kHLActivityRelationshipKeyIsHost;

extern NSString *const kHLNotificationTypeKey;
extern NSString *const kHLNotificationFromUserKey;
extern NSString *const kHLNotificationToUserKey;
extern NSString *const kHLNotificationContentKey;
extern NSString *const kHLNotificationOfferKey;
extern NSString *const kHLNotificationNeedKey;
extern NSString *const kHLNotificationEventKey;

extern NSString *const kHLNotificationTypeLike;
extern NSString *const kHLNotificationTypeFollow ;
extern NSString *const kHLNotificationTypeActivityComment;
//extern NSString *const kHLNotificationTypeComment;
extern NSString *const kHLNotificationTypeOfferComment;
extern NSString *const kHLNotificationTypeNeedComment;
extern NSString *const kHLNotificationTypeJoined;
extern NSString *const kHLNotificationTypeJoinEvent;
extern NSString *const kHLNotificationTypeInvitation;
extern NSString *const kHLNotificationTypeAcceptInvitation;

extern NSString *const khlNotificationTypMakeOffer;
extern NSString *const khlNotificationTypOfferItem;
extern NSString *const khlNotificationTypAcceptOffer;
extern NSString *const khlNotificationAddValue;
extern NSString *const khlNotificationSubValue;
extern NSString *const khlNotificationTypeOfferSold;

extern NSString *const khlOfferImagesOfferKey;

extern NSString *const kHLAppDelegateApplicationDidReceiveRemoteNotification;
extern NSString *const kHlUserDefaultsActivityFeedViewControllerLastRefreshKey;
extern NSString *const kHLUtilityUserLikedUnlikedPhotoCallbackFinishedNotification;
extern NSString *const kHLUtilityDidFinishProcessingProfilePictureNotification;
extern NSString *const kHLEventDetailsReloadMemberContentSizeNotification;
extern NSString *const kHLItemDetailsUserCommentedNotification;
extern NSString *const kHLItemDetailsReloadContentSizeNotification;
extern NSString *const kHLItemDetailsLiftCommentViewNotification;
extern NSString *const kHLItemDetailsPutDownCommentViewNotification;
extern NSString *const kHLUserDefaultsCacheFacebookFriendsKey;
extern NSString *const kHLLoadFeedObjectsNotification;
extern NSString *const kHLLoadMessageObjectsNotification;
extern NSString *const kHLShowCameraViewNotification;
extern NSString *const kHLSeeUserProfileNotification;

extern NSString *const kHLCreditsKeyFromUser;
extern NSString *const kHLCreditsKeyToUser;
extern NSString *const kHLCreditsKeyOffer;
extern NSString *const kHLCreditsKeyType;
extern NSString *const kHLCreditsKeyCreditsValue;

extern NSString *const kHLCreditsKeyTypeEarn;
extern NSString *const kHLCreditsKeyTypeSpend;

#pragma mark - Cached User Attributes
// keys
extern NSString *const kHLUserAttributesIsFollowedByCurrentUserKey;

#pragma mark - PFPush Notification Payload Keys
extern NSString *const kAPNSKey;
extern NSString *const kAPNSAlertKey;
extern NSString *const kAPNSBadgeKey;
extern NSString *const kAPNSSoundKey;

extern NSString *const kHLPushPayloadPayloadTypeKey;
extern NSString *const kHLPushPayloadPayloadTypeNotificationFeedKey;
extern NSString *const kHLPushPayloadPayloadTypeMessagesKey;


extern NSString *const kHLPushPayloadActivityTypeKey;
extern NSString *const kHLPushPayloadActivityLikeKey;
extern NSString *const kHLPushPayloadActivityCommentNeedKey;
extern NSString *const kHLPushPayloadActivityCommentOfferKey;
extern NSString *const kHLPushPayloadActivityFollowKey;
extern NSString *const kHLPushPayloadActivityJoinEventKey;
extern NSString *const kHLPushPayloadActivityMakeOfferKey;

extern NSString *const kHLPushPayloadFromUserObjectIdKey;
extern NSString *const kHLPushPayloadToUserObjectIdKey;
extern NSString *const kHLPushPayloadItemObjectIdKey;

@end
