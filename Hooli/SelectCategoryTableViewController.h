//
//  SelectCategoryTableViewController.h
//  Hooli
//
//  Created by Er Li on 11/4/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLItemCategoryDelegate <NSObject>

@optional
- (void)didSelectEventCategory:(NSString *)eventCategory;
- (void)didSelectEventCategories:(NSArray *)eventCategories;

@end

@interface SelectCategoryTableViewController : UITableViewController

@property (nonatomic, weak) id<HLItemCategoryDelegate> delegate;
@property (nonatomic, assign) BOOL isMultipleSelection;

@end
