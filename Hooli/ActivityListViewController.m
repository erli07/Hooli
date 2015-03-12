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
#import "EventManager.h"
#import "HLConstant.h"
#import "LocationManager.h"
@interface ActivityListViewController ()

@property (nonatomic) ActivityCategoryViewController *activityCategoryVC;

@end

@implementation ActivityListViewController
@synthesize activityCategoryVC = _activityCategoryVC;

@synthesize aObject;


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudEventClass;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
    }
    return self;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query orderByAscending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    
    [super objectsDidLoad:error];

}

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
    
    
    PFObject *eventObject = [[PFObject alloc]initWithClassName:kHLCloudEventClass];
    
    [eventObject setObject:@"title" forKey:kHLEventKeyTitle];
    [eventObject setObject:@"description" forKey:kHLEventKeyDescription];
    [eventObject setObject:[[LocationManager sharedInstance]getCurrentLocationGeoPoint] forKey:kHLEventKeyGeoPoint];
    [eventObject setObject:@"hello" forKey:kHLEventKeyAnnoucement];
    [eventObject setObject:[NSDate date] forKey:kHLEventKeyDate];
    [eventObject setObject:[PFUser currentUser] forKey:kHLEventKeyHost];
    
    PFObject *eventImages = [PFObject objectWithClassName:kHLCloudEventImagesClass];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"Ariel white background"]);
    PFFile *image = [PFFile fileWithName:@"eventImage1.jpg" data:imageData];
    [eventImages setObject:image forKey:@"event_image"];
    [eventObject setObject:eventImages forKey:kHLEventKeyImages];
    
    [[EventManager sharedInstance] uploadEventToCloud:eventObject withBlock:^(BOOL succeeded, NSError *error) {
        
        if(succeeded){
            
            UIAlertView *addCalenderAlert =  [[UIAlertView alloc]initWithTitle:@"" message:@"Successfully posted!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [addCalenderAlert show];
        }
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 145.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *kCellIdentifier = @"ActivityListCell";
    
    ActivityListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell updateCellDetail:object];
    
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
