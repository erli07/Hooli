//
//  SearchItemViewController.m
//  Hooli
//
//  Created by Er Li on 10/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "SearchItemViewController.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "OfferCategory.h"
#import "OffersManager.h"
#import "SearchResultViewController.h"
#import "HLSettings.h"
@interface SearchItemViewController ()
@property (nonatomic) NSArray* imagesArray;
@property (nonatomic) NSArray *categoriesArray;
@end

@implementation SearchItemViewController
@synthesize isMultipleSelection = _isMultipleSelection;
@synthesize categoriesArray = _categoriesArray;
@synthesize selectedArray = _selectedArray;

//@synthesize searchBar;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search";
  //  self.navigationController.navigationBar.backgroundColor = [HLTheme mainColor];
    self.categories = [OfferCategory allCategories];
    
    self.imagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"star"],[UIImage imageNamed:@"furniture"],[UIImage imageNamed:@"homegoods"], [UIImage imageNamed:@"books"],[UIImage imageNamed:@"women_clothes"],[UIImage imageNamed:@"men_clothes"],[UIImage imageNamed:@"computer"],[UIImage imageNamed:@"football"],[UIImage imageNamed:@"baby"],[UIImage imageNamed:@"others"],nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if(_isMultipleSelection){
        
        [self.delegate didSelectItemCategories:_selectedArray];
        
    }
    
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

    
    return [self.categories count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"categoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    [cell.imageView setImage:[self.imagesArray objectAtIndex:indexPath.row]];
     cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    
    if([_selectedArray containsObject:[self.categories objectAtIndex:indexPath.row]] ){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }
    else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(_isMultipleSelection){
        
        if(indexPath.row == 0){
            
            _selectedArray = nil;
            
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        
        if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            
            [_selectedArray removeObject:[self.categories objectAtIndex:indexPath.row]];
            
        }
        else{
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            
            [_selectedArray addObject:[self.categories objectAtIndex:indexPath.row]];
            
        }
        
    }
    else{
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.delegate didSelectItemCategory:[self.categories objectAtIndex:indexPath.row]];
        
        
    }

}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    
//    
//    
//    NSDictionary *filterDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      kHLFilterDictionarySearchKeyWords, kHLFilterDictionarySearchType,
//                                      searchBar.text,kHLFilterDictionarySearchKeyWords,nil];
//    
//    [[OffersManager sharedInstance]setFilterDictionary:filterDictionary];
//
//    
//    [self performSegueWithIdentifier:@"searchResult" sender:self];
//    
//}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    
//    [self.searchBar resignFirstResponder];
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{    
//    [self.searchBar setShowsCancelButton:YES animated:YES];
//}
//
//
//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    [self.searchBar setShowsCancelButton:NO animated:YES];
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if([segue.identifier isEqualToString:@"searchResult"])
    {
        SearchResultViewController *resultVC = segue.destinationViewController;
        resultVC.hidesBottomBarWhenPushed = YES;
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
