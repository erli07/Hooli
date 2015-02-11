//
//  PostNeedViewController.m
//  Hooli
//
//  Created by Er Li on 12/29/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "PostNeedViewController.h"
#import "LocationManager.h"
#import "FormManager.h"
#import "FormDetailCell.h"
#import "SelectCategoryTableViewController.h"
#import "LocationDetailViewController.h"
#import "HLTheme.h"
#import "FormDetailViewController.h"
#import "NeedsManager.h"

@interface PostNeedViewController ()
@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSMutableArray *conditionArray;

@end

@implementation PostNeedViewController
@synthesize detailsArray = _detailsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _detailsArray =[NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",nil];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    if([[FormManager sharedInstance]detailType]){
        
        switch ([[FormManager sharedInstance]detailType]) {
                
            case HL_ITEM_DETAIL_NAME:
                [_detailsArray replaceObjectAtIndex:0 withObject:[[FormManager sharedInstance]itemName]];
                break;
            case HL_ITEM_DETAIL_DESCRIPTION:
                [_detailsArray replaceObjectAtIndex:1 withObject:[[FormManager sharedInstance]itemDescription]];
                break;
            case HL_ITEM_DETAIL_PRICE:
                [_detailsArray replaceObjectAtIndex:2 withObject:[[FormManager sharedInstance]itemPrice]];
                break;
            case HL_ITEM_DETAIL_CATEGORY:
                [_detailsArray replaceObjectAtIndex:3 withObject:[[FormManager sharedInstance]itemCategory]];
                break;
                
            default:
                break;
        }
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark tableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Post"
                                                  bundle:nil];
    //  [self performSegueWithIdentifier:@"FormDetail" sender:self];
    if(indexPath.section == 0){
        
        FormDetailViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FormDetailViewController"];
        vc.itemDescription = [_detailsArray objectAtIndex:indexPath.section];
        vc.detailType = HL_ITEM_DETAIL_NAME;
        vc.title = @"Title";
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    if(indexPath.section == 1){
        
        FormDetailViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FormDetailViewController"];
        vc.itemDescription = [_detailsArray objectAtIndex:indexPath.section];
        vc.detailType = HL_ITEM_DETAIL_DESCRIPTION;
        vc.title = @"Description";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if(indexPath.section == 2){
        
        FormDetailViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FormDetailViewController"];
        vc.itemPrice = [NSString stringWithFormat:@"$%@",[_detailsArray objectAtIndex:indexPath.section]];
        vc.detailType = HL_ITEM_DETAIL_PRICE;
        vc.title = @"Budget";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else if(indexPath.section == 3){
        
        SelectCategoryTableViewController *vc =  [sb instantiateViewControllerWithIdentifier:@"SelectCategoryTableViewController"];
        vc.title = @"Category";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.section == 4){
        
        NeedsModel *needModel = [[NeedsModel alloc]initNeedModelWithUser:[PFUser currentUser] title:[_detailsArray objectAtIndex:0] description:[_detailsArray objectAtIndex:1] budget:[_detailsArray objectAtIndex:2] category:[_detailsArray objectAtIndex:3]];               
        
        [[NeedsManager sharedInstance]uploadNeedToCloud:needModel block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
                
                UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
                                                                      message:@"You have successfully post your item!"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                [confirmAlert show];

            }
            
        }];
        
    }
    

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     static NSString *CellIdentifier = @"FormDetailCell";
    
    FormDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[FormDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    cell.detailTextLabel.numberOfLines = 10;
    
    cell.detailTextLabel.text = [_detailsArray objectAtIndex:indexPath.section];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.detailTextLabel.text = [_detailsArray objectAtIndex:indexPath.section];
    
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    
    cell.textLabel.textColor = [HLTheme mainColor];

    
    if(indexPath.section == 0){
        
        cell.textLabel.text = @"Title";

    }
    else if(indexPath.section == 1){
        
        cell.textLabel.text = @"Description";
        
    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = @"Budget";
        
    }
    else if(indexPath.section == 3){
        
        cell.textLabel.text = @"Category";
        
    }
    else if(indexPath.section == 4){
        
        cell.textLabel.text = @"Submit";
        
        cell.accessoryType = UITableViewCellAccessoryNone;

        [cell setBackgroundColor:[HLTheme mainColor]];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }

    

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [_detailsArray objectAtIndex:indexPath.section];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14.f];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    
    int numOfLines = (int)size.width / (int)self.tableView.contentSize.width + 1;
    
    CGFloat textHeight = numOfLines * size.height + 10;
    
    CGFloat buffer = size.height * 1.2; //I've found this to be a good buffer
    
    return textHeight + buffer;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  [_detailsArray count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}


@end
