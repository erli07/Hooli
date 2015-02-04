//
//  FollowListViewController.m
//  Hooli
//
//  Created by Er Li on 2/3/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "FollowListViewController.h"
#import "HLConstant.h"
#import "HLCache.h"
#import "FollowListCell.h"
#import "HLTheme.h"
#import "UserCartViewController.h"
@interface FollowListViewController ()
@end

@implementation FollowListViewController
@synthesize followStatus,fromUser;

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudNotificationClass;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        self.parseClassName = kHLCloudNotificationClass;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
        
    }
    return self;
}


- (void)viewDidLoad {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [FollowListCell heightForCell];
    } else {
        return 44.0f;
    }
}

#pragma mark - PFQueryTableViewController


- (PFQuery *)queryForTable {
    
    //    // Use cached facebook friend ids
    //    NSArray *facebookFriends = [[HLCache sharedCache] facebookFriends];
    //
    //    // Query for all friends you have on facebook and who are using the app
    //    PFQuery *friendsQuery = [PFUser query];
    //    [friendsQuery whereKey:kHLUserFacebookIDKey containedIn:facebookFriends];
    //
    //    // Query for all Parse employees
    //    friendsQuery.cachePolicy = kPFCachePolicyNetworkOnly;
    //    if (self.objects.count == 0) {
    //        friendsQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //    }
    //
    //    [friendsQuery orderByAscending:kHLUserModelKeyUserName];
    
    
    PFQuery *query = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    
    if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWED){
        
        [query includeKey:kHLNotificationFromUserKey];
        [query includeKey:kHLNotificationToUserKey];
        [query whereKey:kHLNotificationFromUserKey equalTo:self.fromUser];
        [query whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
        
    }
    else if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWING){
        
        [query includeKey:kHLNotificationToUserKey];
        [query includeKey:kHLNotificationFromUserKey];
        [query whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
        [query whereKey:kHLNotificationToUserKey equalTo:self.fromUser];
        
    }
    
    [query orderByDescending:@"createAt"];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    //    PFQuery *isFollowingQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
    //    [isFollowingQuery whereKey:kHLNotificationFromUserKey equalTo:[PFUser currentUser]];
    //    [isFollowingQuery whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeFollow];
    //    [isFollowingQuery whereKey:kHLNotificationToUserKey containedIn:self.objects];
    //    [isFollowingQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    //
    //    [isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
    //        if (!error) {
    //            if (number == self.objects.count) {
    //                for (PFUser *user in self.objects) {
    //                    [[HLCache sharedCache] setFollowStatus:YES user:user];
    //                }
    //            } else if (number == 0) {
    //                for (PFUser *user in self.objects) {
    //                    [[HLCache sharedCache] setFollowStatus:NO user:user];
    //                }
    //            }
    //        }
    //
    //    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *FriendCellIdentifier = @"FriendCell";
    
    FollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
    
    if (cell == nil) {
        cell = [[FollowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellIdentifier];
        [cell setDelegate:self];
    }
    
    //cell.textLabel.text = @"test";
    
    PFUser *user;
    
    if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWING){
        
        user = [(PFUser*)object objectForKey:kHLNotificationFromUserKey];
        [cell.followButton setTitle:@"Followed" forState:UIControlStateNormal] ;
        [cell.followButton setTitle:@"Followed" forState:UIControlStateHighlighted];
        [cell.followButton setBackgroundColor:[HLTheme mainColor]];

    }
    else{
        
        user = [(PFUser*)object objectForKey:kHLNotificationToUserKey];
        [cell.followButton setTitle:@"UnFollow" forState:UIControlStateNormal] ;
        [cell.followButton setTitle:@"UnFollow" forState:UIControlStateHighlighted] ;
        
    }
    
    [cell setUser:user];
    
    [cell.subTitle setText:@""];
    
    cell.followButton.selected = NO;
    cell.tag = indexPath.row;
    
    NSDictionary *attributes = [[HLCache sharedCache] attributesForUser:(PFUser *)object];
    
    if (attributes) {
        
        [cell.followButton setSelected:[[HLCache sharedCache] followStatusForUser:(PFUser *)object]];
        
    } else {
        @synchronized(self) {
            
            
            //            [[ActivityManager sharedInstance]getUserRelationshipWithUserOne:[PFUser currentUser] UserTwo:(PFUser *)object WithBlock:^(RelationshipType relationType, NSError *error) {
            //
            //                if(relationType == HL_RELATIONSHIP_TYPE_FRIENDS || relationType == HL_RELATIONSHIP_TYPE_IS_FOLLOWING ){
            //
            //                    [cell.followButton setTitle:@"Followed" forState:UIControlStateNormal] ;
            //                    [cell.followButton setTitle:@"Followed" forState:UIControlStateHighlighted] ;
            //
            //
            //                }
            //                else{
            //
            //                    [cell.followButton setTitle:@"Follow" forState:UIControlStateNormal] ;
            //                    [cell.followButton setTitle:@"Follow" forState:UIControlStateHighlighted] ;
            //
            //                }
            //
            //            }];
        }
    }
    
    
    return cell;
}


- (void)cell:(FollowListCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
    UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    UserCartViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"userCart"];
    vc.userID = aUser.objectId;
    // vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)cell:(FollowListCell *)cellView didTapFollowButton:(PFUser *)aUser {
    
    if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWED){
        
        @synchronized(self) {
            [[ActivityManager sharedInstance]getUserRelationshipWithUserOne:[PFUser currentUser] UserTwo:aUser WithBlock:^(RelationshipType relationType, NSError *error) {
                
                if(relationType == HL_RELATIONSHIP_TYPE_IS_FOLLOWING || relationType == HL_RELATIONSHIP_TYPE_FRIENDS){
                    
                    [[ActivityManager sharedInstance]unFollowUserInBackground:aUser block:^(BOOL succeeded, NSError *error) {
                        
                        if(succeeded){
                            
                            [cellView.followButton setTitle:@"Follow" forState:UIControlStateNormal] ;
                            [cellView.followButton setTitle:@"Follow" forState:UIControlStateHighlighted] ;
                            [cellView.followButton setBackgroundColor:[HLTheme mainColor]];

                        }
                        
                    }];
                }
                else{
                    
                    [[ActivityManager sharedInstance]followUserInBackground:aUser block:^(BOOL succeeded, NSError *error) {
                        
                        if(succeeded){
                            
                            [cellView.followButton setTitle:@"UnFollow" forState:UIControlStateNormal] ;
                            [cellView.followButton setTitle:@"UnFollow" forState:UIControlStateHighlighted] ;
                            [cellView.followButton setBackgroundColor:[UIColor redColor]];


                        }
                        
                    }];
                    
                }
                
            }];
        }
        
    }
    
}

@end
