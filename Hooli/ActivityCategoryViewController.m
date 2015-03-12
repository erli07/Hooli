//
//  ActivityCategoryViewController.m
//  Hooli
//
//  Created by Er Li on 3/9/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityCategoryViewController.h"
#import "HLTheme.h"
@interface ActivityCategoryViewController ()
@property (nonatomic) NSArray *categoryArray;
@property (nonatomic) NSArray *imagesArray;

@end

@implementation ActivityCategoryViewController
@synthesize categoryArray = _categoryArray;
@synthesize imagesArray = _imagesArray;
- (void)viewDidLoad {
    [super viewDidLoad];
 
    _categoryArray = @[@"约饭聚餐",@"看看电影",@"听音乐会",@"爬梯聚会",@"桌游棋牌",@"逛街购物",@"休闲旅行",@"户外露营", @"体育运动",@"电子竞技",@"我爱学习",@"其他"];
    
    _imagesArray = @[[UIImage imageNamed:@"restaurant-48"],[UIImage imageNamed:@"movie-48"],[UIImage imageNamed:@"concert-48"],[UIImage imageNamed:@"party-48"],[UIImage imageNamed:@"poker-cards-48"],[UIImage imageNamed:@"basket-48"],[UIImage imageNamed:@"camera-48"],[UIImage imageNamed:@"backpack-48"],[UIImage imageNamed:@"triathlone-48"],[UIImage imageNamed:@"controller-48"], [UIImage imageNamed:@"study-48"], [UIImage imageNamed:@"others"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activityCategoryCell"];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activityCategoryCell"];
    }
    
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    cell.textLabel.text = [_categoryArray objectAtIndex:indexPath.row];
    cell.imageView.image = [_imagesArray objectAtIndex:indexPath.row];
    return cell;
}

@end
