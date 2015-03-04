//
//  CreateActivityViewController.m
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "CreateActivityViewController.h"
#import "FormManager.h"
@interface CreateActivityViewController ()
//@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSArray *titlesArray;
@end

@implementation CreateActivityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"Title",@"Detail",@"Location", @"Date"];
    self.detailsArray =[NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    
    if([[FormManager sharedInstance]eventDetailType]){
        
        switch ([[FormManager sharedInstance]eventDetailType]) {
                
            case HL_EVENT_DETAIL_NAME:
                [self.detailsArray replaceObjectAtIndex:0 withObject:[[FormManager sharedInstance]itemName]];
                break;
            case HL_EVENT_DETAIL_DESCRIPTION:
                [self.detailsArray replaceObjectAtIndex:1 withObject:[[FormManager sharedInstance]itemDescription]];
                break;
            case HL_EVENT_DETAIL_LOCATION:
                [self.detailsArray replaceObjectAtIndex:2 withObject:[[FormManager sharedInstance]itemPrice]];
                break;
            case HL_EVENT_DETAIL_DATE:
                [self.detailsArray replaceObjectAtIndex:3 withObject:[[FormManager sharedInstance]itemCategory]];
                break;
                
            default:
                break;
        }
        
    }
    
    [self.tableView reloadData];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
