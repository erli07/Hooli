//
//  ActivityCategoryViewController.h
//  Hooli
//
//  Created by Er Li on 3/15/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLActivityCategoryDelegate <NSObject>

@optional
- (void)didSelectEventCategory:(NSString *)eventCategory;
- (void)didSelectEventCategories:(NSArray *)eventCategories;


@end

@interface ActivityCategoryViewController : UITableViewController

@property (nonatomic, weak) id<HLActivityCategoryDelegate> delegate;
@property (nonatomic, assign) BOOL isMultipleSelection;


@end
