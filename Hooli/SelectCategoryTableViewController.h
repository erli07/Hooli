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
- (void)didSelectItemCategory:(NSString *)itemCategory;
- (void)didSelectItemCategories:(NSArray *)itemsCategories;

@end

@interface SelectCategoryTableViewController : UITableViewController

@property (nonatomic, weak) id<HLItemCategoryDelegate> delegate;
@property (nonatomic, assign) BOOL isMultipleSelection;
@property (nonatomic) NSArray *selectedArray;

@end
