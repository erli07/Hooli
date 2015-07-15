//
//  PostItemViewController.h
//  Hooli
//
//  Created by Er Li on 7/12/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

@interface PostItemViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic) IBOutlet UITableView *detailTable;
@end
