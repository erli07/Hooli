//
//  ActivityCommentViewController.m
//  Hooli
//
//  Created by Er Li on 3/3/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityCommentViewController.h"
#import "HLConstant.h"
#import "ItemCommentFooterView.h"
#import "BaseTextCell.h"
#import "MBProgressHUD.h"

@interface ActivityCommentViewController ()

@end

static const CGFloat kHLCellInsetWidth = 0.0f;

@implementation ActivityCommentViewController

@synthesize commentTextField;
@synthesize aObject;


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
        self.objectsPerPage = 10;
        
        self.aObject = _object;
        
        self.tableView.scrollEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    
    self.title = @"讨论区";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [super viewDidLoad];
    
    // Set table footer
    ItemCommentFooterView *footerView = [[ItemCommentFooterView alloc] initWithFrame:[ItemCommentFooterView rectForView]];
    commentTextField = footerView.commentField;
    commentTextField.delegate = self;
    self.tableView.tableFooterView = footerView;
    
    // Register to be notified when the keyboard will be shown to scroll the view
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.objects.count) { // A comment row
        

        NSString *commentString = [self.objects[indexPath.row] objectForKey:kHLNotificationContentKey];

        return [BaseTextCell heightForCellWithName:[[PFUser currentUser]objectForKey:kHLUserModelKeyUserName] contentString:commentString cellInsetWidth:kHLCellInsetWidth];
        
    }
    
    // The pagination row
    return 44.0f;
}

#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    [query whereKey:kHLNotificationTypeKey equalTo:kHLNotificationTypeActivityComment];
    
    [query whereKey:kHLNotificationEventKey equalTo:[PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:self.aObject.objectId]];
    
    [query includeKey:kHLNotificationFromUserKey];
    [query includeKey:kHLNotificationToUserKey];
    
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
    
    static NSString *cellID = @"CommentCell";
    
    // Try to dequeue a cell and create one if necessary
    BaseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[BaseTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.cellInsetWidth = kHLCellInsetWidth;
        cell.delegate = self;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [cell addGestureRecognizer:tap];
    
    [cell setUser:[object objectForKey:kHLNotificationFromUserKey]];
    [cell setContentText:[object objectForKey:kHLNotificationContentKey]];
    [cell setDate:[object createdAt]];
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *trimmedComment = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedComment.length != 0) {
        
        PFObject *comment = [PFObject objectWithClassName:kHLCloudNotificationClass];
        [comment setObject:trimmedComment forKey:kHLNotificationContentKey]; // Set comment text
        [comment setObject:[self.aObject objectForKey:kHLEventKeyHost] forKey:kHLNotificationToUserKey]; // Set toUser
        [comment setObject:[PFUser currentUser] forKey:kHLNotificationFromUserKey]; // Set fromUser
        
        [comment setObject:[PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:self.aObject.objectId] forKey:kHLNotificationEventKey];
        [comment setObject:kHLNotificationTypeActivityComment forKey:kHLNotificationTypeKey];

        
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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kHLItemDetailsUserCommentedNotification object:self.aObject userInfo:@{@"comments": @(self.objects.count + 1)}];
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self loadObjects];
        }];
    }
    
    [textField setText:@""];
    return [textField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    
    if([commentTextField isFirstResponder]){
        [[NSNotificationCenter defaultCenter] postNotificationName:kHLItemDetailsLiftCommentViewNotification object:nil userInfo:[note userInfo]];
    }
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


@end
