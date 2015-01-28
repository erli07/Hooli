//
//  ItemCommentViewController.m
//  Hooli
//
//  Created by Er Li on 1/19/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ItemCommentViewController.h"
#import "HLConstant.h"
#import "ItemCommentFooterView.h"
#import "NotificationTableViewCell.h"
#import "MBProgressHUD.h"
#import "OffersManager.h"
#import "AccountManager.h"

@interface ItemCommentViewController ()
@property (nonatomic, strong) ItemDetailsHeaderView *headerView;
@property (nonatomic, assign) BOOL likersQueryInProgress;
@end

static const CGFloat kHLCellInsetWidth = 0.0f;

@implementation ItemCommentViewController

@synthesize commentTextField;
@synthesize offer, headerView;

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.offer];
}

- (id)initWithOffer:(OfferModel *)aOffer {
    
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
        
        self.offer = aOffer;
        
        self.likersQueryInProgress = NO;
        
        self.tableView.scrollEnabled = NO;
    }
    return self;
}

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
        self.objectsPerPage = 5;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;

        
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    
//    [[OffersManager sharedInstance]fetchOfferByID:@"EuLwDPinW0" withSuccess:^(id downloadObjects) {
//        
//        self.offer = [[OfferModel alloc]initOfferWithPFObject:downloadObjects];
//        
//    } failure:^(id error) {
//        
//    }];
    

    
    // Set table view properties
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor blackColor];
    self.tableView.backgroundView = texturedBackgroundView;
    
    // Set table footer
    ItemCommentFooterView *footerView = [[ItemCommentFooterView alloc] initWithFrame:[ItemCommentFooterView rectForView]];
    commentTextField = footerView.commentField;
    commentTextField.delegate = self;
    self.tableView.tableFooterView = footerView;
    
    // Register to be notified when the keyboard will be shown to scroll the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidCommentOnPhoto:) name:kHLItemDetailsUserCommentedNotification object:nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedPhoto:) name:kHLUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.offer];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
   // [self.headerView reloadLikeBar];
    
    // we will only hit the network if we have no cached data for this photo
    //    BOOL hasCachedLikers = [[PAPCache sharedCache] attributesForPhoto:self.photo] != nil;
    //    if (!hasCachedLikers) {
    //        [self loadLikers];
    //    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.objects.count) { // A comment row
        
//        PFUser *commentAuthor = (PFUser *)[[self.objects objectAtIndex:indexPath.row] objectForKey:kHLNotificationFromUserKey];
//        
//        //        PFObject *object = [self.objects objectAtIndex:indexPath.row];
//        
//        
        NSString *commentString = [self.objects[indexPath.row] objectForKey:kHLNotificationContentKey];
//        
//        NSString *nameString = @"";
//        if (commentAuthor) {
//            nameString = [commentAuthor objectForKey:kHLUserModelKeyUserName];
//        }
//        
        return [NotificationTableViewCell heightForCellWithName:@"aaaaaaaaaaaaaaaaaa" contentString:commentString cellInsetWidth:kHLCellInsetWidth];
        
    }
    
    // The pagination row
    return 44.0f;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:kHLNotificationOfferKey equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:self.offer.offerId]];
    [query includeKey:kHLNotificationOfferKey];
    [query includeKey:kHLNotificationFromUserKey];
    [query whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeComment];
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
    
//    [self.headerView reloadLikeBar];
    // [self loadLikers];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 20)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    NSString *titleForHeader = [NSString stringWithFormat:@"Comment(%d)",[self.objects count]];
    /* Section header is in 0th index... */
    [label setText:titleForHeader];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]]; //your background color...
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *titleForHeader = [NSString stringWithFormat:@"Comment(%d)",[self.objects count]];
    
    return titleForHeader;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    BaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[BaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.cellInsetWidth = kHLCellInsetWidth;
        cell.delegate = self;
    }
    
    //    cell.textLabel.text =[object objectForKey:kHLNotificationContentKey];
    
    [cell setUser:[object objectForKey:kHLNotificationFromUserKey]];
    [cell setContentText:[object objectForKey:kHLNotificationContentKey]];
    [cell setDate:[object createdAt]];
    
    return cell;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"NextPageDetails";
//
//    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//
//    if (cell == nil) {
//        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.cellInsetWidth = kPAPCellInsetWidth;
//        cell.hideSeparatorTop = YES;
//    }
//
//    return cell;
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedComment.length != 0) {
                
        PFObject *comment = [PFObject objectWithClassName:kHLCloudNotificationClass];
        [comment fetchIfNeeded];
        [comment setObject:trimmedComment forKey:kHLNotificationContentKey]; // Set comment text
        [comment setObject:self.offer.user forKey:kHLNotificationToUserKey]; // Set toUser
        [comment setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey]; // Set fromUser
        [comment setObject:kHLNotificationTypeComment forKey:kHLNotificationTypeKey];
        [comment setObject:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:self.offer.offerId] forKeyedSubscript:kHLNotificationOfferKey];
        
        // [comment setObject:image forKey:kHLOfferModelKeyImage];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        [ACL setWriteAccess:YES forUser:[PFUser currentUser]];
        comment.ACL = ACL;
        
        //  [[PAPCache sharedCache] incrementCommentCountForPhoto:self.photo];
        
        // Show HUD view
        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        
        // If more than 5 seconds pass since we post a comment, stop waiting for the server to respond
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(handleCommentTimeout:) userInfo:@{@"comment": comment} repeats:NO];
        
        [comment saveEventually:^(BOOL succeeded, NSError *error) {
            [timer invalidate];
            
            if (error && error.code == kPFErrorObjectNotFound) {
                //  [[PAPCache sharedCache] decrementCommentCountForPhoto:self.photo];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could not post comment", nil) message:NSLocalizedString(@"This photo is no longer available", nil) delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kHLItemDetailsUserCommentedNotification object:self.offer userInfo:@{@"comments": @(self.objects.count + 1)}];
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self loadObjects];
        }];
    }
    
    [textField setText:@""];
    return [textField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification*)note {
    // Scroll the view to the comment text box
 [[NSNotificationCenter defaultCenter] postNotificationName:kHLItemDetailsLiftCommentViewNotification object:nil userInfo:[note userInfo]];
    
}

-(void)dismissKeyboard {
    [commentTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:kHLItemDetailsPutDownCommentViewNotification object:self];

}

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
}

- (void)userDidCommentOnPhoto:(NSNotification *)note {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(NSInteger )getViewHeight{
    
    [self loadObjects];
    
    [self.tableView layoutIfNeeded];
    
    CGSize tableViewSize=self.tableView.contentSize;
    
    return tableViewSize.height;
}

@end
