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
#import "MyProfileDetailViewController.h"
@interface FollowListViewController ()
@property (nonatomic, strong) UIView *blankView;
@property (nonatomic) NSIndexPath *lastSelected;

@end

@implementation FollowListViewController
@synthesize followStatus,fromUser,blankView;

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
    
    self.title = @"My Relations";
    self.blankView = [[UIView alloc] initWithFrame:self.tableView.bounds];
    [self.blankView setBackgroundColor:[UIColor whiteColor]];
    UILabel *noContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 44)];
    noContentLabel.text = @"No content at the moment";
    noContentLabel.textColor = [UIColor lightGrayColor];
    noContentLabel.font = [UIFont systemFontOfSize:17.0f];
    noContentLabel.textAlignment = NSTextAlignmentCenter;
    [self.blankView addSubview:noContentLabel];
    
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
    
    if (self.objects.count == 0 && ![[self queryForTable] hasCachedResult]) {
        self.tableView.scrollEnabled = NO;
        //  self.navigationController.tabBarItem.badgeValue = nil;
        
        if (!self.blankView.superview) {
            self.blankView.alpha = 0.0f;
            self.tableView.tableHeaderView = self.blankView;
            [UIView animateWithDuration:0.200f animations:^{
                self.blankView.alpha = 1.0f;
            }];
        }
    } else {
        
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
        
    }
    
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser  *user;
    
    if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWED){
        
        user = [[self.objects objectAtIndex:indexPath.row] objectForKey:kHLNotificationToUserKey];
        
    }
    else{
        
        user = [[self.objects objectAtIndex:indexPath.row] objectForKey:kHLNotificationFromUserKey];
        
    }
    
    [self.delegate didSelectUser:user.objectId];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *FriendCellIdentifier = @"FriendCell";
    
    FollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
    
    if (cell == nil) {
        cell = [[FollowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendCellIdentifier];
        [cell setDelegate:self];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
        PFUser *user;
        
        if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWING){
            
            user = [(PFUser*)object objectForKey:kHLNotificationFromUserKey];
            cell.followButton.hidden = YES;
        }
        else if(self.followStatus == HL_RELATIONSHIP_TYPE_IS_FOLLOWED){
            
            user = [(PFUser*)object objectForKey:kHLNotificationToUserKey];
            cell.followButton.hidden = YES;
            
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
    }
    
    return cell;
}


- (void)cell:(FollowListCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
    
    
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
                            [cellView.followButton setBackgroundColor:[HLTheme secondColor]];
                            
                            
                        }
                        
                    }];
                    
                }
                
            }];
        }
        
    }
    
}

@end
