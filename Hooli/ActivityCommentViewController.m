//
//  ActivityCommentViewController.m
//  Hooli
//
//  Created by Er Li on 3/3/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityCommentViewController.h"
#import "HLConstant.h"
@interface ActivityCommentViewController ()

@end

@implementation ActivityCommentViewController

@synthesize commentTextField;
@synthesize aObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(id)initWithObject:(PFObject *)_object{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudNotificationClass;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of comments to show per page
        self.objectsPerPage = 5;
        
        self.aObject = _object;
        
        self.tableView.scrollEnabled = NO;
    }
    return self;
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
