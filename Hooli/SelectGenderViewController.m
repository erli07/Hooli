//
//  SelectGenderViewController.m
//  Hooli
//
//  Created by Er Li on 2/25/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "SelectGenderViewController.h"
#import "FormManager.h"
#import "OfferCondition.h"
#import "HLTheme.h"
#import "EditProfileDetailViewController.h"
@interface SelectGenderViewController ()
@property (nonatomic) NSArray *array;
@end

@implementation SelectGenderViewController
@synthesize array;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    self.title = @"Gender";
    self.array = @[@"Male", @"Female"];
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
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenderCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GenderCell"];
    }

    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [[FormManager sharedInstance]setProfileGender:[self.array objectAtIndex:indexPath.row]];
    if(self.delegate){
    
        [self.delegate didSelectGender:[self.array objectAtIndex:indexPath.row]];
        
    }
    
    [[[FormManager sharedInstance]profileDetailArray]replaceObjectAtIndex: PROFILE_INDEX_GENDER withObject:[self.array objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
    //[[HLSettings sharedInstance]setCategory:categoryArray];
    
}


@end
