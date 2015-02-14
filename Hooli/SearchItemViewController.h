//
//  SearchItemViewController.h
//  Hooli
//
//  Created by Er Li on 10/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultViewController.h"

@protocol ShowSearchResultDelegate <NSObject>

-(void)showSearchResultVC;

@end

@interface SearchItemViewController : UITableViewController
@property (nonatomic, strong) NSArray* categories;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) id <ShowSearchResultDelegate> delegate; //define MyClassDelegate as delegate

@end

