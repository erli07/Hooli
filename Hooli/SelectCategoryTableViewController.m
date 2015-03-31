//
//  SelectCategoryTableViewController.m
//  Hooli
//
//  Created by Er Li on 11/4/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "SelectCategoryTableViewController.h"
#import "OfferCategory.h"
#import "HLTheme.h"
#import "HLSettings.h"
#import "FormManager.h"
@interface SelectCategoryTableViewController ()

@end

@implementation SelectCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[OfferCategory allCategories]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    cell.textLabel.text = [[OfferCategory allCategories]objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *category= [[OfferCategory allCategories]objectAtIndex:indexPath.row];
    
    [self.delegate didSelectEventCategory:category];
    
    [self.navigationController popViewControllerAnimated:YES];
    //[[HLSettings sharedInstance]setCategory:categoryArray];
    
}



@end
