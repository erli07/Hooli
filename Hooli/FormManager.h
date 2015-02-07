//
//  FormManager.h
//  Hooli
//
//  Created by Er Li on 1/12/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostFormViewController.h"
@interface FormManager : NSObject
+(FormManager *)sharedInstance;

@property (nonatomic, assign) DetailType detailType;
@property (nonatomic) NSString *itemName;
@property (nonatomic) NSString *itemDescription;
@property (nonatomic) NSString *itemPrice;
@property (nonatomic) NSString *itemCategory;
@property (nonatomic) NSString *itemCondition;
@property (nonatomic) NSString *itemLocation;


@property (nonatomic) NSString *needItemDescription;
@property (nonatomic) NSString *needItemBudget;

@end
