//
//  CreateActivityViewController.m
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "CreateActivityViewController.h"
#import "FormManager.h"
#import "HLTheme.h"
@interface CreateActivityViewController ()
//@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSArray *titlesArray;
@end

@implementation CreateActivityViewController
@synthesize submitButton = _submitButton;
@synthesize inviteButton = _inviteButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesArray = @[@"Title",@"Detail",@"Location", @"Date"];
    
    self.title = @"发布活动";
    
    [_inviteButton setBackgroundColor:[HLTheme secondColor]];
    
    [_submitButton setBackgroundColor:[HLTheme secondColor]];
    
    
    _inviteButton.tintColor = [UIColor whiteColor];
    
    _submitButton.tintColor = [UIColor whiteColor];
    

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
//    
//    if([[FormManager sharedInstance]eventDetailType]){
//        
//        switch ([[FormManager sharedInstance]eventDetailType]) {
//                
//            case HL_EVENT_DETAIL_NAME:
//                [self.detailsArray replaceObjectAtIndex:0 withObject:[[FormManager sharedInstance]itemName]];
//                break;
//            case HL_EVENT_DETAIL_DESCRIPTION:
//                [self.detailsArray replaceObjectAtIndex:1 withObject:[[FormManager sharedInstance]itemDescription]];
//                break;
//            case HL_EVENT_DETAIL_LOCATION:
//                [self.detailsArray replaceObjectAtIndex:2 withObject:[[FormManager sharedInstance]itemPrice]];
//                break;
//            case HL_EVENT_DETAIL_DATE:
//                [self.detailsArray replaceObjectAtIndex:3 withObject:[[FormManager sharedInstance]itemCategory]];
//                break;
//                
//            default:
//                break;
//        }
//        
//    }
//    
//    [self.tableView reloadData];
//    
}


- (IBAction)submitActivity:(id)sender {
}

- (IBAction)inviteFriends:(id)sender {
}
@end
