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
@synthesize selectedArray = _selectedArray;
@synthesize isMultipleSelection = _isMultipleSelection;
- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.title = @"活动类别";
    self.title = @"Categories";
    //_eventNameArray = @[@"全部类别", @"吃货小分队", @"体育健身", @"娱乐活动", @"逛街购物", @"户外旅行", @"电子游戏", @"学术会议"];
    _eventNameArray = @[@"All",@"Eating",@"Sports",@"Entertainment", @"Shopping", @"Movie",@"Game",@"Study"];
    
    _eventSymbolsArray = @[[UIImage imageNamed:@"others"],[UIImage imageNamed:@"restaurant-48"],[UIImage imageNamed:@"basketball-48"],[UIImage imageNamed:@"movie-48"],[UIImage imageNamed:@"shopping_bag-48"],[UIImage imageNamed:@"backpack-48"],[UIImage imageNamed:@"controller-48"],[UIImage imageNamed:@"study-48"]];
    
    self.tableView.allowsMultipleSelection = YES;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    
    if([_selectedArray count] > 0){
        
        _selectionArray = [[NSMutableArray alloc]initWithArray:_selectedArray];
    }
    else{
        
        _selectionArray = [NSMutableArray new];

    }
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
    
    if([_selectedArray containsObject:[_eventNameArray objectAtIndex:indexPath.row]] ){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
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
        
        [self.navigationController popViewControllerAnimated:YES];

        [self.delegate didSelectEventCategory:[_eventNameArray objectAtIndex:indexPath.row]];
        
        
    }
    
}


@end
