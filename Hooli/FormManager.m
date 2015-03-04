//
//  FormManager.m
//  Hooli
//
//  Created by Er Li on 1/12/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "FormManager.h"

@implementation FormManager
@synthesize itemCategory,itemCondition,itemDescription,itemLocation,itemName,itemPrice,detailType,needItemBudget,needItemDescription,toUser,profileEmail,profileGender,profilePhone,profileUsername,profileWechat,profileDetailArray,eventDate,eventDescription,eventLocation,eventTitle,eventDetailType;

+(FormManager *)sharedInstance{
    
    static FormManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FormManager alloc] init];
        
    });
    
    return _sharedInstance;
    
}

@end

