//
//  ActivityListViewController.m
//  Hooli
//
//  Created by Er Li on 3/2/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityListViewController.h"
#import "ActivityListCell.h"
#import "ActivityDetailViewController.h"
#import "CreateActivityViewController.h"
#import "ActivityCategoryViewController.h"
@interface ActivityListViewController ()

@property (nonatomic) ActivityCategoryViewController *activityCategoryVC;

@end

@implementation ActivityListViewController
@synthesize activityCategoryVC = _activityCategoryVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"发布"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(postEvent)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"类别"
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(seeCategories)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Activities";
    // Do any additional setup after loading the view.
}

-(void)postEvent{
    
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
    
    
    CreateActivityViewController *postVC = [mainSb instantiateViewControllerWithIdentifier:@"CreateActivityViewController"];
    
    postVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:postVC animated:YES];
    
}

-(void)seeCategories{
    
    _activityCategoryVC = [[ActivityCategoryViewController alloc]init];
    
    _activityCategoryVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_activityCategoryVC animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 145.0f;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"ActivityListCell";
    
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    //    if(cell == nil){
    //
    //        cell = [[ActivityListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    //
    //    }
    
    cell.portraitImageView.layer.cornerRadius = cell.portraitImageView.frame.size.height/2;
    
    cell.portraitImageView.layer.masksToBounds = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"seeActivityDetail" sender:self];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"seeActivityDetail"])
    {
        ActivityDetailViewController *detailVC = segue.destinationViewController;
        detailVC.hidesBottomBarWhenPushed = YES;
    }

    
}
@end
