//
//  ActivityMemberViewController.m
//  Hooli
//
//  Created by Er Li on 3/18/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityMemberViewController.h"
#import "HLConstant.h"
#import "HLTheme.h"
#import "UserCartViewController.h"
#define light_grey [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0]

@interface ActivityMemberViewController ()

@end

@implementation ActivityMemberViewController
@synthesize aObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(id)initWithObject:(PFObject *)_object{
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudEventMemberClass;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of comments to show per page
        self.objectsPerPage = 20;
        
        self.aObject = _object;
        
        self.tableView.scrollEnabled = NO;
    }
    return self;
}


- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kHLEventMemberKeyEvent equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:self.aObject.objectId]];
    [query includeKey:kHLEventMemberKeyMember];
    [query orderByAscending:@"createdAt"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //
    // If there is no network connection, we will hit the cache first.
    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kHLItemDetailsReloadContentSizeNotification object:self];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *kParticipantCellIdentifier = @"ActivityMembertCell";
    
    // Try to dequeue a cell and create one if necessary
    UITableViewCell *memberCell = [tableView dequeueReusableCellWithIdentifier:kParticipantCellIdentifier];
    
    if(memberCell == nil){
        
        memberCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kParticipantCellIdentifier];
        
    }
    
    memberCell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    PFUser *user = [object objectForKey:kHLEventMemberKeyMember];
    
    memberCell.textLabel.text = user.username;
    
    [memberCell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [memberCell.detailTextLabel setFont:[UIFont systemFontOfSize:10.0f]];
    
    memberCell.detailTextLabel.text = [object objectForKey:kHLEventMemberKeyMemberRole];
    
    PFFile *imageFile = [user objectForKey:kHLUserModelKeyPortraitImage];
    
    memberCell.imageView.image = [UIImage imageWithData:[imageFile getData]];
    
    memberCell.imageView.layer.cornerRadius = 16.0f;
    
    memberCell.imageView.layer.masksToBounds = YES;
    
    return memberCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    PFObject *eventMemberObject = [self.objects objectAtIndex:indexPath.row];
    PFUser *member = [eventMemberObject objectForKey:kHLEventMemberKeyMember];
  
    if(member){
        
        [self.delegate didSelectMember:member];
        
    }
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, tableView.frame.size.width, 10)];
    [label setFont:[UIFont boldSystemFontOfSize:11.0f]];
    
    [label setTextColor:[HLTheme textColor]];
    
    [view setBackgroundColor:light_grey]; //your background color...
    
    [view addSubview:label];
    
    [label setText:@"成员"];    
    
    return view;
    
    /* Section header is in 0th index... */
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return @"成员";
    
}

@end
