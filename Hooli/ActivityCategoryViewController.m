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
@property (nonatomic) NSMutableArray *selectionArray;

@end

@implementation ActivityCategoryViewController

@synthesize eventNameArray = _eventNameArray;
@synthesize eventSymbolsArray = _eventSymbolsArray;
@synthesize selectionArray = _selectionArray;
@synthesize isMultipleSelection = _isMultipleSelection;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectionArray = [NSMutableArray new];
    
    self.title = @"活动类别";
    
  //  _eventNameArray = @[@"全部类别",@"聚餐吃饭",@"体育娱乐",@"爬梯聚会", @"我爱学习", @"户外旅行",@"桌游棋牌",@"电子游戏"];
    _eventNameArray = @[@"all",@"eating",@"sports",@"tour", @"shopping", @"movie"];
    
    _eventSymbolsArray = @[[UIImage imageNamed:@"restaurant-48"],[UIImage imageNamed:@"restaurant-48"],[UIImage imageNamed:@"restaurant-48"],[UIImage imageNamed:@"restaurant-48"],[UIImage imageNamed:@"restaurant-48"],[UIImage imageNamed:@"restaurant-48"]];
    
    self.tableView.allowsMultipleSelection = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if(_isMultipleSelection){
    
        [self.delegate didSelectEventCategories:_selectionArray];

    }

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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_isMultipleSelection){
        
        if(indexPath.row == 0){
            
            _selectionArray = nil;
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            
            [_selectionArray removeObject:[_eventNameArray objectAtIndex:indexPath.row]];
            
        }
        else{
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            
            [_selectionArray addObject:[_eventNameArray objectAtIndex:indexPath.row]];
            
        }
    }
    else{
        
        [self.delegate didSelectEventCategory:[_eventNameArray objectAtIndex:indexPath.row]];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}


@end
