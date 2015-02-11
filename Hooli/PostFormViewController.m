//
//  PostFormViewController.m
//  Hooli
//
//  Created by Er Li on 1/11/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "PostFormViewController.h"
#import "FormDetailViewController.h"
#import "HLTheme.h"
#import "FormManager.h"
#import "FormDetailCell.h"
#import "LocationManager.h"
#import "SelectCategoryTableViewController.h"
#import "LocationDetailViewController.h"
#import "HLConstant.h"
#import "MBProgressHUD.h"
#import "ImageCache.h"
#import "OffersManager.h"
#import "ItemDetailViewController.h"
#import "HLSettings.h"
#import "FormManager.h"
@interface PostFormViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSMutableArray *conditionArray;

@end

@implementation PostFormViewController
@synthesize detailsArray = _detailsArray;
@synthesize pickerView = _pickerView;
@synthesize conditionArray = _conditionArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0 , 0 , self.view.bounds.size.width, self.view.bounds.size.height - 88);
    
    self.navigationController.navigationBar.hidden = NO;
    
    self.navigationController.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Submit"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(submitOfferToCloud)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    NSString *address = [[LocationManager sharedInstance]convertedAddress];
    
    _detailsArray =[NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", address,@"", nil];
    
    self.itemLocationCoordinate = [[LocationManager sharedInstance]currentLocation];
    
    [self initConditionPicker];
    
    // Do any additional setup after loading the view.
}


-(void)initConditionPicker{
    
    _conditionArray = [NSMutableArray arrayWithObjects:ITEM_CONDITION_NEW,ITEM_CONDITION_RARELY_USED,ITEM_CONDITION_USED, nil];

    
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 132, self.view.bounds.size.width, 132)];
    
    _pickerView.delegate = self;
    
    _pickerView.dataSource = self;
    
    _pickerView.hidden = YES;
    
    [self.view addSubview:_pickerView];
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
            case HL_ITEM_DETAIL_CONDITION:
                [_detailsArray replaceObjectAtIndex:4 withObject:[[FormManager sharedInstance]itemCondition]];
                break;
            case HL_ITEM_DETAIL_LOCATION:
                [_detailsArray replaceObjectAtIndex:5 withObject:[[FormManager sharedInstance]itemLocation]];
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
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Post"
                                                  bundle:nil];
    //  [self performSegueWithIdentifier:@"FormDetail" sender:self];
    
    if(indexPath.section == 0){
        
        FormDetailViewController* vc = [sb instantiateViewControllerWithIdentifier:@"FormDetailViewController"];
        vc.itemName = [_detailsArray objectAtIndex:indexPath.section];
        vc.detailType = HL_ITEM_DETAIL_NAME;
        vc.title = @"Name";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if(indexPath.section == 1){
        
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
        vc.title = @"Price";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else if(indexPath.section == 3){
        
        SelectCategoryTableViewController *vc =  [sb instantiateViewControllerWithIdentifier:@"SelectCategoryTableViewController"];
        vc.title = @"Category";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if(indexPath.section == 4){
        
        if (_pickerView.hidden == YES) {
            
            _pickerView.hidden = NO;

        }
        else{
            
            _pickerView.hidden = YES;
            
        }
        
    }
    
    else if(indexPath.section == 5){
        
        LocationDetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"LocationDetailViewController"];
        vc.title = @"Item Location";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if(indexPath.section == 6){
     
        [self submitOfferToCloud];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"FormDetail"])
    {
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FormDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FormDetailCell" forIndexPath:indexPath];
    
    cell.detailTextLabel.numberOfLines = 10;
    
    cell.detailTextLabel.text = [_detailsArray objectAtIndex:indexPath.section];
    
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    
    cell.textLabel.textColor = [HLTheme mainColor];
    
    if(indexPath.section == 0){
        
        cell.textLabel.text = @"Name";
        
    }
    else if(indexPath.section == 1){
        
        cell.textLabel.text = @"Description";
        
    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = @"Price";
        
    }
    
    else if(indexPath.section == 3){
        
        cell.textLabel.text = @"Category";
        
    }
    
    else if(indexPath.section == 4){
        
        cell.textLabel.text = @"Condition";
        
    }
    
    else if(indexPath.section == 5){
        
        cell.textLabel.text = @"Item Location";
        
    }
    else if(indexPath.section == 6){
        
        cell.textLabel.text = @"Submit";
        
    }
    
    cell.detailTextLabel.text = [_detailsArray objectAtIndex:indexPath.section];
    

    
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

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _conditionArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _conditionArray[row];
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    [_detailsArray replaceObjectAtIndex:4 withObject:_conditionArray[row]];

    [_pickerView resignFirstResponder];

    _pickerView.hidden = YES;
    
    [self.tableView reloadData];

}



-(void)submitOfferToCloud{

   [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    
    NSArray *imagesArray = [[ImageCache sharedInstance]getimagesArray];
    NSString *itemName = [[FormManager sharedInstance]itemName];
    NSString *itemPrice = [[FormManager sharedInstance]itemPrice];
    NSString *itemCategory = [[FormManager sharedInstance]itemCategory];
    NSString *itemDescription = [[FormManager sharedInstance]itemDescription];
    

    OfferModel *offer = [[OfferModel alloc]initOfferModelWithUser:[PFUser currentUser] imageArray:imagesArray  price:itemPrice offerName:itemName category:itemCategory description:itemDescription location:self.itemLocationCoordinate isOfferSold:[NSNumber numberWithBool:NO] toUser:[[FormManager sharedInstance]toUser]];

    [[OffersManager sharedInstance]updaloadOfferToCloud:offer withSuccess:^{

         [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
        
        [[FormManager sharedInstance]setToUser:nil];
        
        [[HLSettings sharedInstance]setIsRefreshNeeded:YES];

        UIAlertView *confirmAlert = [[UIAlertView alloc]initWithTitle:@"Congratulations!"
                                                              message:@"You have successfully post your item!"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
        [confirmAlert show];

        UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
        ItemDetailViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"detailVc"];
        vc.offerObject = offer;
        vc.isFirstPosted = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController pushViewController:vc animated:YES];
        
    } withFailure:^(id error) {

         [MBProgressHUD hideHUDForView:self.view.superview animated:YES];


    }];

}
@end
