//
//  PostNeedViewController.h
//  Hooli
//
//  Created by Er Li on 12/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PostFormViewController.h"

@interface PostNeedViewController : UITableViewController

@property (nonatomic,assign) CLLocationCoordinate2D needLocationCoordinate;
@property (nonatomic) NSString *needDescription;
@property (nonatomic) NSString *needBudget;
@property (nonatomic) NSString *needCategory;
@property (nonatomic, assign) DetailType detailType;

@end
