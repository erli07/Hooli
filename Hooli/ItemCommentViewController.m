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
#import "OfferModel.h"
@interface ItemCommentViewController ()
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) ItemDetailsHeaderView *headerView;
@property (nonatomic, assign) BOOL likersQueryInProgress;
@property (nonatomic, strong) OfferModel *offerModel;
@end

static const CGFloat kHLCellInsetWidth = 0.0f;

@implementation ItemCommentViewController

@synthesize commentTextField;
@synthesize offer, headerView,offerModel;

#pragma mark - Initialization

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.offer];
}

- (id)initWithOffer:(PFObject *)aOffer {
    
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // The className to query on
        self.parseClassName = kHLCloudNotificationClass;
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of comments to show per page
        self.objectsPerPage = 30;
        
        self.offer = aOffer;
        
        self.likersQueryInProgress = NO;
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
        self.objectsPerPage = 100;
        
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
        
        self.offer = [[PFObject alloc]initWithClassName:kHLCloudOfferClass];
        
    }
    return self;
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        
        [[OffersManager sharedInstance]fetchOfferByID:@"4RUXyHGWka"
                                          withSuccess:^(id downloadObject) {
                                              
                                              // Dispatch to main thread to update the UI
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  self.offer = downloadObject;
                                                  self.offerModel = [[OfferModel alloc]initOfferDetailsWithPFObject:downloadObject];
                                                  
                                                  
                                              });
                                              
                                          } failure:^(id error) {
                                              
                                              NSLog(@"%@",[error description]);
                                              
                                              
                                          }];
        
    });
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLikedOrUnlikedPhoto:) name:kHLUtilityUserLikedUnlikedPhotoCallbackFinishedNotification object:self.offer];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.headerView reloadLikeBar];
    
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
        return [NotificationTableViewCell heightForCellWithName:@"aaaaaaaaaaaaaaaaa" contentString:commentString cellInsetWidth:kHLCellInsetWidth];
        
    }
    
    // The pagination row
    return 44.0f;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    //   [query whereKey:kHLNotificationPhotoKey equalTo:self.offer];
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
    
    [self.headerView reloadLikeBar];
    // [self loadLikers];
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
    
    if (trimmedComment.length != 0 && [self.offer objectForKey:kHLOfferModelKeyThumbNail]) {
        
        NSData *imageData = UIImagePNGRepresentation(self.offerModel.image);
        PFFile *image = [PFFile fileWithName:@"offer_image.jpg" data:imageData];
        
        PFObject *comment = [PFObject objectWithClassName:kHLCloudNotificationClass];
        [comment setObject:trimmedComment forKey:kHLNotificationContentKey]; // Set comment text
        [comment setObject:self.offerModel.user forKey:kHLNotificationToUserKey]; // Set toUser
        [comment setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey]; // Set fromUser
        [comment setObject:kHLNotificationTypeComment forKey:kHLNotificationTypeKey];
        [comment setObject:[PFObject objectWithoutDataWithClassName:kHLCloudOfferClass objectId:self.offerModel.offerId] forKeyedSubscript:kHLNotificationOfferKey];
        
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

- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.tableView setContentOffset:CGPointMake(0.0f, self.tableView.contentSize.height-kbSize.height) animated:YES];
}

- (void)handleCommentTimeout:(NSTimer *)aTimer {
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Comment", nil) message:NSLocalizedString(@"Your comment will be posted next time there is an Internet connection.", nil)  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Dismiss", nil), nil];
    [alert show];
}

@end
