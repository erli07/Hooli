//
//  ActivityCategoryViewController.m
//  Hooli
//
//  Created by Er Li on 3/15/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityCategoryViewController.h"
#import "HLTheme.h"


@interface ActivityCategoryViewController ()

@property (nonatomic) NSArray *eventNameArray;
@property (nonatomic) NSArray *eventSymbolsArray;

@end

@implementation ActivityCategoryViewController

@synthesize eventNameArray = _eventNameArray;
@synthesize eventSymbolsArray = _eventSymbolsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _eventNameArray = @[@"聚餐吃饭",@"体育娱乐", @"我爱学习"];
    
    _eventSymbolsArray = @[[UIImage imageNamed:@"restaurant-48"], [UIImage imageNamed:@"triathlone-48"], [UIImage imageNamed:@"study-48"]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_eventNameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCategoryCell" forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    cell.textLabel.text = [_eventNameArray objectAtIndex:indexPath.row];
    cell.imageView.image = [_eventSymbolsArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.delegate didSelectEventCategory:[_eventNameArray objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
